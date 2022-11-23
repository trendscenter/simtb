function Baseline = simtb_makeBaseline(sP, sub)
% simtb_makeBaseline()  - Generate baseline intensity map for each subject
%                         Based on definitions of all functions in simtb_SMsource().
%
% Usage:
%  >> Baseline = simtb_makeBaseline(sP, sub)
%
% INPUTS:
%  sP         = parameter structure used in the simulations
%  sub        = index number for subject
%
% OUTPUTS:
% Baseline    = nV x nV spatial map of the signal intensity for selected subject
%
% see also: simtb_generateSM(), simtb_SMsource()


if nargin < 2
    sub = 1;
end

nC = sP.nC;
nV = sP.nV;
D_baseline = sP.D_baseline;
D_TT_FLAG = sP.D_TT_FLAG;
D_TT_level = sP.D_TT_level;
SM_source_ID = sP.SM_source_ID;
SM_translate_x = sP.SM_translate_x;
SM_translate_y = sP.SM_translate_y;
SM_theta = sP.SM_theta;
SM_present = sP.SM_present;
SM_spread  = sP.SM_spread;

%% Initialize whole map have to intensity 1;
TissueMap = ones(nV,nV);


if D_TT_FLAG
    %% Load up each SM and adjust Tissue Type where appropriate
    for c = 1:nC
        [SMtemp, TT] =  simtb_generateSM(SM_source_ID(c), nV, SM_translate_x(sub,c), SM_translate_y(sub,c), SM_theta(sub,c), SM_spread(sub,c));
        TissueMap = TissueMap + SM_present(sub,c)*(D_TT_level(TT)-1)*abs(SMtemp);
    end
end

%% set outside of brain to have zero intensity
MASK = simtb_createmask(sP);

Baseline = D_baseline(sub)*MASK.*TissueMap;

