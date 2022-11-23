%-------------------------------------------------------------------------------
% experiment_params_block.m 
% simtb_v18 03/28/11
% We define parameters to:
%       1. Change the output path and file prefix
%       2. Increase the number of time points from 150 (default) to 260
%       3. Implement a block design with 2 conditions
%       4. Increase the CNR for all subjects from 1 (default) to 2
% Parameters that are not defined here will take on their default values.
%
% To create the simulation parameter structure:
% >> sP = simtb_create_sP('experiment_params_block', M, nC);
%    Simulation can be executed with any number of subjects, M, or components, nC, 
%    though nC should be >= 4 given task modulation amplitudes (see Lines 46-49).
% To run the simulation:
% >> simtb_main(sP)
%-------------------------------------------------------------------------------

%% OUTPUT PARAMETERS
%-------------------------------------------------------------------------------
% Directory to save simulation parameters and output
out_path = 'X:\MyData\Simulations\';
prefix = 'block';  % Prefix for saving output
%-------------------------------------------------------------------------------

%% RANDOMIZATION
%-------------------------------------------------------------------------------
seed = round(sum(100*clock));   % randomizes parameter values
simtb_rand_seed(seed);          % set the seed 
%-------------------------------------------------------------------------------

%% SIMULATION DIMENSIONS
%-------------------------------------------------------------------------------
nT = 260; % Increase the length of the experiment           
%-------------------------------------------------------------------------------

%% EXPERIMENT DESIGN
%-------------------------------------------------------------------------------
% BLOCKS
TC_block_n = 2;          % Number of blocks [set = 0 for no block design]
TC_block_same_FLAG = 0;  % 1 = block structure same for all subjects
                         % 0 = block order will be randomized
TC_block_length = 20;    % length of each block (in samples)
TC_block_ISI    = 15;    % length of OFF inter-stimulus-intervals (in samples)
TC_block_amp    = zeros(nC, TC_block_n); % initialize [nC x TC_block_n] matrix
TC_block_amp(3,1) = 2;   % Comp 3 is strongly modulated by condition 1
TC_block_amp(3,2) = 0.5; % Comp 3 is weakly modulated by condition 2
TC_block_amp(4,1) = -1;  % Comp 4 is negatively modulated by condition 1
TC_block_amp(4,2) = 1.5; % Comp 4 is strongly modulated by condition 2
%-------------------------------------------------------------------------------

%% NOISE
%-------------------------------------------------------------------------------
D_CNR = 2*ones(1,M);   % Increase the CNR to be 2 for all subjects
%-------------------------------------------------------------------------------
% END of parameter definitions