function idx = sieve_segs(segs, green_map)
%SIEVES_SEGS   sieves the given set of line segments
% only accepts those which have green pixels on the left side
%
% arguments:
%   segs: segments to be sieved
%   green_map: a logical matrix indicating green and non-green pixels
% returns:
%   idx: indices of approved line segments

import algorithm.*
import segment.*
import utils.*

%% constants

cfg = config;

% outer width in multiple of w
vert_width   = cfg.SIEVE_SAMPLE_RECT_VERT_OUTER_WIDTH;
% vertical sampling density (points per w)
vert_density = cfg.SIEVE_SAMPLE_RECT_VERT_DENSITY;
% horizontal sampling density (points per l)
horz_density = cfg.SIEVE_SAMPLE_RECT_HORZ_DENSITY;

%% convenience variables

% number of segments
n = size(segs, 2);
% image dimensions
[height, width] = size(green_map);

%% processing

idx = false(1, n);

% for each segment
for i = 1:n
    seg = segs(:, i);
    
    % sample coordinates left from the segment
    [pts, ~] = sample_rect(seg, vert_width, vert_density, horz_density);
    pts = round(pts);
    pts = pts(:, within_frame(pts, width, height));
    
    % sample from green map
    sample = sample_matrix(green_map, flipud(pts)');
    
    % accept if at least one pixel is green
    idx(i) = any(sample);
end

idx = find(idx);
