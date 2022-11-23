%-------------------------------------------------------------------------------
% experiment_params_aod.m 
% simtb_v18 03/28/11
% Example script for setting/modifying simtb simulation parameters, from
%   "SimTB, a simulation toolbox for fMRI data
%     under a model of spatiotemporal separability"
%   E.B. Erhardt, E.A. Allen, Y. Wei, T. Eichele, V.D. Calhoun
%
% To create the simulation parameter structure:
% >> sP = simtb_create_sP('experiment_params_aod');
% 
% To run the simulation:
% >> simtb_main(sP)
%
% Futher information on any parameter can be found by typing:
% >> simtb_params(param_name)
%-------------------------------------------------------------------------------

%% OUTPUT PARAMETERS
%-------------------------------------------------------------------------------
% Directory to save simulation parameters and output
out_path = 'X:\MyData\Simulations\';
% Prefix for saving output
prefix = 'aod';
% FLAG to write data in NIFTI format rather than matlab
saveNII_FLAG = 0;
% Option to display output and create figures throughout the simulations
verbose_display = 1;
%-------------------------------------------------------------------------------

%% RANDOMIZATION
%-------------------------------------------------------------------------------
%seed = round(sum(100*clock));  % randomizes parameter values
seed = 3571;                    % choose seed for repeatable simulation
simtb_rand_seed(seed);          % set the seed 
%-------------------------------------------------------------------------------

%% SIMULATION DIMENSIONS
%-------------------------------------------------------------------------------
M  = 5;   % number of subjects    
% nC is the number of components defined below, nC = length(SM_source_ID);
nV = 148; % number of voxels; dataset will have [nV x nV] voxels.           
nT = 150; % number of time points           
TR = 2;   % repetition time 
%-------------------------------------------------------------------------------

%% SPATIAL SOURCES
%-------------------------------------------------------------------------------
% Choose the sources. To launch a stand-alone GUI:
% >> simtb_pickSM 
SM_source_ID = [    2  3  4  5  6  7  8  9     ...
                11 12    14 15 16 17 18 19 20  ...
                21 22 23 24 25 26 27 28 29 30]; % all but (1, 10, 13)

nC = length(SM_source_ID);  % number of components            

% LABEL COMPONENTS
% Here, we label components or component groups that may be used later
% Auditory: strong positive activation for all task events
comp_AUD1  = find(SM_source_ID == 27);
comp_AUD2  = find(SM_source_ID == 28);
% DMN: negative activation to task events
comp_DMN   = find(SM_source_ID ==  8);
% Bilateral frontal: positive activation to for targets and novels
comp_BF    = find(SM_source_ID == 24);
% Frontal: 1 second temporal delay from bilateral frontal
comp_F1    = find(SM_source_ID ==  4);
comp_F2    = find(SM_source_ID ==  5);
% Precuneus: activation only to targets
comp_P     = find(SM_source_ID ==  7);
% Dorsal Attention Network: activation to novels more than targets
comp_DAN   = find(SM_source_ID == 18);
% Hippocampus: activation only to novels
comp_H1    = find(SM_source_ID == 29);
comp_H2    = find(SM_source_ID == 30);
% (Sensori)Motor: activation to targets and novels (weakly)
comp_M1    = find(SM_source_ID == 22);
comp_M2    = find(SM_source_ID == 23);
% CSF and white matter: unaffected by task, but has signal amplitude differences
comp_CSF1  = find(SM_source_ID == 14);
comp_CSF2  = find(SM_source_ID == 15);
comp_WM1   = find(SM_source_ID == 16);
comp_WM2   = find(SM_source_ID == 17);
% Medial Frontal: has lower baseline intensity (signal dropout)
comp_MF    = find(SM_source_ID ==  6);

% compile list of all defined components of interest
complist = [comp_AUD1 comp_AUD2 comp_DMN comp_BF  comp_F1 comp_F2 ...
            comp_P    comp_DAN  comp_H1  comp_H2  comp_M1 comp_M2 ...
            comp_CSF1 comp_CSF2 comp_WM1 comp_WM2 comp_MF];
%-------------------------------------------------------------------------------

%% COMPONENT PRESENCE
%-------------------------------------------------------------------------------
% [M x nC] matrix for component presence: 1 if included, 0 otherwise
% For components not of interest there is a 90% chance of component inclusion.
SM_present = (rand(M,nC) < 0.9);
% Components of interest (complist) are included for all subjects.
SM_present(:,complist) = ones(M,length(complist));
%-------------------------------------------------------------------------------

%% SPATIAL VARIABILITY
%-------------------------------------------------------------------------------           
% Variability related to differences in spatial location and shape.
SM_translate_x = 0.1*randn(M,nC);  % Translation in x, mean 0, SD 0.1 voxels.
SM_translate_y = 0.1*randn(M,nC);  % Translation in y, mean 0, SD 0.1 voxels.
SM_theta       = 1.0*randn(M,nC);  % Rotation, mean 0, SD 1 degree.
%                Note that each 'activation blob' is rotated independently.
SM_spread = 1+0.03*randn(M,nC); % Spread < 1 is contraction, spread > 1 is expansion.
%-------------------------------------------------------------------------------

%% TC GENERATION
%-------------------------------------------------------------------------------
% Choose the model for TC generation.  To see defined models:
% >> simtb_countTCmodels

TC_source_type = ones(1,nC);    % convolution with HRF for most components
% to make statistical moments of data look more like real data
TC_source_type([comp_CSF1 comp_CSF2]) = 3; % spike model for CSF

TC_source_params = cell(M,nC);  % initialize the cell structure
% Use the same HRF for all subjects and relevant components
P(1) = 6;    % delay of response (relative to onset)
P(2) = 16;   % delay of undershoot (relative to onset)
P(3) = 1;    % dispersion of response
P(4) = 1;    % dispersion of undershoot
P(5) = 6;    % ratio of response to undershoot
P(6) = 0;    % onset (seconds)
P(7) = 32;   % length of kernel (seconds)
[TC_source_params{:}] = deal(P);

% Implement 1 second onset delay for components comp_F1 and comp_F2
P(6) = P(6) + 1;  % delay by 1s
[TC_source_params{:,[comp_F1 comp_F2]}] = deal(P);

sourceType = 3; % CSF components use spike model
% Generate a random set of parameters for TC model 3
[tc_dummy, MDESC, P3, PDESC] = simtb_TCsource(1, 1, sourceType);
% Assign identical parameters for model 3 to all subjects
[TC_source_params{:,[comp_CSF1 comp_CSF2]}] = deal(P3);
%-------------------------------------------------------------------------------

%% EXPERIMENT DESIGN
%-------------------------------------------------------------------------------
% BLOCKS
% No blocks for this experiment
TC_block_n = 0;          % Number of blocks [set = 0 for no block design]
% Note that if TC_block_n = 0 the rest of these parameters are irrelevant
TC_block_same_FLAG = 0;  % 1 = block structure same for all subjects
                         % 0 = otherwise order will be randomized
TC_block_length = 10;    % length of each block (in samples)
TC_block_ISI    = 10;    % length of OFF inter-stimulus-intervals (in samples)
TC_block_amp    = [];    % [nC x TC_block_n] matrix of task-modulation amplitudes

% EVENTS
TC_event_n = 4;          % Number of event types (0 for no event-related design)
                         % 1: standard tone
                         % 2: target tone
                         % 3: novel tone
                         % 4: 'spike' events in CSF (not related to task)
TC_event_same_FLAG = 0;  % 1=event timing will be the same for all subjects

% event probabilities (0.6 standards, 0.075 targets and novels, 0.05 CSF spikes)
TC_event_prob = [0.6, 0.075, 0.075, 0.05];  % an 8:1:1 ratio 

% initialize [nC x TC_event_n] matrix of task-modulation amplitudes
TC_event_amp = zeros(nC,TC_event_n); 
% event type 1: standard tone
TC_event_amp([comp_AUD1 comp_AUD2],              1) = 1.0; % moderate task-modulation
TC_event_amp([comp_BF comp_F1 comp_F2 comp_DAN], 1) = 0.7; % mild 
TC_event_amp([comp_DMN],                         1) =-0.3; % negative weak
% event type 2: target tone
TC_event_amp([comp_AUD1 comp_AUD2],              2) = 1.2; % strong
TC_event_amp([comp_BF comp_F1 comp_F2],          2) = 1.0; % moderate
TC_event_amp([comp_DAN],                         2) = 0.8; % mild
TC_event_amp([comp_P],                           2) = 0.5; % weak
TC_event_amp([comp_M1 comp_M2],                  2) = 1.0; % moderate
TC_event_amp([comp_DMN],                         2) =-0.3; % negative weak
% event type 3: novel tone
TC_event_amp([comp_AUD1 comp_AUD2],              3) = 1.5; % very strong
TC_event_amp([comp_BF comp_F1 comp_F2],          3) = 1.0; % moderate
TC_event_amp([comp_DAN],                         3) = 1.2; % strong
TC_event_amp([comp_H1 comp_H2],                  3) = 0.8; % mild
TC_event_amp([comp_M1 comp_M2],                  3) = 0.5; % weak
TC_event_amp([comp_DMN],                         3) =-0.3; % negative weak
% event type 4: 'spikes' in CSF (not related to task)
TC_event_amp([comp_CSF1 comp_CSF2],              4) = 1.0; % moderate
%-------------------------------------------------------------------------------

%% UNIQUE EVENTS
%-------------------------------------------------------------------------------
TC_unique_FLAG = 1; % 1 = include unique events
TC_unique_prob = 0.2*ones(1,nC); % [1 x nC] prob of unique event at each TR

TC_unique_amp  = ones(M,nC);     % [M x nC] matrix of amplitude of unique events
% smaller unique activations for task-modulated and CSF components
TC_unique_amp(:,[comp_AUD1 comp_AUD2])              = 0.2;
TC_unique_amp(:,[comp_BF comp_F1 comp_F2])          = 0.3;
TC_unique_amp(:,[comp_DAN])                         = 0.5;
TC_unique_amp(:,[comp_P])                           = 0.5;
TC_unique_amp(:,[comp_M1 comp_M2])                  = 0.2;
TC_unique_amp(:,[comp_H1 comp_H2])                  = 0.4;
TC_unique_amp(:,[comp_DMN])                         = 0.3; 
TC_unique_amp(:,[comp_CSF1 comp_CSF2])              = 0.05; %very small
%-------------------------------------------------------------------------------

%% DATASET BASELINE                                 
%-------------------------------------------------------------------------------
% [1 x M] vector of baseline signal intensity for each subject
D_baseline = 800*ones(1,M); % [1 x M] vector of baseline signal intensity
%-------------------------------------------------------------------------------

%% TISSUE TYPES
%-------------------------------------------------------------------------------
% FLAG to include different tissue types (distinct baselines in the data)
D_TT_FLAG = 1;                    % if 0, baseline intensity is constant 
D_TT_level = [1.15, 0.8, 1, 1.2]; % TT fractional intensities
% To see/modify definitions for tissue profiles:
% >> edit simtb_SMsource.m
%-------------------------------------------------------------------------------

%% PEAK-TO-PEAK PERCENT SIGNAL CHANGE 
%-------------------------------------------------------------------------------
D_pSC = 3 + 0.25*randn(M,nC);   % [M x nC] matrix of percent signal changes 

% To make statistical moments of data look more like real data
D_pSC(:,comp_CSF1) = 1.2*D_pSC(:,comp_CSF1);
D_pSC(:,comp_CSF2) = 1.2*D_pSC(:,comp_CSF2);
D_pSC(:,comp_WM1)  = 0.5*D_pSC(:,comp_WM1);
D_pSC(:,comp_WM2)  = 0.5*D_pSC(:,comp_WM2);
%-------------------------------------------------------------------------------

%% NOISE
%-------------------------------------------------------------------------------
D_noise_FLAG = 1;               % FLAG to add rician noise to the data
% [1 x M] vector of contrast-to-noise ratio for each subject
% CNR is distributed as uniform between 0.65 and 2.0 across subjects.  
minCNR = 0.65;  maxCNR = 2;
D_CNR = rand(1,M)*(maxCNR-minCNR) + minCNR; 
%-------------------------------------------------------------------------------

%% MOTION 
%-------------------------------------------------------------------------------
D_motion_FLAG = 1;              % 1=motion, 0=no motion
D_motion_TRANSmax = 0.02;       % max translation, proportion of entire image
D_motion_ROTmax = 5;            % max rotation, in degrees
D_motion_deviates = ones(M,3);  % proportion of max each subject moves
D_motion_deviates(1,:) = 0.5;   % Subject 1 moves half as much
%-------------------------------------------------------------------------------
% END of parameter definitions