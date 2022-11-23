function MASK = simtb_createmask(sP, saveMASKasNIFTI)
% simtb_createmask()  - Creates data mask with ones inside the head and zeros outside.
%                Note that this utility should NOT be used to determine
%                a mask if motion is simulated since the head boundaries will move.
%
% Usage:
%  >> MASK = simtb_createmask(sP, saveMASKasNIFTI);
%
% INPUTS:
% sP               = simulation parameter structure
% saveMASKasNIFTI  = FLAG to save MASK as a NIFTI file
% 
% OUTPUTS:
% MASK             = MASK of ones where data are defined and zero elsewhere

if nargin < 2
    saveMASKasNIFTI = 0;
end

nV = sP.nV;
arg1 = linspace(-1,1,nV);
[x,y] = meshgrid(arg1,arg1);
r = sqrt(x.^2 + y.^2);

MASK = ones(nV,nV);
MASK(r>1) = 0;

if saveMASKasNIFTI
    if exist('spm.m', 'file') 
        % reshape the data
        MASK = reshape(MASK, nV,nV,1,1);
        mfilename = simtb_makefilename(sP, 'MASK');
        if sP.D_motion_FLAG && (any(sP.D_motion_deviates(:)>0))
            % motion has been implemented for at least one subject
            warning('Mask is not appropriate if motion has been implemented')
        end
        fprintf('Writing MASK to %s\n', mfilename);
        simtb_saveasnii(MASK, mfilename);
    else
        fprintf('In order to save in nifti format, SPM must be on the search path.\n');
    end
end
