function [extended, considered] = extend_chains(chains, segs, outsiders, direction, considered)
%ENRICH_CHAINS   enriches chains with outsiders that support a common model
% 
% arguments:
%   chains: the chain indices to be extended
%   segs: the line segments
%   outsiders: indices of line segments not yet part of a chain
%   direction: the rotating direction of the ellipse (either 'positive',
%              'negative')
%   considered: sets of outsiders already considered (not obligatory)
% returns:
%   extended: extended chains' indices
%   considered: sets of outsiders already considered

import algorithm.*
import model.*
import utils.*

%% constants

cfg = config;

cand_tau     = cfg.FIND_CANDIDATES_TAU;
cand_kappa   = cfg.FIND_CANDIDATES_KAPPA;
val_max_err  = cfg.FIND_CONSENSUS_MAX_ERR;
val_tau      = cfg.FIND_CONSENSUS_TAU;
val_kappa    = cfg.FIND_CONSENSUS_KAPPA;
cons_max_err = cfg.FIND_CONSENSUS_MAX_ERR;
cons_tau     = cfg.FIND_CONSENSUS_TAU;
cons_kappa   = cfg.FIND_CONSENSUS_KAPPA;

%% convenience variables

n = size(chains, 2);

%% preparation

if ~exist('considered', 'var')
    considered = cell(1, 0);
end

%% processing

extended = cell(1, n);

% for each chain
for i = 1:n
    chain = chains{i};
    
    model = fitellipse_segs({chain}, segs);
    
    % disregard chain if it doesn't produce an ellipse
    if isempty(model)
        continue;
    end
    
    % find candidates to be checked for model support
    candidates = find_candidates(model, segs, chain, outsiders, direction, cand_tau, cand_kappa);
    
    if isempty(candidates)
        extended{i} = chain;
    else
        C = size(candidates, 2);

        consensus = cell(1, C);
        
        % for each candidate
        for c = 1:C
            cand = candidates(c);
            chain_ = [chain cand];
            
            model_ = fitellipse_segs({chain_}, segs);
            
            % if new chain produces valid model
            if ~isempty(model_) && validate_model(model_, segs(:, chain_), direction, val_max_err, val_tau, val_kappa)
                outsiders_ = outsiders(outsiders ~= cand);
                % find consensus of new model
                consensus_ = outsiders_( find_consensus(model_, segs(:, outsiders_), direction, cons_max_err, cons_tau, cons_kappa) );

                chain__ = [chain_ consensus_];
                
                % don't go into recursion if the chain was already
                % considered
                if setismember(chain__, considered)
                    continue;
                else
                    considered = [considered {chain__}];
                end
                
                outsiders__ = setdiff(outsiders_, consensus_);
                
                % try to expand the consensus using recursion
                [consensus__, considered] = extend_chains({chain__}, segs, outsiders__, direction, considered);
                
                % if chain__ couldn't produce an ellipse
                if isempty(consensus__)
                    consensus{c} = chain_;
                else
                    consensus{c} = consensus__{1};
                end
            else
                consensus{c} = chain;
            end
        end
        
        % select best consensus found
        extended{i} = select_consensus(consensus, segs, direction);
    end
end

% remove empty chains
notempty = cellfun(@(e) ~isempty(e), extended);
extended = extended(notempty);
