function visible = occlude(segs, p, shadow)
%OCCLUDE   occludes any line segments which are not visible due to shadow
%
% arguments:
%   segs: the line segments to be occluded
%   p   : the light source
%   shadow: the shadow parts represented as angles originating from p
% returns:
%   visible: the indices of visible segments

%% convenience variables

x1 = segs(1, :);
y1 = segs(2, :);
x2 = segs(3, :);
y2 = segs(4, :);

n = size(segs, 2);

p_x = p(1);
p_y = p(2);

m = size(shadow, 2);

%% preparation

phi = [atan2(y1 - p_y, x1 - p_x); atan2(y2 - p_y, x2 - p_x)];

phi1 = phi(1, :);
phi2 = phi(2, :);

%% processing

visibility = false(m, n);

% for each shadow part
% check vor visibility
for i = 1:m
    if shadow(1, i) < shadow(2, i)
        visibility(i, :) = ...
            not( shadow(1, i) <= min(phi1, phi2) & shadow(2, i) >= max(phi1, phi2) );
    else
        visibility(i, :) = ...
            ( shadow(2, i) <= phi1 & shadow(1, i) >= phi1 ) | ...
            ( shadow(2, i) <= phi2 & shadow(1, i) >= phi2 );
    end
end

visible = find(sum(~visibility, 1) == 0);
