function idx = filter_angle(model, segs, tau, kappa, direction)
%FILTER_ANGLE   filters the given segments by their angle considering the ellipse model
% 
% arguments:
%   model:     the ellipse model to be considered
%   segs:      the line segments to be filtered
%   tau:       the maximum angle spanned by an segment (see filter_angle)
%   kappa:     the maximum angle discrepancy (see filter_angle)
%   direction: the rotating direction of the ellipse (either 'positive',
%              'negative')
% returns:
%   idx:       indices of approved line segments

import model.*

%% convenience variables

[z, a, b, rho] = unpack_ellipse(model);

n = size(segs, 2);

%% preparation

% centers the ellipse where z* = [0 0] and rho = 0

% translation vector
T = -z;

cos_alpha =  cos(rho);
sin_alpha = -sin(rho);

% rotation matrix
R_alpha = [ ...
    cos_alpha -sin_alpha; ...
    sin_alpha  cos_alpha];

% transform segments
% for each vector
for i = 1:n
    % first translate than rotate
    segs(1:2, i) = R_alpha * (segs(1:2, i) + T);
    segs(3:4, i) = R_alpha * (segs(3:4, i) + T);
end

switch direction
    case 'positive'
        x1 = segs(1, :);
        y1 = segs(2, :);
        x2 = segs(3, :);
        y2 = segs(4, :);
    case 'negative'
        x1 = segs(3, :);
        y1 = segs(4, :);
        x2 = segs(1, :);
        y2 = segs(2, :);
    otherwise
        error('direction must be ''positive'' or ''negative''');
end

delta_x = x2 - x1;
delta_y = y2 - y1;

phi1 = atan2(  a^2*y1,  b^2*x1);
phi2 = atan2(  a^2*y2,  b^2*x2);
phi  = atan2(-delta_x, delta_y);

%% processing

within_tau = mod(phi2 - phi1, 2*pi) <= tau;
within_phi12 = mod(phi - phi1 + kappa, 2*pi) <= mod(phi2 - phi1 + 2*kappa, 2*pi);

idx = find(within_tau & within_phi12);
