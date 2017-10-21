function [S1, S2, t1, t2] = seg_ellipse(segs, model)

import model.*

%% preparation

% support vectors
P = segs(1:2, :);
% directiono vectors
Q = segs(3:4, :) - segs(1:2, :);

%% processing

[S1, S2, t1, t2] = segPQ_ellipse(P, Q, model);
