function [TCall, filenames] = simtb_group_getTC(sP, subIND)
%   simtb_group_getTC()  - Loads saved subject TCs (time courses)
%
%   Usage:
%    >> TCall = simtb_group_getTC(sP);
%    >> TCall = simtb_group_getTC(sP, [1 8]);
%
%   INPUTS:
%   sP            = parameter structure used in the simulations
%   subIND        = indices of subject(s) to load [OPTIONAL, default = all subjects]
%
%   OUTPUTS:
%   TCall         = TCs from subjects: [subjects x nT time points x nC components]
%   filenames     = filenames of simulated data in the order they were loaded.
%
%   see also: simtb_main()

if nargin < 2 || isempty(subIND)
    subIND = 1:sP.M;
end

nsub = length(subIND);
TCall = zeros(nsub, sP.nT, sP.nC);

fprintf('Loading simulated subject TCs: ')
for sub = 1:nsub

    if sub == 1
        fprintf('1')
    elseif sub == nsub
        fprintf('%d', nsub)
    else
        fprintf('.')
    end

    tfile = simtb_makefilename(sP, 'SIM', subIND(sub));

    %load in each subject's TC
    tempTC = load(tfile, 'TC');
    TCall(sub,:,:) = tempTC.TC;

    % keep track of the filenames
    filenames{sub} = tfile;
end
fprintf('\n')