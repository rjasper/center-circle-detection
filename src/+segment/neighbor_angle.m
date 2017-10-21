function alpha = neighbor_angle(segs)
%NEIGHBOR_ANGLE   calculates the angle difference of all line segment pairs
%
% arguments:
%   segs: the line segments
% returns:
%   alpha: (NxN double matrix) the angle differences of the line segments pairs
%          alpha(2, 1) is the difference of segment 1 and segment 2.

%% convenience variables

n = size(segs, 2);

x1 = segs(1, :);
y1 = segs(2, :);
x2 = segs(3, :);
y2 = segs(4, :);

%% processing

phi = atan2(y2-y1, x2-x1);

alpha = nan(n);

for i = 1:n
    % alpha := phi_2 - phi_1
    alpha_i = phi - phi(i);
    
    % correct wrap around
    
    toolow  = alpha_i <= -pi;
    toohigh = alpha_i >   pi;
    
    alpha_i(toolow ) = alpha_i(toolow ) + 2*pi;
    alpha_i(toohigh) = alpha_i(toohigh) - 2*pi;
    
    alpha(:, i) = alpha_i;
end
