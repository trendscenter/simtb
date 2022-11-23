function [Dnew, sP, mp] = simtb_addMotion(sP, D, sub)
% simtb_addMotion()  - Simulates motion (translation/rotation) of dataset
%                  Pads images to larger dimensions
%                  Translates and rotates images at each time point
%
% Usage:
%       >> [Dnew, sP, mp] = simtb_addMotion(sP, D, sub)
%
% INPUTS:
%   sP         = parameter structure used in the simulations
%   D          = dataset with dimensions [nT, nV*nV]
%   sub        = index number for subject
%
% OUTPUTS:
%   Dnew       = new dataset with simulated motion      
%   sP         = parameter structure, updated with new nV
%   mp         = [nT, 3] matrix of motion parameters [x-trans ,y-trans, rotation].
%                Translation units are proportions of the original image length.
%                Rotation units are degrees.
%
% see also: simtb_makeMotParams()


[nT, nVsq] = size(D);
nVold = sqrt(nVsq); % the original size of the image
D = reshape(D, nT, nVold, nVold);


MAX_TRANS = round(sP.D_motion_TRANSmax*nVold);
MAX_ROT   = sP.D_motion_ROTmax;

Npad = 2*MAX_TRANS;
nV = nVold + Npad;
sP.DnV = nV;                    % sP is updated
Dnew = zeros(nT, nV, nV);

% get the motion parameters (in voxels and in degrees)
mp = simtb_makeMotParams(nT, sP.D_motion_deviates(sub,:), MAX_TRANS, MAX_ROT);

% fix translation so that the maximum does not go outside the bounding box
mp(mp(:,[1 2]) > MAX_TRANS) = MAX_TRANS;

% coordinate system of original image
domain = [-1,1];
arg = linspace(domain(1),domain(end),nVold);

% coordinate system of padded image
dv = arg(2)-arg(1);
domain = [-1-dv*MAX_TRANS,1+dv*MAX_TRANS];
arg = linspace(domain(1), domain(2), nV);
[x,y] = meshgrid(arg,arg);

% mask (inside the head) in the original image
r = sqrt(x.^2+y.^2);
MASK = (r<=1);

% factor to convert from voxels to coordinate system of padded image 
f = diff(domain)/nV;

%------------Move one image at a time ------------

for t = 1:nT
    % Work with one image at a time
    Dt = squeeze(D(t,:,:));

    % pad the original image
    Dt = [zeros(MAX_TRANS, nV);...
         [zeros(nVold,MAX_TRANS), Dt, zeros(nVold,MAX_TRANS)];...
          zeros(MAX_TRANS, nV)];
    
    % to improve interpolation, set background intensity to the baseline
    Dt(MASK == 0) = sP.D_baseline(sub);

    % new coordinate system of transformed image
    % convert mp to units on the new coordinate system and to radians
    
    xprime = cos(mp(t,3)*pi/180)*(x-mp(t,1)*f) - sin(mp(t,3)*pi/180)*(y-mp(t,2)*f);
    yprime = sin(mp(t,3)*pi/180)*(x-mp(t,1)*f) + cos(mp(t,3)*pi/180)*(y-mp(t,2)*f);
    rprime = sqrt(xprime.^2+yprime.^2);
    MASKprime = (rprime<=1);

    % interpolate
    Dt = interp2(x,y,Dt,xprime,yprime, 'linear');
    
    % set background to 0
    Dt(MASKprime == 0) = 0;
    Dnew(t,:,:) = Dt;
end
% ------------------------------------------------

% for writing motion parameters to file, put translation in units relative to original image size
mp(:,[1,2]) = mp(:,[1,2])/nVold;

% vectorize the new dataset
Dnew = reshape(Dnew, nT, nV, nV);