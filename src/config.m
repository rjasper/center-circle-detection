function cfg = config
%CONFIG   defines the constants used by the center circle algorithm

%% image scaling constants
% the maximum amount of pixels when scaling the input image
cfg.IMAGE_SIZE                    = 640 * 480;

%% field color detection constants
% the range of colors considered 'green'
cfg.FIELD_COLOR_MIN_HUE           =  80 / 360;
cfg.FIELD_COLOR_MAX_HUE           = 220 / 360;
% the resolution of the histogram
cfg.FIELD_COLOR_HUE_HIST_INTERVAL = 4 / 256;
cfg.FIELD_COLOR_SAT_HIST_INTERVAL = 4 / 256;

% the size of the gaussian window used for smoothing
cfg.MAIN_DIST_GAUSSIAN_WIN        = 5;
% constants used to limit the 'main distribution' (see main_dist)
cfg.MAIN_DIST_MIN_GRADIENT        = .1;
cfg.MAIN_DIST_MIN_OCCURENCE       = .1;
cfg.MAIN_DIST_MIN_PEAK_DST        = .2;
cfg.MAIN_DIST_MAX_VALLEY_PEAK     = .8;

%% fitellipse constants
% minimum size of the minor axis (actually half the minor axis)
cfg.FITELLIPSE_BMIN               = 10;

%% sampling constants
% interval of sample points (see sample_points)
cfg.SAMPLE_INTERVAL               = 5;
% angle interval of the polyline used to sample ellipses (see within_ellipse)
cfg.SAMPLE_ELLIPSE_PHI_INTERVAL   = pi/50; % 3.6° or (100 per 2*pi)^-1
% number of points sampled (see within_ellipse)
cfg.WITHIN_ELLIPSE_SAMPLES        = 100;

%% chain detection constants
% tolerance angle
cfg.CHAIN_DETECTION_ALPHA_TOL     = pi/90; % 2°
% maximum angle
cfg.CHAIN_DETECTION_ALPHA_MAX     = pi/2;  % 90°

%% sieve constants
% defining the parameters of the grid samples
cfg.SIEVE_SAMPLE_RECT_VERT_OUTER_WIDTH  = 2; % alpha
cfg.SIEVE_SAMPLE_RECT_VERT_DENSITY      = 2; % n
cfg.SIEVE_SAMPLE_RECT_HORZ_DENSITY      = 5; % m

%% find consensus constants
% the maximum error threshold (LFE)
cfg.FIND_CONSENSUS_MAX_ERR    = 7.5;
% the tau and kappa arguments of given to the filter_angle function
cfg.FIND_CONSENSUS_TAU        = pi;
cfg.FIND_CONSENSUS_KAPPA      = pi/8; % 22.25°

%% find candidates constants
% the tau and kappa arguments of given to the filter_angle function
cfg.FIND_CANDIDATES_TAU    = pi;   % 180°
cfg.FIND_CANDIDATES_KAPPA  = pi/4; %  45°

%% shade constants
% the tolerance angle used to merge 'overlapping' shadows
cfg.SHADE_TOLERANCE               = pi/90; % 2°

%% ransac constants
% number of segments used as seed
cfg.RANSAC_SEED_SIZE              = 3;
% number of iterations
cfg.RANSAC_ITERATIONS             = 20;

%% select consensus constants
% the value to fixate a contour of the PFE field
cfg.SELECT_CONSENSUS_MARGIN       = -10; % delta

%% verification constants
% the constants used to compare the shape and size of to ellipses
cfg.VERIFICATION_AXES_MIN_RATIO   = 0.9;
cfg.VERIFICATION_AXES_MAX_RATIO   = 1.1;
cfg.VERIFICATION_SIZE_MAX_RATIO   = 1.25;
% the ellipse sample interval (row size)
cfg.VERIFICATION_SAMPLE_ELLIPSE_INTERVAL = 5;
% column size when sampling the center circle
cfg.VERIFICATION_PERPENDICULAR_SAMPLES = 21; % should be divisible by 3 and quotient should be odd
% error threshold when to accept a center circle valid
cfg.VERIFICATION_MAX_ERROR        = .03;
% gaussion window parameters to smooth the sampled center circle
cfg.VERIFICATION_GAUSSIAN_HSIZE   = 5;
cfg.VERIFICATION_GAUSSIAN_SIGMA   = 2.5;
