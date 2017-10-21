function valid = validate_model(model, segs, direction, err_thr, tau, kappa)
%VALIDATE_MODEL   validates if a model is supported by the given line segments
%
% arguments:
%   model:     the ellipse model to be validated
%   segs:      the line segments supposed to support the model
%   direction: the rotating direction of the ellipse (either 'positive',
%              'negative')
%   err_thr:   the maximum normalized relative error (see line_rating)
%   tau:       the maximum angle spanned by an segment (see filter_angle)
%   kappa:     the maximum angle discrepancy (see filter_angle)
% returns:
%   models:    set of verified models

import model.*

%% convinience variables

n = size(segs, 2);

%% processing

consensus = find_consensus(model, segs, direction, err_thr, tau, kappa);

valid = all(ismember(1:n, consensus));
