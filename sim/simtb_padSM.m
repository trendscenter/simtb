function SMnew = simtb_padSM(SM, Npad)
% simtb_padSM()  - Pads SM dimensions to accomodate head translation
% 
% Usage:
%       >> SMnew = simtb_padSM(SM, Npad)
%
% INPUTS:
%   SM       = Spatial Maps, size [nC x nV*nV]
%   Npad     = Number of elements to add, should be EVEN.
%
% OUTPUTS:
%   SMnew    = padded spatial maps, size [nC x (nV+Npad)*(nV+Npad)]
%
% see also: simtb_addMotion(), simtb_makeMotParams()



nC = size(SM,1);
nVold = sqrt(size(SM,2));
nV = nVold+Npad;

SM = reshape(SM, nC, nVold, nVold);
SMnew = zeros(nC, nV, nV);

h = round(Npad/2);

for c = 1:nC
    SMc = [zeros(h, nV);...
        [zeros(nVold,h), squeeze(SM(c,:,:)), zeros(nVold,h)];...
        zeros(h, nV)];
    SMnew(c,:,:) = SMc;
end

SMnew = reshape(SMnew, nC, nV*nV);