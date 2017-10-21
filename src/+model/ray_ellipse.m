function [S1, S2, t1, t2] = ray_ellipse(P, alpha, model)

import model.*

%% preparation

Q = [cos(alpha); sin(alpha)];

%% processing

[S1, S2, t1, t2] = segPQ_ellipse(P, Q, model);
