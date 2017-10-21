function d = distance_integral(P, a, b)
%DISTANCE_INTEGRAL   integrates the distance between a point and a line on the x-axes.
% integrates || [x; 0] - P || over x from a to b
% 
% arguments:
%   P: (2x1 vector) the point
%   a: (double) marks the first point of the line [a; 0]
%   b: (double) marks the last point of the line [b; 0]

%% processing

% shift the starting point to the origin

x = b - a;
x_p = P(1) - a;
y_p = P(2);

% if P is on the x-axes itself
if y_p == 0
    % the point is left from the segment
    if x_p <= 0
        d = x.^2/2 - x.*x_p;
    % the point is right from the segment
    elseif x_p >= x
        d = x.*x_p - x.^2/2;
    % the point is on the segment
    else
        d = x_p.^2 - x.*(x_p-x/2);
    end
% P is not on x-axes
else
    % calculate indefinite integral
    A = indefiniteIntegral(0, x_p, y_p);
    B = indefiniteIntegral(x, x_p, y_p);

    d = B - A;
end


% calculates the indefinite integral of the distance between a point
% and a line on the x-axes
% 
% integrates || [x; 0] - [x_p; y_p] ||
% 
% arguments:
%   x:   end of the line on the x-axis
%   x_p: x-coordinate of the point
%   y_p: y-coordinate of the point
function d = indefiniteIntegral(x, x_p, y_p)

l = sqrt((x_p-x).^2 + y_p.^2);
d = ( (x-x_p).*l - y_p^2.*log(l + x_p - x) ) / 2;
