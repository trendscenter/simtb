function filename = simtb_makefilename(sP, dtype, subIND)
%   simtb_makefilename()  - Makes filenames for various file types
%                   
%   Usage:
%    >> filename = simtb_makefilename(sP, dtype, subIND)
%    >> filename = simtb_makefilename(sP, dtype)
%
%   INPUTS:
%   sP                = parameter structure used in the simulations
%   dtype             = data type to be saved. Choices:
%                        {'PARAMS', 'SIM', 'DATA', 'MOT', 'MASK', 
%                        'model figure', 'parameter figure', 'output figure'}
%   subIND (OPTIONAL) = subject index (not needed for 'PARAMS', 
%                                     'model figure', or 'parameter figure')
%   
%   OUTPUTS:
%   filename          = filename 
%
%   see also: simtb_main()

if nargin < 3
    subIND = [];
end


switch dtype
    case {'params', 'PARAMS'}
        % parameter structure
        suffix = ['_PARAMS.mat'];
    case {'sim', 'SIM'}
        % simulated SMs and TCs
        suffix = ['_subject_' simtb_returnFileIndex(subIND) '_SIM.mat'];
    case {'data', 'DATA'}
        % simulated data set
        if sP.saveNII_FLAG
            suffix = ['_subject_' simtb_returnFileIndex(subIND) '_DATA.nii'];
        else
            suffix = ['_subject_' simtb_returnFileIndex(subIND) '_DATA.mat'];
        end
    case {'mot', 'MOT'}
        suffix = ['_subject_' simtb_returnFileIndex(subIND) '_MOT.txt'];
    case{'mask', 'MASK'}'
        suffix = ['_MASK.nii'];
    case {'model figure'}
        suffix = ['_model'];
    case {'parameter figure'}
        suffix = ['_params'];
    case {'output figure'}
        suffix = ['_subject_' simtb_returnFileIndex(subIND)];
    otherwise
        suffix = ['_' dtype];
end

filename = fullfile(sP.out_path, [sP.prefix suffix]);