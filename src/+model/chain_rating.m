function [abs_err, rel_err, nabs_err, nrel_err] = chain_rating(segs, model, margin)
%CHAIN_RATING   calculates a rating for a chain of line segments. The lower the rating
% the better the chain fits the given ellipse model.
%
% arguments:
%   segs:   the chain of line segments
%   model:  the ellipse model to be fitted by the chain
%   margin: the target axes difference to compensate angle
%           dependency
% returns:
%   abs_err:  absolute focal point distance error
%   rel_err:  the relative focal point distance error
%   nabs_err: the normalized absolute focal point distance error
%     (normalized by the chain length)
%   nrel_err: the normalized relative focal point distance error
%     (normalized by the chain length)

import model.*
import segment.*

%% processing

[abs_errs, rel_errs, ~, ~] = line_rating(segs, model, margin);

% chain length
l = sum( line_lengths(segs) );

abs_err = sum(abs_errs);
rel_err = sum(rel_errs);
nabs_err = abs_err / l;
nrel_err = rel_err / l;
