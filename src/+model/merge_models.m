function merged = merge_models(models1, models2)
%MERGE_MODELS   merges two given lists of ellipse models
% 
% This can be used to create a ellipse between an outer and an inner ellipse.
%
% arguments:
%   models1: a 1xN struct array containing ellipse parameters
%   models2: a 1xN struct array containing ellipse parameters
% returns:
%   models: merged models based of the parameters of models1 and
%      models2.

%% convenience variables

n = size(models1, 2);

%% processing

zs   = cell(1, n);
as   = cell(1, n);
bs   = cell(1, n);
rhos = cell(1, n);

for i = 1:n
    % unpacking
    
    m1 = models1(i);
    m2 = models2(i);

    v1 = [m1.z' m1.a m1.b m1.rho];
    v2 = [m2.z' m2.a m2.b m2.rho];

    % actual merge
    v = (v1 + v2) / 2;

    % storing
    zs{i}   = v(1:2)';
    as{i}   = v(3);
    bs{i}   = v(4);
    rhos{i} = v(5);
end

merged = struct( ...
    'z'  , zs  , ...
    'a'  , as  , ...
    'b'  , bs  , ...
    'rho', rhos  ...
);
