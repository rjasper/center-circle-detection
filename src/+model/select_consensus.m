function [best, idx] = select_consensus(consensus, segs, direction)
%SELECT_CONSENSUS   selects the best consensus
% 
% arguments:
%   consensus: sets of line segment indices
%   segs: the line segments
%   direction: the rotating direction of the ellipse (either 'positive',
%              'negative')
% returns:
%   best: the best consensus
%   idx: the index of the best consensus, so that best == consensus{idx}

import model.*
import utils.*

%% constants

cfg = config;

cons_margin = cfg.SELECT_CONSENSUS_MARGIN;

%% processing

% size of consensuses
cons_size = cellfun(@(c) length(c), consensus);

% select largest consensuses only
largest_cons = consensus(cons_size == max(cons_size));

% remove duplicate sub chains
[largest_cons, largest_idx] = unique_vectors(largest_cons);

% if there is only one largest consensus set return it
% otherwise select best set
if size(largest_cons, 2) == 1
    best = largest_cons{1};
    idx = largest_idx;
else % size > 1
    [ellipses, idxs] = fitellipse_segs(largest_cons, segs);
    
    % number of valid ellipses
    C = size(ellipses, 2);
    
    chain_err = NaN(1, C);
    
    % evaluate consensuses by chain_rating
    
    % for each model
    for i = 1:C
        cons = largest_cons{idxs(i)};
        
        [~, ~, nabs_err, ~] = chain_rating(segs(:, cons), ellipses(i), cons_margin);
        
        chain_err(i) = nabs_err;
    end
    
    % returns nothing if the largest sets happend to be not suited for
    % ellipse fitting
    
    % select best consensus with minimal focal point distance error
    
    [~, idx_min] = min(chain_err);
    best = largest_cons{idxs(idx_min)};
    idx = idxs(idx_min);
end
