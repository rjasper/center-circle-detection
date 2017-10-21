function within = within_ellipse(model1, model2)
%WITHIN_ELLIPSE   checks if a ellipse is within another one
%
% arguments:
%   model1: the ellipse which is to be expected to include model2
%   model2: the ellipse which is to be expected within model1
% returns:
%   within: true, if model2 is within model1, else false

import model.*

%% constants

cfg = config;

samples = cfg.WITHIN_ELLIPSE_SAMPLES;

%% convenience variables

a1 = model1.a;

%% processing

% This will check if a number of sample points from model2 are within model1.
% Therefore we calculate the distances to the focal points of model1 and
% see if the sum is lower than or equal to 2*a1.

[F1, F2] = focal_points(model1);

% calculates the position of the sample points

P = sample_ellipse(model2, 'fix', samples);

% calculates the distance to the focal points

d1_sq = sum((P - repmat(F1, 1, samples)).^2, 1);
d2_sq = sum((P - repmat(F2, 1, samples)).^2, 1);
d = sqrt(d1_sq) + sqrt(d2_sq);

% checks the condition

within = all(d <= 2*a1);
