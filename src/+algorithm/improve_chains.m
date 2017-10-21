function [improved, idx] = improve_chains(chains, segs, direction)
%IMPROVE_CHAINS   removes outliers from the given chains using ransac
%
% arguments:
%   chains: a cell array containing the chain line segment indices
%   segs: the line segments
%   direction: the rotating direction of the ellipse (either 'positive',
%              'negative')
% returns:
%   improved: the improved chains' line segment indices
%   idx: the indices of the chains improved, indicating the position of the
%        original chains that were validated

import model.*
import algorithm.*

%% constants

cfg = config;

val_max_err = cfg.FIND_CONSENSUS_MAX_ERR;
val_tau     = cfg.FIND_CONSENSUS_TAU;
val_kappa   = cfg.FIND_CONSENSUS_KAPPA;

S = cfg.RANSAC_SEED_SIZE;

%% processing

improved = cell(size(chains));

[models, fit_idx] = fitellipse_segs(chains, segs);

N = size(chains, 2);
M = size(models, 2);

% for each chain with model, validate model
valid_models = false(1, N);
for i = 1:M
    c = fit_idx(i);
    chain = chains{c};
    model = models(i);
    
    if validate_model(model, segs(:, chain), direction, val_max_err, val_tau, val_kappa);
        improved{c} = chain;
        valid_models(c) = true;
    end
end

% for each chain without valid model, try ransac
for c = find(~valid_models)
    chain = chains{c};
    
    % if the chain didn't produce a valid model with three segments it also
    % won't with even less
    if length(chain) <= S
        continue
    end
    
    improved{c} = chain( ransac_chain(segs(:, chain), direction) );
    
    if ~isempty(improved{c})
        valid_models(c) = true;
    end
end

% diregard invalid models
improved = improved(valid_models);

idx = find(valid_models);
