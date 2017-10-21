function res = setismember(v, vs)
%SETISMEMBER   returns true if a given set v is member of a set of set vs
%
% arguments:
%   v:   the set
%   vs:  the set of sets (cell of vectors)
% returns:
%   res: true if the v is included in vs

if isempty(vs)
    res = false;
    return
end

%% preparation

% convert to row array if necessary
if size(vs, 1) > size(vs, 2)
    vs = vs';
end

%% processing

% lengths of the vectors in the set
len = cellfun(@(v) length(v), vs);

% consider only vectors of the same length as v
vs = vs(len == size(v, 2))';

if isempty(vs)
    res = false;
    return
end

vs = cell2mat(vs);
% normalize sets by sorting
vs = sort(vs, 2);
v = sort(v);

res = ismember(v, vs, 'rows');
