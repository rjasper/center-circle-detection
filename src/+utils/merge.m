function union = merge(sets)
%MERGE   concatenates a set of matrices to a single matrix
% 
% arguments:
%   sets: a cell array containing matrices of the same height
% returns:
%   union: the concatenated matrix

union = cell2mat(horzcat(sets));
