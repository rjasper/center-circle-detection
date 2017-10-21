function field_color_map = field_color_detection(hsv)
%FIELD_COLOR_DETECTION   tries to identify the field color
%
% arguments:
%   hsv: hsv image
% returns:
%   field_color_map: logical array indicating which pixels are considered
%       to belong to the field

import algorithm.*

%% constants

cfg = config;

h_filt_min = cfg.FIELD_COLOR_MIN_HUE;
h_filt_max = cfg.FIELD_COLOR_MAX_HUE;

h_hist_interval = cfg.FIELD_COLOR_HUE_HIST_INTERVAL;
s_hist_interval = cfg.FIELD_COLOR_SAT_HIST_INTERVAL;

%% preparation

h = hsv(:, :, 1);
s = hsv(:, :, 2);

%% processing

% filter non-green/blue colors
h_filt = h_filt_min <= h & h <= h_filt_max;

% find main hue distribution
[h_l, h_r] = main_dist(h(h_filt(:)), h_filt_min, h_filt_max, h_hist_interval);

% extract main hue distribution colors
h_filt2 = h_l <= h & h <= h_r;

% find main saturation distribution
[s_l, s_r] = main_dist(s(h_filt2(:)), 0, 1, s_hist_interval);

% main hue and saturation distribution color map
field_color_map = ...
    h_l <= h & h <= h_r & ...
    s_l <= s & s <= s_r;

