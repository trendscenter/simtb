function mp = simtb_makeMotParams(nT, dev, MAX_TRANS, MAX_ROT)
% simtb_makeMotParams()  - Generates motion time series
%                  Uses an AR(1) process (with fixed parameter at p=0.95)
%                  to generate translation in x and y directions and rotation.
% 
% Usage:
%       >> mp = simtb_makeMotParams(nT, dev, MAX_TRANS, MAX_ROT)
%
% INPUTS:
%   nT        = number of TRs (time points)
%   dev       = [1 x 3] vector of standard deviations of Gaussian deviates for [x-trans, y-trans, rotation]
%   MAX_TRANS = furthest from 0 that x or y translation should get
%             (based on simulations: dev=1 and p=0.95 gives max translation of roughly 10 pixels)
%   MAX_ROT   = similar to MAX_TRANS but for rotation in degrees
%
% OUTPUTS:
%   mp        = [nT x 3] matrix of motion time series (x-pos, y-pos, rotation)
%               x-pos and y-pos are in units of voxels
%               rotation is in units of degrees
%
% see also: simtb_addMotion()

% AR(1) parameter, |p|<1 to be wide-sense stationary
% p=1 is random walk, p=0 is just deviations from zero

p = 0.95; 
maxstd = 10; % 0.95 allows max motion out to about 10 standard deviations

% random deviates for motion: x-trans, y-trans, rotation
% all scaled by dev for standard deviation
Z = repmat(dev, nT, 1).*randn(nT,3);

% AR(1) time series will max around maxmot standard deviations (when dev=1)
% We want to set this maximum to MAX_TRANS or MAX_ROT
Z(:,[1 2]) = MAX_TRANS/maxstd * Z(:,[1 2]);
Z(:,  3  ) = MAX_ROT  /maxstd * Z(:, 3  );

% initialize time series
mp = zeros(nT,3); 
for i=2:nT;
    % AR(1) process updated at each time step
    mp(i,:) = p * mp(i-1,:) + Z(i,:);
end;
