function [abs_err, rel_err, nabs_err, nrel_err] = line_rating(segs, model, margin)
%LINE_RATING   calculates a rating for line segments.
% 
% The lower the rating the better the chain fits the given ellipse model.
%
% arguments:
%   segs:   the line segments to be rated
%   model:  the ellipse model to be fitted by the segments
%   margin: the target axes difference to compensate angle
%           dependency
% returns:
%   abs_err:  absolute focal point distance error
%   rel_err:  the relative focal point distance error
%   nabs_err: the normalized absolute focal point distance error
%     (normalized by the segment length)
%   nrel_err: the normalized relative focal point distance error
%     (normalized by the segment length)

import model.*

%% convenience variables

[z, a, b, rho] = unpack_ellipse(model);

n_segs = size(segs, 2);

%% preparation

% allocate error vectors
abs_err  = nan(1, n_segs);
rel_err  = nan(1, n_segs);
nabs_err = nan(1, n_segs);
nrel_err = nan(1, n_segs);

% vertical compensation (approximates geometric error)

if margin < -b
    disp('small ellipse');
end

% choose -b as margin if given margin is smaller than -b
margin = max(margin, -b);

%% preprocessing

% compensate vertical error tolerance by transforming the system

% calculate stretching factor

% holds error with positive distance d constant
alpha = sqrt( (2*a + margin) ./ (2*b + margin) );

% no compensation
% leads to high vertical and low horizontal tolerance when a >> b
% alpha = 1;

% holds error with distance -d and d constant (simulates a circle)
% leads to low vertical and high horizontal tolerance when a >> b
% alpha = a/b;

% rotation matrix
% A := R_rho * [1 0; 0 alpha] * R_-rho
A = [ ...
    cos(rho)^2 + alpha * sin(rho)^2  (1-alpha) * cos(rho)*sin(rho)  ; ...
    (1-alpha) * cos(rho)*sin(rho)    sin(rho)^2 + alpha * cos(rho)^2  ...
];

% transform segments
for i = 1:n_segs
    segs(1:2, i) = A * (segs(1:2, i) - z) + z;
    segs(3:4, i) = A * (segs(3:4, i) - z) + z;
end

% transform ellipse
model.b = alpha .* b;

% segment end points
x1 = segs(1, :);
y1 = segs(2, :);
x2 = segs(3, :);
y2 = segs(4, :);

%% processing

% focal points
[F1, F2] = focal_points(model);

% transform for distance integral calculation

delta_x = x2 - x1;
delta_y = y2 - y1;
d = sqrt(delta_x.^2 + delta_y.^2);

cos_alpha =  delta_x./d;
sin_alpha = -delta_y./d;

% translation vector
T = -[x1; y1];

% rotation matrix
R_alpha(1, 1, :) =  cos_alpha;
R_alpha(1, 2, :) = -sin_alpha;
R_alpha(2, 1, :) =  sin_alpha;
R_alpha(2, 2, :) =  cos_alpha;


% calculate ellipse intersection
% this will determine the limits of integration
% the limits are needed to remove the absolute function from the
% integral
[~, ~, t1, t2] = seg_ellipse(segs, model);
x1 = d.*t1;
x2 = d.*t2;

% actual error calculation
for i = 1:n_segs
    % this will integrate the focal points distance error
    % abs_err := Integral of
    % abs(||F1 - P|| + ||F2 - P|| - 2a) with respect to P on the
    % current line segment

    % transform focal points
    F1_TR = R_alpha(:, :, i) * (F1 + T(:, i));
    F2_TR = R_alpha(:, :, i) * (F2 + T(:, i));

    r = 2*a;

    % limits of integration
    x = [x1(i) x2(i)];
    x = [0 x(x > 0 & x < d(i)) d(i)];
    n_x = size(x, 2);

    err = 0;
    for k = 1:n_x-1
        R = r * (x(k+1) - x(k));
        R_1 = distance_integral(F1_TR, x(k), x(k+1));
        R_2 = distance_integral(F2_TR, x(k), x(k+1));

        % interval error
        int_err = abs(R_1 + R_2 - R);

        err = err + int_err;
    end

    abs_err (i) = err;
    rel_err (i) = err / r;
    nabs_err(i) = abs_err(i) / d(i);
    nrel_err(i) = rel_err(i) / d(i);
end
