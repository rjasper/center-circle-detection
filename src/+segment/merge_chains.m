function merged = merge_chains(chains, segs, direction)
%MERGE_CHAINS   merges chains which produce valid ellipses
%
% arguments:
%   chains:    the chain indices
%   segs:      the line segments
%   direction: the rotating direction of the ellipse (either 'positive',
%              'negative')
% returns:
%   merged: the merged chains' indices

import algorithm.*
import segment.*

%% constants

cfg = config;

% min_partial_set = cfg.MERGE_MIN_PARTIAL_SET;
min_set = .5;

% cons_max_err = cfg.MERGE_FIND_CONSENSUS_MAX_ERR;
% cons_tau     = cfg.MERGE_FIND_CONSENSUS_TAU;
% cons_kappa   = cfg.MERGE_FIND_CONSENSUS_KAPPA;
% 
% val_max_err  = cfg.MERGE_VALIDATION_MAX_ERR;
% val_tau      = cfg.MERGE_VALIDATION_TAU;
% val_kappa    = cfg.MERGE_VALIDATION_KAPPA;

%% processing

n = size(chains, 2);

merged = cell(1, n);
used = false(1, n);

% for each unused chain
for i = 1:n
    % don't reuse chains
    if used(i)
        continue
    end
    
    chain = chains{i};
    
    used(i) = true;
    
    was_merged = false;
    
    % try to connect with other unused chains
    for j = find(~used)
        other = chains{j};
        union = [chain other];
        
        improved = improve_chains({union}, segs, direction);
        
        % ransac didn't yield a subchain which is able to produce an
        % ellipse
        if isempty(improved)
            continue
        end
        
        partial_c = sum( ismember(chain, improved{1}) );
        partial_o = sum( ismember(other, improved{1}) );
        
        % the yielded subchain did not contain elements of both chains
        if partial_c < min_set * length(chain) || partial_o < min_set * length(other)
            continue
        end
        
%         % the yielded subchain did not contain elements of both chains
%         if ~any(ismember(chain, improved{1})) || ~any(ismember(other, improved{1}))
%             continue
%         end
        
        % continue if there are less supporter than each chain has for itself
        if size(improved{1}, 2) <= max(size(chain, 2), size(other, 2))
            continue
        end
        
        was_merged = true;
        used(j) = true;
        chain = improved{1};
        
%         % try to fit a model for the union
%         model = fitellipse_segs(improved, segs);
%         
%         % find supporter of both chains
%         consensus = union( find_consensus(model, segs(:, union), direction, cons_max_err, cons_tau, cons_kappa) );
% 
%         % continue if there are less supporter than each chain has for itself
%         if size(consensus, 2) <= max(size(chain, 2), size(other, 2))
%             continue
%         end
% 
%         % try to fit a model for the consensus
%         model_ = fitellipse_segs({consensus}, segs);
% 
%         % accept if model is valid
%         if ~isempty(model_) && validate_model(model_, segs(:, consensus), direction, val_max_err, val_tau, val_kappa)
%             was_merged = true;
%             used(j) = true;
%             chain = consensus;
%         end
    end
    
    if was_merged
        merged{i} = chain;
    else
        improved = improve_chains({chain}, segs, direction);
        
        if ~isempty(improved)
            merged(i) = improved;
        end
    end
end

% remove empty fields
[~, n_cc] = chains_size(merged);
merged = merged(n_cc > 0);
