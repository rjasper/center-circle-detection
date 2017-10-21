function candidates = find_candidates(model, segs, chain, outsiders, direction, tau, kappa)
%FIND_CANDIDATES   tries to find candidates which may support a model constructed by a given chain.
%
% arguments:
%   model:     the ellipse model
%   segs:      the line segments containing the chain and the outsiders to
%              be considered
%   outsiders  the outsiders to be considered to be candidates
%   direction: the rotating direction of the ellipse (either 'positive',
%              'negative')
%   tau:       the maximum angle spanned by an segment (see filter_angle)
%   kappa:     the maximum angle discrepancy (see filter_angle)
% returns:
%   idx:       indices of approved line segments

import model.*

%% convenience variables

z = model.z;

%% processing

% create a shadow from the chain
shadow = shade(z, segs(:, chain));
% filter invisible outsiders which are occluded by the shadow
visible = occlude(segs(:, outsiders), z, shadow);
% remove bad angles
good_angles = filter_angle(model, segs(:, outsiders), tau, kappa, direction);

% return visible line segments with good angles
candidates = outsiders( intersect(visible, good_angles) );
