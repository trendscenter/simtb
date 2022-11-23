function SM = simtb_makeSM(sP, sub)
%   simtb_makeSM()  - Makes component SMs (spatial maps) 
%                     Generates the SM.
%                     Adds Gaussian noise.
%   USAGE:
%    >> SM = simtb_makeSM(sP, sub);
%
%   INPUTS: (OPTIONAL)
%   sP            = parameter structure used in the simulations
%   sub           = index number for current running subject 
%
%   OUTPUTS:
%   SM            = Generated spatial maps matrix 
%
%   see also: simtb_main(), simtb_generateSM()

nC = sP.nC;
nV = sP.nV;
SM_source_ID = sP.SM_source_ID;
SM_translate_x = sP.SM_translate_x;
SM_translate_y = sP.SM_translate_y;
SM_theta = sP.SM_theta;
SM_present = sP.SM_present;
SM_spread  = sP.SM_spread;
%% initialize SM
SM = zeros(nC, nV*nV);   
mask = simtb_createmask(sP);
mask = reshape(mask,1,nV*nV);
for c=1:nC
    Temp =  simtb_generateSM(SM_source_ID(c), nV, SM_translate_x(sub,c), SM_translate_y(sub,c), SM_theta(sub,c), SM_spread(sub,c));
    %SM(c,:) = mask.*(SM_present(sub,c)*reshape(Temp,1,nV*nV));
    % add a bit of Gaussian noise so SMs will never be flat or completely identical
    SM(c,:) = mask.*(SM_present(sub,c)*reshape(Temp,1,nV*nV) + 0.005*randn(1, nV*nV));    
    clear Temp     
end

