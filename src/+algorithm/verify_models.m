function models = verify_models(gray, green_map, models_l, models_r, width, height)
%VERIFY_MODELS   verifies models lying in the given input image
%
% arguments:
%   gray:      an gray map of the input image (uses double values from 0 to 1)
%   green_map: a logical map indicating green pixels of the input image
%   models_r:  right rotating ellipse models
%   models_l:  left rotation ellipse models
%   width:     width of the input image
%   height:    height of the input image
% returns:
%   models:    set of verified models

import algorithm.*
import model.*
import utils.*

%% constants

cfg = config;

% ellipse sample interval
sample_ellipse_interval = cfg.VERIFICATION_SAMPLE_ELLIPSE_INTERVAL;
% amount of perpendicular samples
perpendicular_samples = cfg.VERIFICATION_PERPENDICULAR_SAMPLES;
% maximum maximum error
max_error = cfg.VERIFICATION_MAX_ERROR;

% gaussian kernel parameters
gaussian_hsize = cfg.VERIFICATION_GAUSSIAN_HSIZE;
gaussian_sigma = cfg.VERIFICATION_GAUSSIAN_SIGMA;

%% preparation

% gaussian kernel, smoothes sample
gaussian = fspecial('gaussian', gaussian_hsize, gaussian_sigma);

%% processing

% find pair candidates

pairs = find_pairs(models_l, models_r);

if isempty(pairs)
    models = struct('z', {}, 'a', {}, 'b', {}, 'rho', {});
    return
end

P = size(pairs, 2);

models_l = models_l(pairs(1, :));
models_r = models_r(pairs(2, :));

% verify pairs

% calculate inner, outer and middle ellipses
merged = merge_models(models_l, models_r);

verified = false(1, P);

% for each pair
for p = 1:P
    % calculate seed sample points
    model_r = models_r(p);
    model_l = models_l(p);
    
    % calculate points from the inner perimenter ellipse
    pts1 = sample_ellipse(model_r, 'interval', sample_ellipse_interval);
    pts1 = pts1(:, within_frame(pts1, width, height));
    
    % calculate intersection with outer ellipse of perpendiculars
    
    % calculate perpendicular angle
    [z, a, b, rho] = unpack_ellipse(model_r);
    pts_T = rotate_points(pts1, z, -rho);
    x_T = pts_T(1, :) - z(1);
    y_T = pts_T(2, :) - z(2);
    alpha = mod( atan2( -a^2 * y_T, -b^2 * x_T ) + rho, 2*pi );
    % intersection with outer ellipse
    [pts2, ~, ~, ~] = ray_ellipse(pts1, alpha, model_l);
    
    delta_pts = pts2 - pts1;
    pts01 = pts1 - delta_pts;
    pts02 = pts2 + delta_pts;
    
    % filter points outside of the image frame
    inside = within_frame(pts01, width, height) & within_frame(pts02, width, height);
    pts01 = pts01(:, inside);
    pts02 = pts02(:, inside);
    
    % calculate intermediate sample points
    
    n_pts = size(pts01, 2);
    pts = NaN(perpendicular_samples, n_pts, 2);
    
    for i = 1:n_pts
        pts(:, i, 2) = round( linspace(pts01(1, i), pts02(1, i), perpendicular_samples) );
        pts(:, i, 1) = round( linspace(pts01(2, i), pts02(2, i), perpendicular_samples) );
    end
    
    % sampling
    
    % only consider columns which include green pixels in the lower and
    % upper half
    green_samples = sample_matrix(green_map, pts);
    
    half = perpendicular_samples / 2;
    upper_half = green_samples(1:floor(half), :);
    lower_half = green_samples(ceil(half):end, :);
    include_green = any(upper_half, 1) & any(lower_half, 1);
    
    % if there are any green pixels
    if any(include_green)
        % sample gray map and smooth
        % only consider columns containing green pixels
        sample = sample_matrix(gray, pts(:, include_green, :));
        smoothed = imfilter(sample, gaussian, 'replicate');
        
        % find maxima of every column
        [~, s_ind] = max(smoothed, [], 1);
        
        % calculate the error of the maximum positions
        error = 1/size(sample, 2) * sum( (3 / (size(sample, 1)-1) * (s_ind-1) - 1.5).^2 );
                
        % allow only a maximum error for positive verification
        verified(p) = error <= max_error;
    else
        verified(p) = false;
    end
end

% disregard unverified models
models = merged(verified);
