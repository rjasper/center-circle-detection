function pts = sample_polyline(polyline, mode, value)
%SAMPLE_POLYLINE   samples some points from a poly line
%
% arguments:
%   polyline: the poly line to be sampled
%   mode: either 'fix' for a fix number of sample points or
%         'interval' for a constant interval distance between the points
%   value: the value of either the number of sample points or the interval
% returns:
%   pts: the sampled points

import utils.*

%% convenience variables

% number of poly lines
n = size(polyline, 2) - 1;

%% preparation

% vectors of each line segment
delta_polyline = diff(polyline, 1, 2);
% lengths of each line segment
l = sqrt(sum(delta_polyline.^2));
% cumulative lengths
L = [0 cumsum(l)];
L1 = L(1:end-1);
L2 = L(2:end);
% total length
L_max = L(end);

switch mode
    case 'interval'
        % the interval between two points
        interval = value;
        % number of sample points to be taken
        N = floor(L_max / interval) + 1;
        % margin to center the sample points on the poly line
        margin = mod(L_max, interval) / 2;
    case 'fix'
        % number of sample points to be taken
        N = value;
        % the interval between two points
        interval = L_max / N;
        % margin to center the sample points on the poly line
        margin = interval / 2;
    otherwise
        error('mode must either be ''interval'' or ''fix''');
end

% sample point allocation
pts = cell(1, n);

%% processing

% relative sample points (linearized)
t = linspace(margin, L_max - margin, N);

% for each segment
parfor i = 1:n
    % relevant sample points
    idx = L1(i) <= t & t < L2(i);
    % normalize for current segment
    t_i = (t(idx) - L1(i)) / l(i);
    % number of sample points of the curent segment
    nn = length(t_i);
    
    % some convenience variables
    p_rep   = repmat( polyline      (:, i) , 1, nn );
    q_rep   = repmat( delta_polyline(:, i) , 1, nn );
    t_i_rep = repmat( t_i , 2, 1 );
    
    % calculate sample points of the current segment
    pts{i} = p_rep + t_i_rep .* q_rep;
end

%% post processing

pts = merge(pts);

% special case: last point omitted due to zero margin
if margin == 0
    pts = [pts polyline(:, end)];
end
