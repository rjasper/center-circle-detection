function chains = detect_chains(segs, alpha_min, alpha_max)
%DETECT_CHAINS   detects chains of line segments
% 
% arguments:
%   alpha_min: (scalar)     minimum angle to be accepted
%   alpha_max: (scalar)     maximum angle to be accepted
% returns:
%   chains: (1xn_c cell of 1xn_cc(i) vectors) contains segment indices

import algorithm.*
import segment.*

%% processing

% lengths
l = line_lengths(segs);
% maximum neighbor distance
d_max = min(l); % so segs wouldn't consider themselves as neighbor
% segment distances
d = neighbor_dist(segs);
% segment angles
alpha = neighbor_angle(segs);

[p, s, n_p, n_s] = build_graph(d, d_max, alpha, alpha_min, alpha_max);
chains = build_chains(p, s, n_p, n_s);
