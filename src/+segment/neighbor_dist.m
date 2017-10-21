function d = neighbor_dist(segs)
%NEIGHBOR_DIST   calculates the distances of the given line segments to each other
%
% arguments:
%   segs: the line segments
% returns:
%   d: (NxN double matrix) the distances from each segment to each other one
%      d(2, 1) is the distance from the end point of segment 1 to the start
%      point of segment 2

%% convenience variables

n = size(segs, 2);

x1 = segs(1, :);
y1 = segs(2, :);
x2 = segs(3, :);
y2 = segs(4, :);

%% processing

d = nan(n);

for i = 1:n
    d(:, i) = sqrt( (x2(i)-x1).^2 + (y2(i)-y1).^2 );
end
