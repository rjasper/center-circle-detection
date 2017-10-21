function models = ccd(img_file, varargin)
%CCD  loads an image file and applies the center circle detection algorithm
%
% syntax:
%    ccd <img_file> [options]
%
% arguments:
%   img_file: the image file
%   varargin:
%     '--show':     shows the detected center circle in the image
%     '--noscale':  suppresses the scaling of the image before processing
%     '--override': overrides previously generated files (*.scl.* and *.lsd)
%
% example:
%   ccd my-picture.jpg --noscale --show

import model.*
import algorithm.*
import plot.*

%% constants

cfg = config;

LSD_BIN = 'lsd';
LSD_EXT = '.lsd';
SCALE_EXT = '.scl';

IMG_SIZE = cfg.IMAGE_SIZE;

%% parse options

show_set     = any(strcmp(varargin, '--show'    ));
noscale_set  = any(strcmp(varargin, '--noscale' ));
override_set = any(strcmp(varargin, '--override'));

%% data fetch

[img_path, img_name, img_ext] = fileparts(img_file);
if isempty(img_path)
    img_path = '.';
end

scale_file = [img_path '/' img_name SCALE_EXT img_ext];

img_org = imread(img_file);

% try to load scaled image
if ~noscale_set && ~override_set && exist(scale_file, 'file')
    img = imread(scale_file);
    scale = sqrt(numel(img) / numel(img_org));
    scaled = true;
else
    % scale image if necessary
    
    [height, width, ~] = size(img_org);
    pixels = width * height;

    if ~noscale_set && pixels > IMG_SIZE
        scale = sqrt(IMG_SIZE / pixels);
        img = imresize(img_org, scale);
        imwrite(img, scale_file);
        scaled = true;
    else
        img = img_org;
        scale = 1;
        scaled = false;
    end
end

% lsd_file path
if scaled
    lsd_file = [img_path '/' img_name SCALE_EXT LSD_EXT];
else
    lsd_file = [img_path '/' img_name LSD_EXT];
end

% compute lsd file if necessary
if override_set || ~exist(lsd_file, 'file')
    if scaled
        command = [LSD_BIN ' "' scale_file '" "' lsd_file '"'];
    else
        command = [LSD_BIN ' "' img_file '" "' lsd_file '"'];
    end

    display([command '']);
    system(command);
end

segs = lsd_read(lsd_file);

%% processing

models = center_circle_detection(img, segs);

%% post processing

% retrieve unscaled model
if scaled && ~isempty(models)
    params = [[models.z]-1; models.a; models.b] / scale;
    params(1:2, :) = params(1:2, :) + 1; % stupid matlab indexing :P
    params = mat2cell(params, [2 1 1]);

    models = struct('z', params(1), 'a', params(2), 'b', params(3), 'rho', {models.rho});
end
        
%% show

if show_set
    was_hold = ishold;
    
    imshow(img_org);
    hold on;
    plot_ellipses(models);
    if ~was_hold
        hold off;
    end
end
