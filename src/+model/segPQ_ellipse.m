function [S1, S2, t1, t2] = segPQ_ellipse(P, Q, model)

import model.*

%% convenience variables

[z, a, b, rho] = unpack_ellipse(model);
% number of line segments
n = size(P, 2);

%% preparation

% transformation matrix
% rotates by -rho and stretches axis by b and a
M = [b*cos(-rho) -b*sin(-rho); a*sin(-rho) a*cos(-rho)];

%% allocation

% the line segment parameter of intersection
t1 = NaN(1, n);
t2 = NaN(1, n);

% the transformed points P' and Q'
P_ = NaN(2, n);
Q_ = NaN(2, n);

%% processing

% transform system so, that the ellipse becomes a centered circle

% the radius of the circle
r = a*b;

% the transformed line segment points
parfor i = 1:n
    P_(:, i) = M * (P(:, i) - z);
    Q_(:, i) = M * Q(:, i);
end

% solve equation ||P' + tQ'|| = r

% prepare abc-equation
A = sum(Q_.^2);
B = 2*sum(P_.*Q_);
C = sum(P_.^2) - r^2;

rad = B.^2 - 4*A.*C;

% disregard imaginary solutions
idx = rad >= 0;
A = A(idx);
B = B(idx);
rad = rad(idx);

% solve for t1 and t2
t1(idx) = ( -B - sqrt(rad) ) ./ (2*A);
t2(idx) = ( -B + sqrt(rad) ) ./ (2*A);

% calculate intersection points in original coordinate system
S1 = P + repmat(t1, 2, 1) .* Q;
S2 = P + repmat(t2, 2, 1) .* Q;
