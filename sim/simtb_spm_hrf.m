function [hrf,p] = simtb_spm_hrf(RT,P)
% simtb_spm_hrf() - Returns a hemodynamic response function
%
% USAGE:
% >> [hrf,p] = simtb_spm_hrf(RT,[p]);
%
%INPUT:
% RT   - scan repeat time
% p    - 1x7 vector of parameters for the response function (two gamma functions)
%							                          (default value, in seconds)							
%	p(1) - delay of response (relative to onset)	  (6)
%	p(2) - delay of undershoot (relative to onset)    (16)
%	p(3) - dispersion of response			          (1)
%	p(4) - dispersion of undershoot			          (1)
%	p(5) - ratio of response to undershoot            (6)
%	p(6) - onset (seconds)				              (0)
%	p(7) - length of kernel (seconds)	              (32)
%
% OUTPUT:
% hrf  - hemodynamic response function
% p    - parameters of the response function
%_______________________________________________________________________
% Copyright (C) 2005 Wellcome Department of Imaging Neuroscience

% Karl Friston
% $Id: spm_hrf.m 387 2005-12-17 18:31:23Z klaas $


% default parameters
%-----------------------------------------------------------------------
fMRI_T = 16;

p     = [6 16 1 1 6 0 32];
if nargin > 1
      p(1:length(P)) = P;
end

% modelled hemodynamic response function - {mixture of Gammas}
%-----------------------------------------------------------------------
dt    = RT/fMRI_T;
u     = [0:(p(7)/dt)] - p(6)/dt;
hrf   = simtb_spm_Gpdf(u,p(1)/p(3),dt/p(3)) - simtb_spm_Gpdf(u,p(2)/p(4),dt/p(4))/p(5);
hrf   = hrf([0:(p(7)/RT)]*fMRI_T + 1);
hrf   = hrf'/sum(hrf);
