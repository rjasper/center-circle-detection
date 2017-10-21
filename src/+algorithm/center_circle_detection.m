function models = center_circle_detection(img, segs)
%CENTER_CIRCLE_DETECTION   performs the center circle detection algorithm
% 
% arguments:
%   img: the input image
%   segs: the line segments

import algorithm.*
import model.*
import segment.*
import utils.*

%% constants

cfg = config;

alpha_tol = cfg.CHAIN_DETECTION_ALPHA_TOL;
alpha_max = cfg.CHAIN_DETECTION_ALPHA_MAX;

%% init

models = struct('z', {}, 'a', {}, 'b', {}, 'rho', {});

%% preparation
disp('preparing ...');

hsv = rgb2hsv(img);
[height, width, ~] = size(img);

gray = double(rgb2gray(img)) / 256;

%% processing
display('processing ...');

display('  detecting field color ...');
green_map = field_color_detection(hsv);

display('  sieving line segments ...');
sieved = sieve_segs(segs, green_map);
segs = segs(:, sieved);

if isempty(segs)
    return
end

n = size(segs, 2);

display('  detecting line segment chains ...');
% right turn
chains_r1 = detect_chains(segs, -alpha_tol, alpha_max);
% left turn
chains_l1 = detect_chains(segs, -alpha_max, alpha_tol);

display('  merging ellipses ...');
chains_r2 = merge_chains(chains_r1, segs, 'positive');
chains_l2 = merge_chains(chains_l1, segs, 'negative');

display('  expanding chains ...');
outsiders = setdiff(1:n, merge([chains_l2 chains_r2]));
chains_r3 = extend_chains(chains_r2, segs, outsiders, 'positive');
chains_l3 = extend_chains(chains_l2, segs, outsiders, 'negative');

display('  verifying ellipses ...');
models_r = fitellipse_segs(chains_r3, segs);
models_l = fitellipse_segs(chains_l3, segs);
models = verify_models(gray, green_map, models_l, models_r, width, height);


%% done
display('done!');
