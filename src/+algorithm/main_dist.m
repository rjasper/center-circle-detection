function [limit_l, limit_r] = main_dist(Y, y_min, y_max, hist_interval)
%MAIN_DIST   identifies the main distribution of the given input data Y
%
% arguments:
%   Y: input data
%   y_min: minimum Y value to be considered
%   y_max: maximum Y value to be considered
%   hist_interval: the bin size of the underlying histogram analysis
% returns:
%   limit_l: the left limit of the main distribution
%   limit_r: the right limit of the main distribution

%% constants

cfg = config;

% gaussian window size
win_size = cfg.MAIN_DIST_GAUSSIAN_WIN;
% minimum gradient
tol_grad = cfg.MAIN_DIST_MIN_GRADIENT;
% minimum occurence percentage
tol_occ = cfg.MAIN_DIST_MIN_OCCURENCE;
% minimum peak distance
min_peak_dst = cfg.MAIN_DIST_MIN_PEAK_DST;
% maximum valley peak distance ratio
max_valley_peak = cfg.MAIN_DIST_MAX_VALLEY_PEAK;

%% preparation

% gaussian window
win = gausswin(win_size);
win = win / sum(win);

% number of bins
nbins = ceil(1 / hist_interval);

% bin positions
x = linspace(hist_interval/2, 1-hist_interval/2, nbins);
x_inter = (x(1:end-1) + x(2:end)) / 2;

%% processing

% histogram analysis

n = hist(Y, x);
n_smooth = conv(n, win, 'shape');
n_grad = diff(n_smooth);

[n_max, idx_max] = max(n_smooth);

% peak analysis

% this will yield information to seperate the main distribution
% from other distinct peaks

% find local maxima (added padding for border cases)
[~, idx_pks] = findpeaks([0 n_smooth 0]);
% remove padding
idx_pks = idx_pks - 1;
% remove global maximum
idx_pks = setdiff(idx_pks, idx_max);

n_pks = length(idx_pks);

% peaks to be excluded from the main distribution
excluded_pks = false(1, n_pks);
% deepest valleys between the peaks and the global maximum
valley_idxs = NaN(1, n_pks);

% for all maxima
for i = 1:n_pks
    idx = idx_pks(i);
    
    % either right or left from the global maxima
    if idx < idx_max
        a = idx;
        b = idx_max;
    else
        a = idx_max;
        b = idx;
    end
    
    peak = n_smooth(idx);
    
    % find the deepest valley between the peak and the global maximum
    [valley, valley_idx] = min(n_smooth(a+1:b-1));
    
    valley_idxs(i) = (a+1) + valley_idx;
    
    % only consider peaks which have a certain distance to the global
    % maximum and which are distinct enough compared to the valley inbetween
    excluded_pks(i) = ...
        x(b) - x(a) >= min_peak_dst & ...
        valley/peak <= max_valley_peak;
end

% remove minor peaks
valley_idxs = valley_idxs(excluded_pks);
idx_pks = idx_pks(excluded_pks);

% find the nearest peaks next to the global maxima
pk_l = x(valley_idxs( find(idx_pks < idx_max, 1, 'last' ) ));
pk_r = x(valley_idxs( find(idx_pks > idx_max, 1, 'first') ));

% tolerate only a minimum negative (resp. positive) gradient to the left
% (resp. right)
grad_l = x_inter( find(n_grad(1:idx_max-1)/n_max < -tol_grad, 1, 'last' )               );
grad_r = x_inter( find(n_grad(idx_max:end)/n_max >  tol_grad, 1, 'first') + idx_max - 1 );

% tolerate only a minimum occorences level
occ_l = x( find(n_smooth(1:idx_max-1)/n_max < tol_occ, 1, 'last' )               ) - hist_interval/2;
occ_r = x( find(n_smooth(idx_max:end)/n_max < tol_occ, 1, 'first') + idx_max - 1 ) + hist_interval/2;

% select the nearest limits
limit_l = max([y_min, pk_l, grad_l, occ_l]);
limit_r = min([y_max, pk_r, grad_r, occ_r]);
