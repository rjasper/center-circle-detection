function shadow = shade(p, segs)
%SHADE   calculates angles from the given point to the line segments
% 
% arguments:
%   p: the origin of the 'light source'
%   segs: the line segments
% returns:
%   shadow: the angles of the shadows which the segments produce

%% constants

cfg = config;

thr = cfg.SHADE_TOLERANCE;

%% convenience variables

p_x = p(1);
p_y = p(2);

x1 = segs(1, :);
y1 = segs(2, :);
x2 = segs(3, :);
y2 = segs(4, :);

n = size(segs, 2);

%% processing

phi1 = atan2(y1 - p_y, x1 - p_x);
phi2 = atan2(y2 - p_y, x2 - p_x);

% detect segments with reversed orientation
phi12 = phi2 - phi1;
reverse = xor(phi12 < 0, abs(phi12) > pi);

% "turn" segments
tmp = phi1(reverse);
phi1(reverse) = phi2(reverse);
phi2(reverse) = tmp;

% sort segments by angle
[phi1, idx] = sort(phi1);
phi2 = phi2(idx);

% rare case: lines orthogonal to p don't produce shadows
spanning = phi1 ~= phi2;
phi1 = phi1(spanning);
phi2 = phi2(spanning);

% angle between second angle of the current and first angle of the next
% shadow
delta_phi = ...
    mod(phi2(1:end-1) - phi1(1:end-1), 2*pi) - ...
    mod(phi1(2:end  ) - phi1(1:end-1), 2*pi);

% check for overlappings
overlap = delta_phi >= -thr;

% search for non overlapping shadows
splits = [0 find(~overlap) n];

% merge overlapping shadows
a = splits(1:end-1) + 1;
b = splits(2:end);
shadow = [phi1(a); phi2(b)];

%% wrap around

% if shadow spans over the whole angle space
if mod(phi2(1) - phi1(1), 2*pi) >= 2*pi - thr
    shadow = [-pi; +pi];
% if first and last shadows overlap
elseif mod(phi1(1) - phi2(end), 2*pi) <= thr
    shadow(1, 1) = shadow(1, end);
    shadow = shadow(:, 1:end-1);
end
