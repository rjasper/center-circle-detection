function [pts_l, pts_r] = sample_rect(seg, vert_width, vert_density, horz_density)
%SAMPLE_RECT   samples a rectangle given by an lsd line segment
%
% arguments:
%   seg:          the segment to be sampled
%   width:        the width of the image
%   height:       the height of the image
%   vert_width:   outer width in multiple of w
%   vert_density: vertical sampling density (points per vert_width*w)
%   horz_density: horizontal sampling density (points per l)
% where w = seg(5) and l = line_lengths(seg)
% returns:
%   pts_l: points on the left from the segment
%   pts_r: points on the right from the segment

import segment.*

%% convenience variables

x1 = seg(1);
y1 = seg(2);
x2 = seg(3);
y2 = seg(4);

delta_x = x2 - x1;
delta_y = y2 - y1;

% width of the line segment
w = seg(5);
% length of the line segment
l = line_lengths(seg);

%% preparation

% rotation matrix
R = 1/l * [delta_x -delta_y; delta_y delta_x];
% translation
t = [x1; y1];

% interval between points in x- and y- direction
inter_x = l / horz_density;
inter_y = vert_width * w / vert_density;

% minimum space between sample points and rectangle edges
margin_x = inter_x / 2;
margin_y = inter_y / 2;

%% processing

% sample points
x_pts   = linspace(margin_x, l-margin_x, horz_density);
% y_pts_m = linspace(-(w/2 - margin_y), +(w/2 - margin_y), vert_density);
y_pts_l = linspace(w/2 + margin_y, w/2 + vert_width * w - margin_y, vert_density);
y_pts_r = -y_pts_l;

% rotation and translation
pts_l = transform(x_pts, y_pts_l, R, t);
% pts_m = transform(x_pts, y_pts_m, R, t);
pts_r = transform(x_pts, y_pts_r, R, t);

% builds the points from the x and y values and rotates and translates them
function pts = transform(x, y, R, t)

[X, Y] = meshgrid(x, y);

pts(1, :) = X(:);
pts(2, :) = Y(:);

n = size(pts, 2);
% for each point
for i = 1:n
    % rotate and translate
    pts(:, i) = R * pts(:, i) + t;
end
