function [errorflag, Message] = simtb_checkparams(sP, OPT)
%   simtb_checkparams()  - Checks for appropriate and consistent simulation parameters 
%
%   Usage:
%    >> [errorflag, Message] = simtb_checkparams(sP)
%    >> [errorflag, Message] = simtb_checkparams(sP, OPT)
%   INPUTS:
%   sP      = parameter strcutre
%   OPT     = string designating the parameters to check [OPTIONAL, default = 'all']
%             Possible values for OPT and their descriptions follow.
%             'all': checks all parameters.
%               '1': checks output parameters only.
%               '2': checks main parameters only.
%               '3': checks SM setting parameters only.
%               '4': checks TC_Block parameters only.
%               '5': checks TC_Event parameters only.
%               '6': checks Simulating noise parameters only.
%               '7': checks TC_Unique parameters only.
%               '8': checks TC source parameters only.
%   OUTPUTS:
%   errorflag   = indicator for error inout, 0 for no error
%   Message     = string with error information (if any)
%
%   see also: simtb_create_sP(), simtb_main()

if nargin < 2 || strcmpi(OPT, 'all')
    OPT = '';
end

% for convenience
M = sP.M;
nT = sP.nT;
nC = sP.nC;
nV = sP.nV;
TR = sP.TR;
out_path = sP.out_path;

errorflag = 0; %indicator for error inout, default 0, no error
Message = sprintf('');





%% path to save data
if strmatch(upper(OPT), '1')
    if ~exist(out_path,'dir')
        [SUCCESS,pMESSAGE,pMESSAGEID] = mkdir(out_path);
        if SUCCESS == 0
            errorflag = 1;
            Message = strvcat(Message,pMESSAGE);
        else
            newMessage = sprintf('Simulations will be saved in %s.\n', out_path);
            Message = strvcat(Message, newMessage);
        end
    else
        newMessage = sprintf('Simulations will be saved in %s.\n', out_path);
        Message = strvcat(Message, newMessage);
    end

    %% if saveasNII, spm must be on path
    if sP.saveNII_FLAG
        if ~exist('spm.m', 'file')
            errorflag = 1;
            newMessage = sprintf('ERROR: In order to save in nifti format, SPM must be on the search path.  Please add to path or update simulation parameters.\n');
            Message = strvcat(Message, newMessage);
        end
    end
end



if strmatch(upper(OPT), '2')
    %% memory constraints
    DataMat_bytes = nT*nV*nV*8;
    SMMat_bytes = nC*nV*nV*8;
    TCMat_bytes = nT*nC*8;
    Baseline_bytes = nV*nV*8;
    Rician_Noise_bytes = 2*8*nT*nV*nV;
    All_bytes  = DataMat_bytes + SMMat_bytes + TCMat_bytes + Baseline_bytes + Rician_Noise_bytes;

    try
        [uV, sV] = memory;
        maxMat = uV.MaxPossibleArrayBytes;
        maxPossible = uV.MemAvailableAllArrays;



        if All_bytes > maxPossible
            errorflag = 1;
            Message = sprintf('ERROR: Not enough RAM to generate data with these parameters, need %d MB, only have %d.\n Try reducing the number of time points or increasing virtual space.', round(All_bytes/1024/1024), round(maxPossible/1024/1024));
            return;
        end

        if DataMat_bytes > maxMat
            errorflag = 1;
            Message = sprintf('ERROR: Not enough free RAM to generate data, need %d MB of contiguous memory, only have %d.\n Try clearing or exiting Matlab', round(DataMat_bytes/1024/1024), round(maxMat/1024/1024));
            return;
        end
    catch
    end
    Message = sprintf('Simulations will use approximately %d MB of memory (per subject).\n', round(All_bytes/1024/1024));

    %% basic simulations parameters
    %% M must be > 0
    if M <= 0
        errorflag = 1;
        newMessage = sprintf('ERROR: Number of subjects (%d) must be greater than 0.\n', M);
        Message = strvcat(Message, newMessage);
    end

    %% nC must be > 0
    if nC <= 0
        errorflag = 1;
        newMessage = sprintf('ERROR: Number of components (%d) must be greater than 0.\n', nC);
        Message = strvcat(Message, newMessage);
    end

    %% nV must be > 0
    if nV <= 0
        errorflag = 1;
        newMessage = sprintf('ERROR: Number of voxels (%d) must be greater than 0.\n', nV);
        Message = strvcat(Message, newMessage);
    end

    %% nT must be > 0
    if nT <= 0
        errorflag = 1;
        newMessage = sprintf('ERROR: Number of time points (%d) must be greater than 0.\n', nT);
        Message = strvcat(Message, newMessage);
    end

    %% TR must be > 0
    if TR <= 0
        errorflag = 1;
        newMessage = sprintf('ERROR: Repetition time (%d) must be greater than 0.\n', TR);
        Message = strvcat(Message, newMessage);
    end

    %% nT must be > nC
    if nT < nC
        errorflag = 1;
        newMessage = sprintf('ERROR: Number of time points (%d) must be greater than number of components (%d).\n', nT, nC);
        Message = strvcat(Message, newMessage);
    end

    %% nC must be <= number of defined sources
    nSMdefined = simtb_countSM;
    if nC > nSMdefined
        errorflag = 1;
        newMessage = sprintf('ERROR: Number of components must be less than or equal to the number of defined sources (%d).\n\t Add definitions to simtb_SMsource()', nSMdefined);
        Message = strvcat(Message, newMessage);
    end
end

%%%% check parameters for generating SMs  %%%%
if strmatch(upper(OPT), '3')
    %% nC must be equal to the listed sources
    if length(sP.SM_source_ID) ~= nC
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Number of components must equal the length of source IDs.  Update ''nC'' or ''SM_source_ID''.');
    end

    %% Matrix for component presence must have size of [M x nC]
    if  any(size(sP.SM_present) ~= [M , nC])
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Component presence values must be size [M x nC]. Update ''SM_present''.');
    end

    %% Value for component presence must be either 0 or 1
    if any((sP.SM_present(:) ~= 0 ) & (sP.SM_present(:) ~= 1 ))
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Component presence values must be either 0 or 1. Update ''SM_present''.');
    end

    %% Matrix for offsets in x for the picked SM must have size of [M x nC]
    if any(size(sP.SM_translate_x) ~= [M, nC])
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Offsets in x must be size [M x nC]. Update ''SM_translate_x''.');
    end

    %% Matrix for offsets in y for the picked SM must have size of [M x nC]
    if any(size(sP.SM_translate_y) ~= [M, nC])
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Offsets in y must be size [M x nC]. Update ''SM_translate_y''.');
    end

    %% Matrix for the rotation angles for the picked SM  must have size of [M x nC]
    if any(size(sP.SM_theta) ~= [M, nC])
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Rotation angles must be size [M x nC]. Update ''SM_theta''.');
    end

    %% Matrix for spatial magnification factor for the picked SM  must have size of [M x nC]
    if any(size(sP.SM_spread) ~= [M, nC])
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Spatial magnification factors must be size [M x nC]. Update ''SM_spread''.');
    end

    %% Matrix for spatial magnification factor must be positive
    if any(sP.SM_spread(:) <= 0)
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Spatial magnification factors must be positive. Update ''SM_spread''.');
    end

    %% SM_source_ID must be between 1 and number of defined sources.
    nSMdefined = simtb_countSM;
    if any(sP.SM_source_ID(:) <1 | sP.SM_source_ID(:) > nSMdefined)
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: SM_source_ID must be between 1 and the number of defined sources. Update ''SM_source_ID''.');
    end
end

%% parameters for TCs in general
if strmatch(upper(OPT), '8')
    nmodels = simtb_countTCmodels;
    if any(sP.TC_source_type > nmodels)
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: TC_source_type is not defined. Update ''TC_source_type'' or add models to ''simtb_TCsource''.');
    end

    if any(size(sP.TC_source_params) ~= [M,nC])
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: TC_source_params must be a cell array size {M,nC}. Update ''TC_source_params''.');
    end
end

if strmatch(upper(OPT), '4')
    %%% check parameters for block design %%%
    %% TC_block_n must be >= 0
    if sP.TC_block_n < 0
        errorflag = 1;
        newMessage = sprintf('ERROR: Number of types of blocks (%d) must be non negative.\n', sP.TC_block_n);
        Message = strvcat(Message, newMessage);
    end

    if sP.TC_block_n
        %% TC_block_same_FLAG must be either 0 or 1.
        if (sP.TC_block_same_FLAG ~= 0 && sP.TC_block_same_FLAG~= 1 )
            errorflag = 1;
            Message = strvcat(Message, 'ERROR: FLAG value to set all subject to same block structure must be either 0 or 1. Update ''TC_block_same_FLAG''.');
        end
        %% TC_block_length must be >= 0
        if sP.TC_block_length <= 0
            errorflag = 1;
            newMessage = sprintf('ERROR: Length of each TC block (%d) must be greater than 0.\n', sP.TC_block_length);
            Message = strvcat(Message, newMessage);
        end

        %% TC_block_length must be < nT
        if sP.TC_block_length >= nT
            errorflag = 1;
            newMessage = sprintf('ERROR: Length of each TC block (%d) must be less than nT.\n', sP.TC_block_length);
            Message = strvcat(Message, newMessage);
        end

        %% TC_block_ISI must be >= 0
        if sP.TC_block_ISI <= 0
            errorflag = 1;
            newMessage = sprintf('ERROR: Length of  inter-stimulus-intervals (%d) must be greater than 0.\n', sP.TC_block_ISI);
            Message = strvcat(Message, newMessage);
        end

        %% TC_block_ISI must be < nT
        if sP.TC_block_ISI >= nT
            errorflag = 1;
            newMessage = sprintf('ERROR: Length of inter-stimulus-intervals (%d) must be less than nT.\n', sP.TC_block_ISI);
            Message = strvcat(Message, newMessage);
        end

        %% Matrix of task-modulation amplitudes relative to unique blocks must have size of [nC x TC_block_n]
        if any(size(sP.TC_block_amp) ~= [nC, sP.TC_block_n])
            errorflag = 1;
            Message = strvcat(Message, 'ERROR: Task-modulation amplitudes must be size [nC x TC_block_n]. Update ''TC_block_amp''.');
        end
    end
end

if strmatch(upper(OPT), '7')
    %%%% Check parameters for UNIQUE events  %%%
    %% TC_block_same_FLAG must be either 0 or 1.
    if (sP.TC_unique_FLAG ~= 0 && sP.TC_unique_FLAG~= 1)
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: FLAG value to include unique events must be either 0 or 1. Update ''TC_unique_FLAG''.');
    end

    if sP.TC_unique_FLAG
        %% TC_unique_prob must have size [1 x nC]
        if length(sP.TC_unique_prob) ~= nC
            errorflag = 1;
            Message = strvcat(Message, 'ERROR: Probability of unique event at each TR must be size [1 x nC]. Update ''TC_unique_prob''.');
        end
        %% element in TC_unique_prob must within (0,1)
        if any(sP.TC_unique_prob(:)<0  | sP.TC_unique_prob(:)>1)
            errorflag = 1;
            Message = strvcat(Message, 'ERROR: Probabilities that unique event occurs at each TR must within [0,1]. Update ''TC_unique_prob''.');
        end
        %% TC_unique_amp must have size [M x nC]
        if any(size(sP.TC_unique_amp) ~= [M, nC])
            errorflag = 1;
            Message = strvcat(Message, 'ERROR: Amplitudes of unique events must be size [M x nC]. Update ''TC_unique_amp''.');
        end
    end

end

if strmatch(upper(OPT), '5')
    if sP.TC_event_n < 0
        errorflag = 1;
        newMessage = sprintf('ERROR: Number of types of events (%d) must be non negative.\n', sP.TC_event_n);
        Message = strvcat(Message, newMessage);
    end
    %%% parameters for event-related design %%%
    if sP.TC_event_n
        %% Matrix of task-modulation amplitudes relative to unique events must have size of [nC x TC_block_n]
        if any(size(sP.TC_event_amp) ~= [nC, sP.TC_event_n])
            errorflag = 1;
            Message = strvcat(Message, 'ERROR: Task-modulation amplitudes must be size [nC x TC_event_n]. Update ''TC_event_amp''.');
        end

        %% Vector of probabilities that event occurs at each TR has size [1 x TC_event_n]
        if length(sP.TC_event_prob) ~= sP.TC_event_n
            errorflag = 1;
            Message = strvcat(Message, 'ERROR: Probability of event at each TR must be size [1 x TC_event_n]. Update ''TC_event_prob''.');
        end

        %% No probability can be less than 0 or greater than 1
        if any(sP.TC_event_prob > 1) || any(sP.TC_event_prob < 0)
            errorflag = 1;
            Message = strvcat(Message, 'ERROR: Probability of event occuring at each TR must within [0,1]. Update ''TC_event_prob''.');
        end

        %% Sum of vector of probabilities must not be greater that 1
        if sum(sP.TC_event_prob) > 1
            errorflag = 1;
            Message = strvcat(Message, 'ERROR: Probability of any event occuring (sum of ''TC_event_prob'') must be less than or equal to 1. Update ''TC_event_prob''.');
        end
    end
end

%%% Check parameters for simulating noise and adding realistic scale to the dataset %%%
if strmatch(upper(OPT), '6')
    %% D_baseline must have size [1 x M]
    if length(sP.D_baseline) ~= M
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Baseline signal intensities for each subject must be size [1 x M]. Update ''D_baseline''.');
    end

    %% D_baseline must be > 0
    if any(sP.D_baseline < 0)
        errorflag = 1;
        newMessage = sprintf('ERROR: Baseline signal intensity must be greater than 0. Update ''D_baseline''.');
        Message = strvcat(Message, newMessage);
    end

    %% D_tt_FLAG must be either 0 or 1.
    if (sP.D_TT_FLAG ~= 0 && sP.D_TT_FLAG~= 1)
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: FLAG value to include different tissue types (distinct baselines in the data)  must be either 0 or 1. Update ''D_tt_FLAG''.');
    end

    %% TTlevel must have size 1 by tissue type quantity
    nTTdefined = simtb_countTT;
    if length(sP.D_TT_level) ~= nTTdefined
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: D_TT_level must be the length of the number of tissue types. Update ''D_TTlevel''.');
    end

    %% Vector of percent signal changes for each subject/component must be [M x nC]
    if any(size(sP.D_pSC) ~= [M, nC])
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Percent signal changes for each subject/component must be size [M x nC]. Update ''D_pSC''.');
    end

    %% Percent signal changes for each subject/component must within (0,100)
    if any(sP.D_pSC(:)<0 | sP.D_pSC(:)>100)
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Percent signal changes for each subject/component must within (0,100). Update ''D_pSC''.');
    end

    %% D_noise_FLAG must be either 0 or 1.
    if (sP.D_noise_FLAG ~= 0 && sP.D_noise_FLAG~= 1 )
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: FLAG value to add rician noise to the data must be either 0 or 1. Update ''D_noise_FLAG''.');
    end

    %% D_CNR must be size [1 x M]
    if sP.D_noise_FLAG == 1
        if length(sP.D_CNR) ~= M
            errorflag = 1;
            Message = strvcat(Message, 'ERROR: Contrast-to-noise ratios for each subject must be size [1 x M]. Update ''D_CNR''.');
        end
    end

    %% D_CNR be greater than 0
    if any(sP.D_CNR(:) < 0)
        errorflag = 1;
        newMessage = sprintf('ERROR: Contrast-to-noise ratio for each subject must be greater than 0.\n');
        Message = strvcat(Message, newMessage);
    end
end

%%%% Motion
%% D_motion_FLAG must be either 0 or 1.
if (sP.D_motion_FLAG ~= 0 && sP.D_motion_FLAG~= 1 )
    errorflag = 1;
    Message = strvcat(Message, 'ERROR: FLAG value to add motion to the data must be either 0 or 1. Update ''D_motion_FLAG''.');
end

if sP.D_motion_FLAG
    %% D_motion_TRANSmax must be between 0 and 1.
    if sP.D_motion_TRANSmax < 0 || sP.D_motion_TRANSmax > 1
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Max translation must be a fraction of the image length ([0,1]). Update ''D_motion_TRANSmax''.');
    end

    %% D_motion_ROTmax must be positive.
    if sP.D_motion_ROTmax < 0
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Max rotation must be positive (in units of degrees). Update ''D_motion_ROTmax''.');
    end

    %% D_motion_deviates must be between 0 and 1.
    if any(sP.D_motion_deviates(:) < 0) || any(sP.D_motion_deviates(:) > 1)
        errorflag = 1;
        Message = strvcat(Message, 'ERROR: Motion deviates must be between 0 and 1, representing a fraction of max motion. Update ''D_motion_deviates''.');
    end
end

