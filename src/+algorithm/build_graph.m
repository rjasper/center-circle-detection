function [p, s, n_p, n_s] = build_graph(d, d_max, alpha, alpha_min, alpha_max)
%BUILD_GRAPH   builds a graph from line segments.
%
% arguments:
%   d:         (NxN matrix) distances to other lines
%   d_max:     (scalar)     maximum distance to be considered neighbor
%   alpha:     (NxN matrix) angle between two lines
%   alpha_min: (scalar)     minimum angle to be accepted
%   alpha_max: (scalar)     maximum angle to be accepted
% returns:
%   p:   (1xN cell of 1xp(i) matrices) list of predecessors
%   s:   (1xN cell of 1xs(i) matrices) list of successors
%   n_p: (1xN matrix) number of predecessors
%   n_s: (1xN matrix) number of successors

%% convenience variables

n = size(d, 2);

%% processing

% filter neighbors
ind_d = d < d_max;                               % filter by distance
ind_a = alpha >= alpha_min & alpha <= alpha_max; % filter by angle
[ind1, ind2] = find(ind_d & ind_a);

p = cell(1, n);
s = cell(1, n);

n_p = zeros(1, n);
n_s = zeros(1, n);

% find predecessors and successors
% for each segment
for i = 1:length(ind1)
    i1 = ind1(i);
    i2 = ind2(i);
    
    if i1 ~= i2
        p{i2} = [p{i2} i1]; % append i1
        s{i1} = [s{i1} i2]; % append i2
        
        n_p(i2) = n_p(i2) + 1;
        n_s(i1) = n_s(i1) + 1;
    end
end

