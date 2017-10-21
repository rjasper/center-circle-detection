function consensus = find_consensus(model, segs, direction, err_thr, tau, kappa)
%FIND_CONSENSUS   finds a consensus of the given model among the line segments
%
% arguments:
%   model:     the ellipse model
%   segs:      the line segments
%   direction: the rotating direction of the ellipse (either 'positive',
%              'negative')
%   err_thr:   the maximum normalized focal point distance allowed
%   tau:       the maximum angle spanned by an segment (see filter_angle)
%   kappa:     the maximum angle discrepancy (see filter_angle)
% returns:
%   consensus: the line segments' indices which fulfill the given
%              constraints

import model.*

%% constants

margin = -err_thr;

%% processing

good_angles = filter_angle(model, segs, tau, kappa, direction);
[~, ~, nabs_err, ~] = line_rating(segs(:, good_angles), model, margin);

consensus = good_angles(nabs_err <= err_thr);
