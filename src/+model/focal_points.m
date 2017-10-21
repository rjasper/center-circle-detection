function [F1, F2] = focal_points(ellipse)
%FOCAL_POINTS   calculates the focal points of the given ellipse(s)
%
% arguments:
%   ellipse: the ellipse model
% returns:
%   F1: the first focal point in rho direction
%   F2: the second focal point in rho + pi direction

import model.*

%% convenience variables

[z, a, b, rho] = unpack_ellipse(ellipse);

n = size(ellipse, 2);
r = NaN(2, n);

%% processing

a = sqrt(a.^2 - b.^2);
b = [cos(rho); sin(rho)];

for i = 1:n
    r(:, i) = a(i) * b(:, i);
end

F1 =  r + z;
F2 = -r + z;
