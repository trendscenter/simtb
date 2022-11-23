function [SMall, filenames] = simtb_group_getSM(sP, subIND)
%   simtb_group_getSM()  - Loads saved subject SMs (spatial maps)
%
%   Usage:
%    >> SMall = simtb_group_getSM(sP);
%    >> SMall = simtb_group_getSM(sP, [1 8]);
%   INPUTS:
%   sP            = parameter structure used in the simulations
%   subIND        = indices of subject(s) to load [OPTIONAL, default = all subjects]
%
%   OUTPUTS:
%   SMall         = SMs from all subjects: [subjects x nC components x (nV*nV) voxels]
%   filenames     = filenames of simulated data in the order they were loaded.
%
%   see also: simtb_main()


if nargin < 2 || isempty(subIND)
    subIND = 1:sP.M;
end

nsub = length(subIND);
SMall = zeros(nsub, sP.nC, sP.nV*sP.nV);

fprintf('Loading simulated subject SMs: ')
for sub = 1:nsub
    
    if sub == 1
        fprintf('1')
    elseif sub == nsub
        fprintf('%d', nsub)
    else
        fprintf('.')
    end
    
    
    tfile = simtb_makefilename(sP, 'SIM', subIND(sub));

    %load in each subject's SM
    tempSM = load(tfile, 'SM');
    SMall(sub,:,:) = tempSM.SM;

    % keep track of the filenames
    filenames{sub} = tfile;
end
fprintf('\n')