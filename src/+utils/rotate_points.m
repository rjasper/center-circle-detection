function pts = rotate_points(pts, P, alpha)
%ROTATE_POINTS   rotates points around a given center
%
% arguments:
%   pts:   the points to be rotated
%   P:     the center of the rotation
%   alpha: the angle of the rotation
% returns:
%   pts:   the rotated points

%% preparation

% rotation matrix

cos_alpha = cos(alpha);
sin_alpha = sin(alpha);

R(1, 1, :) = +cos_alpha;
R(1, 2, :) = -sin_alpha;
R(2, 2, :) = +cos_alpha;
R(2, 1, :) = +sin_alpha;

%% processing

% shift points so that P is in the origin
pts(1, :) = pts(1, :) - P(1, :);
pts(2, :) = pts(2, :) - P(2, :);

n_alpha = length(alpha);

% apply the rotation
if n_alpha == 1
    pts = R * pts;
else
    parfor i = 1:n_alpha
        pts(:, i) = R(:, :, i) * pts(:, i);
    end
end

% shift back so that P is at its original position
pts(1, :) = pts(1, :) + P(1, :);
pts(2, :) = pts(2, :) + P(2, :);
