function improved = ransac_chain(segs, direction)
%RANSAC_CHAIN   performs a RANSAC algorithm on set of line segments
% 
% This will remove segments from the set which badly approximate an
% ellipse model.
%
% arguments:
%   segs: the line segments
%   direction: the rotating direction of the ellipse (either 'positive',
%              'negative')
% returns:
%   improved: the improved chains' line segment indices

import model.*
import utils.*

%% constants

cfg = config;

% size of the initial seed
S = cfg.RANSAC_SEED_SIZE;
% number of iterations
I = cfg.RANSAC_ITERATIONS;

seed_max_err = cfg.FIND_CONSENSUS_MAX_ERR;
seed_tau     = cfg.FIND_CONSENSUS_TAU;
seed_kappa   = cfg.FIND_CONSENSUS_KAPPA;

cons_max_err = cfg.FIND_CONSENSUS_MAX_ERR;
cons_tau     = cfg.FIND_CONSENSUS_TAU;
cons_kappa   = cfg.FIND_CONSENSUS_KAPPA;

%% convenient variables

n = size(segs, 2);

%% random set generation

if n <= S
    error('input chain too short');
end

% number of possibilities
nCk = nchoosek(n, S);

if nCk <= I
    seeds = mat2cell(nchoosek(1:n, S), ones(nCk, 1), S);
else
    k = min(nCk, I);
    N = randperm(nCk, k);
    seeds = mat2cell(unrank(N, 1:n, S)', ones(k, 1), S);
end

%% calculate model parameter

[models, seed_idx] = fitellipse_segs(seeds, segs);

M = size(models, 2);

valid_models = false(1, M);

for i = 1:M
    seed = seeds{seed_idx(i)};
    model = models(i);
    
    valid_models(i) = validate_model(model, segs(:, seed), direction, seed_max_err, seed_tau, seed_kappa);
end

models = models(valid_models);

if isempty(models)
    improved = [];
    return
end

M = size(models, 2);

%% determine consensus sets

consensus = cell(1, M);

for i = 1:M
    consensus{i} = find_consensus(models(i), segs, direction, cons_max_err, cons_tau, cons_kappa);
end

% don't accept consensus which doesn't produce ellipse

[~, idx] = fitellipse_segs(consensus, segs);

consensus = consensus(idx);

%% select best consensus

if isempty(consensus)
    improved = [];
else
    improved = select_consensus(consensus, segs, direction);
end
