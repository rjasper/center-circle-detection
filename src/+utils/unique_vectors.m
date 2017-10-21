function [us, idx] = unique_vectors(vs)
%UNIQUE_VECTORS   removes duplicate vectors from a cell array
% 
% arguments:
%   vs: a 1xN or Nx1 cell array containing row vectors
% returns
%   us: a cell array containing unique row vectors
%   idx: a array of indices of vectors which were not removed. vs(idx) will
%      result in us

%% processing

% allocate space for unique vectors
us = cell(size(vs));

% transpose if vs is vertical aligned
if size(vs, 1) > size(vs, 2)
    vs = vs';
end

% determine vector sizes
lengths = cellfun(@(v) length(v), vs);
% calculate size classes
size_classes = unique(lengths);

% unique vectors so far
n = 0;

% for each size class
for size_class = size_classes
    % consider every vector of this size class
    idxc = find(lengths == size_class);
    vc = vs(idxc)';
    
    if size_class == 0
        % case if there are empty vectors
        nc = 1;
        uc_mat = NaN(1, 0);
        idxuc = 1;
    else
        % extract unique vectors of this size class
        [uc_mat, idxuc, ~] = unique(cell2mat(vc), 'rows', 'first');
        % number of unique vectors
        nc = size(uc_mat, 1);
    end
    
    % convert to cells
    uc = mat2cell(uc_mat, ones(1, nc))';
    % add to result vector
    us ((n+1):(n+nc)) = uc;
    idx((n+1):(n+nc)) = idxc(idxuc);
    
    % increase unique vector counter
    n = n + nc;
end

% cut off unused space
us = us(1:n);
idx = idx(1:n);
