function within = within_frame(pts, width, height)
%WITHIN_FRAME   determines if the given points are within the specified frame
% 
% arguments:
%   pts:    the points to be checked
%   width:  the width of the frame
%   height: the height of the frame
% returns:
%   within: a logic vector indicating which points are within the frame

%% convenience variables

x = pts(1, :);
y = pts(2, :);

%% processing

within = ...
    1 <= x & x <= width & ...
    1 <= y & y <= height;
