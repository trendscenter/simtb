function newseed = simtb_rand_seed(newseed, verbose_FLAG)
% simtb_rand_seed()  -  Set random number generator (RNG) seeds
%
% Usage:
%  >> simtb_rand_seed;
%  >> simtb_rand_seed([], 1);
%  >> simtb_rand_seed(newseed);
%  >> simtb_rand_seed(newseed, 1);
%
% INPUTS:
% newseed           = seed to initalize RNG states
%                     (OPTIONAL: leave empty to randomly initalize to sum(100*clock))
% verbose_FLAG      = 0|1 to display seed to screen when initialized
%                     (OPTIONAL: default is 0, no output)
% OUTPUTS:
% newseed           = seed used to initialize RNG states

if nargin < 1 || isempty(newseed)
    newseed = round(sum(100*clock));
end

if nargin < 2
    verbose_FLAG = 0;
end


% Set each random generator
%
%--------------------------------------------------------------------------

% rand (also used for randperm)
try
    rand('twister', newseed);
catch % backwards compatability
    rand('seed', newseed);
end

% randn
try
    randn('state', newseed);
catch % backwards compatability
    randn('seed', seed);
end
%--------------------------------------------------------------------------

if verbose_FLAG
    fprintf('RNG states initialized to %d\n', newseed);
end
