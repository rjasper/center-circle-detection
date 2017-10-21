function chains = build_chains(p, s, n_p, n_s)
%BUILD_CHAINS   builds chains from a graph
% 
% arguments:
%   p:   (1xN cell of 1xp(i) vectors) list of predecessors
%   s:   (1xN cell of 1xs(i) vectors) list of successors
%   n_p: (1xN vector) number of predecessors
%   n_s: (1xN vector) number of successors
% returns:
%   chains: (1xn_c cell of 1xn_cc(i) vectors) contains segment indices

%% convenience variables
n = size(p, 2);

%% preparation

% find all inner chain nodes
chainnodes = find(n_p == 1 & n_s == 1);
% check if predecessors only have one successor and
% successors have only one predecessor
pred = cell2mat(p(chainnodes));
succ = cell2mat(s(chainnodes));

%% processing

chainnodes = chainnodes(n_s(pred) == 1 & n_p(succ) == 1);

used = false(1, n);
chains = {};

% find all chains (with inner nodes, i.e., at least 3 segments)
% for all inner chain nodes
for i = chainnodes
    c = length(chains) + 1;
    
    % don't reuse
    if used(i)
        continue
    end
    
    % first chain node
    chains{c} = i;
    used(i) = true;
    
    % collect successing nodes
    next = s{i};
    while true
        last = next;
        next = s{last};
        
        chains{c} = [chains{c} last]; % append waypoint
        used(last) = true;
        
        if n_s(last) ~= 1 || used(next) || n_p(next) > 1;
            break;
        end
    end
    
    % collect predecessing nodes
    next = p{i};
    while true
        first = next;
        next = p{first};
        
        chains{c} = [first chains{c}]; % append waypoint
        used(first) = true;
        
        if n_p(first) ~= 1 || used(next) || n_s(next) > 1;
            break;
        end
    end
end

n_c = size(chains, 2);

n_cc = nan(1, n_c);

for c = 1:n_c
    n_cc(c) = size(chains{c}, 2);
end

% sort by chain length
[~, cind] = sort(n_cc, 'descend');
chains = chains(cind);
