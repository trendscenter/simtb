function SIMULATION_PARAMETERS = simtb_create_sP(param_filename, M, nC)
%   simtb_create_sP()  - Initializes parameter structure
%
%   Usage:
%    >> sP = simtb_create_sP;  
%    >> sP = simtb_create_sP(param_filename);
%    >> sP = simtb_create_sP(param_filename, M, nC);
%    >> sP = simtb_create_sP([], M, nC);
%
%   INPUT: 
%   If no input       Builds parameter structure based on default values
%   param_filename  = parameter filname [OPTIONAL]. If provided, parameter values 
%                     will be revised by definitions in param_filename. 
%   M               = number of subjects [OPTIONAL, default is 10].
%   nC              = number of components [OPTIONAL, default is all sources]
%
%   OUTPUT:
%   sP              = parameter structure
%
%   see also: simtb_params(), simtb_checkparams()

%% parse inputs

if nargin && ~isempty(param_filename) && ischar(param_filename)
    have_paramfile = 1;
else 
    have_paramfile = 0;
end

if nargin < 3 || isempty(nC)
    nC = simtb_countSM;
end

if nargin < 2 || isempty(M)
    M = 10;
end

% M = 10;
% nC = simtb_countSM;

%% determine TT levels
[TTn, defaultTT] = simtb_countTT;

%% generate an empty structure & fill with defaults
SIMULATION_PARAMETERS = struct(...
... %%%
... %%% primary simulation parameters
'M',  M , ...   % number of subjects
'nC', nC, ...   % number of components
'nV', 100, ...  % number of voxels (1-D; image will be nV x nV)
'nT', 150, ...  % number of time points
'TR', 2, ...    % repetition time (sampling rate)
... %%%
... %%% primary parameters for the component SMs and TCs
'SM_source_ID', 1:nC, ...          % IDs of sources used to create the SM: see simtb_pickSM() and simtb_SMsource()
'TC_source_type', ones(1,nC), ...  % Type of model used to generate TCs for each component.  See simtb_TCsource.
'TC_source_params', {{}}, ...      % {M,nC} cell array of parameters for generating the TCs. See simtb_TCsource.
... %%% 
... %%% parameters for event-related design experiment 
'TC_event_n', 0, ...            % Number of types of events
'TC_event_same_FLAG', 0, ...    % FLAG to set all subject to same event structure (1) or different (0) 
'TC_event_amp', [], ...         % [nC x TC_n_block] matrix of task-modulation amplitudes relative to unique events 
'TC_event_prob', [], ...        % [1 x TC_event_n]  vector of probabilities that event occurs at each TR    
... %%%
... %%% parameters for a block-design experiment
'TC_block_n', 0, ...           % Number of types of blocks
'TC_block_same_FLAG', 0, ...   % FLAG to set all subject to same block structure (1) or different (0) 
'TC_block_length', 0, ...      % length of each block (in samples)
'TC_block_ISI', 0, ...         % length of inter-stimulus-intervals (in samples)
'TC_block_amp', [], ...        % [nC x TC_n_block] matrix of task-modulation amplitudes relative to unique events 
... %%%
... %%% parameters for time events unique to each component/subject
'TC_unique_FLAG', 1, ...                  %FLAG to include unique events
'TC_unique_prob', 0.5*ones(1,nC), ...     %[1 x nC] vector of probabilities that unique event occurs at each TR
'TC_unique_amp',  ones(M,nC), ...         %[M x nC] matrix of amplitudes of unique events
... %%%
... %%% parameters for generating SMs
'SM_present', ones(M, nC), ...          % [M x nC] matrix for component presence: 1 if component is included, 0 otherwise
'SM_translate_x', zeros(M,nC), ...      % [M x nC] matrix of translations in x for the picked SM
'SM_translate_y', zeros(M,nC), ...      % [M x nC] matrix of translations in y for the picked SM
'SM_theta', zeros(M,nC), ...            % [M x nC] matrix of rotation angles for the picked SM
'SM_spread', ones(M,nC), ...            % [M x nC] matrix of spatial magnification factor ( > 1 = larger, < 1 = smaller)
... %%%
... %%% parameters for simulating noise and adding realistic scale to the dataset
'D_baseline', 800*ones(1,M), ...         % [1 x M] vector of baseline signal intensity for each subject
'D_TT_FLAG', 0, ...                      % FLAG to include different tissue types (distinct baselines in the data)
'D_TT_level', defaultTT, ...             % [1 x TTn] matrix of TT(tissue type) fractional intensities 
'D_pSC', ones(M,nC), ...                 % [M x nC] vector of percent signal changes for each subject/component
'D_noise_FLAG', 1, ...                   % FLAG to add rician noise to the data
'D_CNR', 1*ones(1,M), ...                % [1 x M] vector of contrast-to-noise ratio for each subject
... %%% parameters for simulating motion
'D_motion_FLAG', 0, ...               % FLAG to include (1) or exclude (0) simulated motion of datasets
'D_motion_TRANSmax', 0, ...           % Maximum possible image translation, in percentage points of the image length 
'D_motion_ROTmax', 0, ...             % Maximum possible image rotation, in units of degrees (positive = clockwise rotation) 
'D_motion_deviates', zeros(M,3), ...  % [M x 3] matrix of motion deviates, in fractional units relative to the maximum motion.
... %%%
... %%% parameters for display/saving output
'verbose_display', 1, ...                                             % Option to display output throughout the simulations
'seed', round(sum(100*clock)), ...                                    % Seed for random number generator
'saveNII_FLAG', 0, ...                                                % Option to save data in .nii files as well as .mat
'out_path', fullfile(fileparts(which('simtb')), 'simulations'), ...   % full path to output directory
'prefix', 'sim');                                                     % Prefix for all output files

% add cell array here:
SIMULATION_PARAMETERS.TC_source_params = cell(M,nC);


%% Execute the paramfile and check to see if the newly defined variables match the fieldnames
if have_paramfile
    fprintf('Loading Parameters from ''%s''\n', param_filename)
    PNAMES = fieldnames(SIMULATION_PARAMETERS);
    try
        eval((param_filename));
    catch ME
        fprintf('Error: %s\n', ME.message)
        return
    end
    for ii = 1:length(PNAMES)
        if exist(PNAMES{ii}, 'var')
            eval(['SIMULATION_PARAMETERS.' PNAMES{ii} '=' PNAMES{ii} ';']);
        end
    end
    
    SIMULATION_PARAMETERS.pfile = which(param_filename);
else
    SIMULATION_PARAMETERS.pfile = '';
end

