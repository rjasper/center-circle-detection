function pts = sample_ellipse(model, mode, value)
%SAMPLE_ELLIPSE   samples points from the given ellipse
% 
% arguments:
%   model: the ellipse model to be sampled
%   mode: either 'fix' for a fix number of sample points or
%         'interval' for a constant interval distance between the points
%   value: the value of either the number of sample points or the interval
% returns:
%   pts: the sampled points

import model.*
import segment.*

%% constants

cfg = config;

phi_interval = cfg.SAMPLE_ELLIPSE_PHI_INTERVAL;

%% convenience variables

[z, a, b, rho] = unpack_ellipse(model);

%% preparation

% rotation matrix
Q = [cos(rho), -sin(rho); sin(rho) cos(rho)];

% number of line segments which approximate the ellipse
n_segs = ceil(2*pi / phi_interval);

%% processing

% approximate ellipse by polygonal chain

t = linspace(0, 2*pi, n_segs+1);

% polygonal chain
polychain = Q * [a * cos(t); b * sin(t)] + repmat(z, 1, n_segs+1);

% sample polychain
pts = sample_polyline(polychain, mode, value);
