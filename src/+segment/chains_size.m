function [n_c, n_cc] = chains_size(chains)
%CHAINS_SIZE   determines the sizes of the given chains
% 
% arguments:
%   chains: the chains
% returns:
%   n_c: the amount of chains
%   n_cc: the size of each chain

n_c = size(chains, 2);
n_cc = cellfun(@(c) size(c, 2), chains);
