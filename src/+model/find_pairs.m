function pairs = find_pairs(models_l, models_r)
%FIND_PAIRS   finds pairs of left and right rotating ellipses
% 
% ellipses considered to be pairs need to fulfill the following conditions:
% - the right rotating ellipse must be within the left rotating one
% - the axes of the right rotating ellipse must be at least half as big
%   as the left rotating one.
%
% arguments:
%   models_l: a 1xL struct array consisting of ellipse parameters
%   models_r: a 1xR struct array consisting of ellipse parameters
% returns:
%   pairs: a 2xP matrix containing the indices of the pairs found,
%      where P is in the range of 0 and L*R.

import model.*

%% constants

cfg = config;

min_axes_ratio = cfg.VERIFICATION_AXES_MIN_RATIO;
max_axes_ratio = cfg.VERIFICATION_AXES_MAX_RATIO;
max_size_ratio = cfg.VERIFICATION_SIZE_MAX_RATIO;

%% convenience variables

L = length(models_l);
R = length(models_r);

%% processing

pairs = false(L, R);

for l = 1:L
    [~, a1, b1, ~] = unpack_ellipse(models_l(l));
    for r = 1:R
        [~, a2, b2, ~] = unpack_ellipse(models_r(r));
        
        ratio = (a1 / b1) / (a2 / b2);
        
        pairs(l, r) = ...
            min_axes_ratio <= ratio && ratio <= max_axes_ratio && ...
            max(a1 / a2, b1 / b2) <= max_size_ratio && ...
            within_ellipse(models_l(l), models_r(r));
    end
end

% convert logical matrix to indices
[ind1, ind2] = find(pairs);
if size(pairs, 1) == 1 % weird matlab stuff :P
    % for some reason the behaviour of 'find' is different for row vectors
    % which has to be taken into account
    pairs = [ind1' ind2']';
else
    pairs = [ind1 ind2]';
end
