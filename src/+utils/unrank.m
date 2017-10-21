function C = unrank(N, s, k)
%%UNRANK   computes the k-combination which corresponds to a specified rank
%
% The rank of the k-combinations is defined by the increasing order of all
% possible unique k-combinations. The uniqueness is enforced by the
% constraint that any k-combination sequence is represented by
% (c_k, ..., c_1) which fulfills the condition c_k > ... > c_1.
%
% arguments:
%   N: the ranks of the k-combinations to be calculated
%   s: the symbols which the k-combination consists of
%   k: the size of the k-combination
%
% returns:
%   C: the k-combinations of the given ranks

%% convenience variables

% number of ranks
N_size = size(N, 2);
% number of symbols
n = size(s, 2);
% number of possibilities per 'digit' (element) of the combination sequence
m = n-k+1;

%% allocation

% the matrix holding needed n-Choose-k values for computation
nCk = zeros(k, m);
% the combinations to be computed from N
C = NaN(k, N_size);

%% preparation

% initialize nCk
for i = 2:m
    v = cumsum([1; nCk(:, i-1)]);
    nCk(:, i) = v(2:end);
end

% using MATLAB indexing starting with 1 instead of 0.
N = N - 1;

%% processing

% for each 'digit' (element) in the combination sequence from k to 1
for i = k:-1:1
    % prepare for comparation
    nCk_rep = repmat([nCk(i, :) inf]', 1, N_size);
    N_rep = repmat(N, m, 1);
    
    % find suitable nCk value
    [idx, ~] = find(nCk_rep(1:end-1, :) <= N_rep & N_rep < nCk_rep(2:end, :));
    
    N = N - nCk(i, idx);
    C(i, :) = idx' + i - 2;
end

%% post-processing

% convert to symbols
C = s(C+1);

if N_size == 1
    C = C';
end
