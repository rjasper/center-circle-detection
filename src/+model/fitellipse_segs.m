function [models, idx] = fitellipse_segs(chains, segs)
%FITELLIPSE_CHAINS   tries to fit ellipses to the given chains
% 
% uses bookstein and trace constraint and compares the results
%
% arguments:
%   chains: the line segment chains' indices
%   segs: the line segments
%   direction: the rotating direction of the ellipse (either 'positive',
%              'negative')
% returns:
%   models: valid ellipse models
%   idx: the indices of the chains which produced valid ellipses

import segment.*

%% constants

cfg = config;

b_min = cfg.FITELLIPSE_BMIN;

%% preparation

n_c = size(chains, 2);

zs   = cell(1, n_c);
as   = cell(1, n_c);
bs   = cell(1, n_c);
rhos = cell(1, n_c);

success = false(1, n_c);

%% processing

% for each chain
for c = 1:n_c
    chain = chains{c};
    pts = sample_points(segs(:, chain), 'fix');
    
%     model = fithelper(pts, 'bookstein', b_min);
    model = fithelper(pts, 'trace'    , b_min);
    
    if ~isempty(model)
        zs  {c} = model.z;
        as  {c} = model.a;
        bs  {c} = model.b;
        rhos{c} = model.rho;
        
        success(c) = true;
    end
end

models = struct(        ...
    'z'  , zs  (success), ...
    'a'  , as  (success), ...
    'b'  , bs  (success), ...
    'rho', rhos(success)  ...
);

% how to find success? :D
idx = find(success);


function model = fithelper(pts, constraint, b_min)

import model.*

try
    [z, a, b, rho] = fitellipse(pts, 'linear', 'constraint', constraint);

    % a should be the major axis
    if a < b
        tmp = a;
        
        a   = b;
        b   = tmp;
        rho = mod(rho + pi/2, 2*pi);
    end
    
    % |rho| should not be taller than pi/2
    if rho > pi/2
        rho = rho - pi;
    elseif rho < pi/2
        rho = rho + pi;
    end

    % b should not be smaller than b_min
    if b < b_min
        model = [];
    else
        model = struct('z', z, 'a', a, 'b', b, 'rho', rho);
    end
catch err
    model = [];
end
    
