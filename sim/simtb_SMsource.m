function [z,TT] = simtb_SMsource(x, y, randx, randy, randrot, sourceID)
% simtb_SMsource()  - Contains the definitions of the 2-D SMs and their tissue types
%
% Usage:
%  >> [z,TT] = simtb_SMsource(x, y, randx, randy, randrot, nV, sourceID);
%
% INPUTS:
% x         = x matrix over which z is evaluated (nV x nV, defined using meshgrid)
% y         = y matrix over which z is evaluated (nV x nV, defined using meshgrid)
% randx     = offset in x (in normalized units, [-1,1])
% randy     = offset in y (in normalized units, [-1,1])
% randrot   = rotation (in radians)
% sourceID  = ID of function to evaluate
%
% OUTPUTS:
% z =  nV x nV spatial map
% TT = Tissue Type [e.g., 1 = SIGNAL DROPOUT, 2 = WM, 3 = GM, 4 = CSF]
%
% see also: simtb_generateSM(), simtb_pickSM()

%--------------------------------------------------------------------------
% sourceID list: Anatomical descriptions are provided to facilitate 
% correspondence of between sourceIDs and the SMs they generate.
%--------------------------------------------------------------------------
%  1 Global Mean Signal
%  2 Bilateral Visual
%  3 Bilateral Visual - more posterior
%  4 Left Frontal
%  5 Right Frontal
%  6 Medial Frontal
%  7 Precuneus
%  8 Default Mode Network: angular gyri, ACC, PCC
%  9 Bilateral Post-central
% 10 Bilateral Pre-central
% 11 Medial Visual cortex
% 12 Subcortical nuclei -- caudate nucleus head
% 13 Subcortical nuclei -- putamen
% 14 Lateral ventricles -- occipital horn
% 15 Lateral ventricles -- frontal horn
% 16 White matter tracts - anterior + genu
% 17 White matter tracts - posterior + splenium
% 18 Dorsal Attention Network: superior parietal, frontal-eye fields
% 19 Right Frontoparietal
% 20 Left Frontoparietal
% 21 Subcortical nuclei -- thalamus
% 22 Left SensoriMotor
% 23 Right SensoriMotor
% 24 Bilateral frontal
% 25 Left frontal pole
% 26 Right frontal pole
% 27 Left Auditory
% 28 Right Auditory
% 29 Right Hippocampus
% 30 Left Hippocampus
%--------------------------------------------------------------------------

if sourceID == 1
    %% Global Mean Signal
    % NOTE: unlike other sources, source 1 cannot be translated or rotated.
    theta = 0;
    r = sqrt(x.^2+y.^2);
    z = r<1;
    TT = 3;
    
elseif sourceID == 2
    %% Bilateral Visual
    theta = pi/8;
    z1 = make_blob(x,y, 0.35 + randx, -.68 + randy, 8, 11, theta + randrot);
    theta = -pi/8;
    z2 = make_blob(x,y, -0.35 + randx, -.68 + randy, 8, 11, theta + randrot);
    z = z1+z2;
    TT = 3;
    
elseif sourceID == 3
    %% Bilateral Visual - more posterior
    theta = -pi/8;
    % right
    z1 = make_blob(x,y, 0.3 + randx, -.85 + randy, 5, 15, theta + randrot);
    % left
    z2 = make_blob(x,y, -0.3 + randx, -.85 + randy, 5, 15, -theta + randrot);
    z = z1 + z2;
    TT = 3;
    
elseif sourceID == 4
    %% Left Frontal
    theta = 3*pi/4;
    z = make_blob(x,y, -0.62 + randx, .62 + randy, 5, 10, theta + randrot);
    TT = 3;
    
elseif sourceID == 5
    %% Right Frontal
    theta = -3*pi/4;
    z = make_blob(x,y, 0.62 + randx, .62 + randy, 5, 10, theta + randrot);
    TT = 3;
    
elseif sourceID == 6
    %% Medial Frontal
    theta = pi/2;
    z = make_blob_grad(x,y, 0.0 + randx,  0.85 + randy, 6, 5, theta + randrot);
    TT = 1;
    
elseif sourceID == 7
    %% Precuneus
    theta = -pi/2;
    z = make_blob_grad(x,y, 0.0 + randx,  -0.72 + randy, 10, 4, theta + randrot);
    TT = 3;  
elseif sourceID == 8
    %% Default Mode Network
    theta = 0;
    % ACC
    z1 = make_blob(x,y,  0 + randx, .55 + randy, 10, 7, theta + randrot);
    % PCC
    z2 = make_blob(x,y,  0 + randx, -.5 + randy, 6, 6, theta + randrot);
    % angular gyrus (right)
    z3 = make_blob(x,y, 0.55 + randx, -.6 + randy, 12, 12, theta + randrot);
    % angular gyrus (left)
    z4 = make_blob(x,y, -0.55 + randx, -.6 + randy, 12, 12, theta + randrot);
    z = z1 + z2 + 0.7*z3 + 0.7*z4;
    TT = 3;
    
elseif sourceID == 9
    %% Bilateral Post-central
    theta = -pi/4;
    z1 = make_blob(x,y, 0.5 + randx, .2 + randy, 5, 12, theta + randrot);
    theta = pi/4;
    z2 = make_blob(x,y, -0.5 + randx, .2 + randy, 5, 12, theta + randrot);
    z = z1+z2;
    TT = 3;

elseif sourceID == 10
    %% Bilateral Pre-central
    theta = -pi/4;
    z1 = make_blob(x,y, 0.5 + randx, .4 + randy, 6, 11, theta + randrot);
    theta = pi/4;
    z2 = make_blob(x,y, -0.5 + randx, .4 + randy, 6, 11, theta + randrot);
    z = z1+z2;
    TT = 3;

elseif sourceID == 11
    %% Medial Visual cortex
    theta = 0;
    z = make_blob(x,y, 0 + randx, -0.9 + randy, 7, 12, theta + randrot);
    TT = 3;

elseif sourceID == 12
    %% Subcortical nuclei -- caudate nucleus head
    theta = pi/8;
    z1 = make_blob(x,y, 0.18 + randx,  0.1 + randy, 17, 9, theta + randrot);
    z2 = fliplr(z1);
    z = z1+z2;
    TT = 3;

elseif sourceID == 13
    %% Subcortical nuclei -- putamen
    theta = -pi/5;
    z1 = make_blob(x,y, 0.27 + randx,  -0.05 + randy, 15, 8, theta + randrot);
    z2 = fliplr(z1);
    z = z1+z2;
    TT = 3;

elseif sourceID == 14
    %% Lateral ventricles -- occipital horn
    theta = pi/4;
    z1 = make_blob(x,y, 0.18 + randx,  -0.27 + randy, 8, 20, theta + randrot);
    z2 = fliplr(z1);
    z = z1+z2;
    TT = 4;

elseif sourceID == 15
    %% Lateral ventricles -- frontal horn
    theta = pi/16;
    z1 = make_blob(x,y, 0.08 + randx,  0.15 + randy, 22, 6, theta + randrot);
    z2 = fliplr(z1);
    z = z1+z2;
    TT = 4;

elseif sourceID == 16
    %% White matter tracts - anterior + genu
    theta = -7*pi/8;
    z1 = make_blob_grad(x,y, 0.30 + randx,  0.43 + randy, 8, 4, theta + randrot);
    z2 = fliplr(z1);
    theta = 0;
    z3 = make_blob(x,y, 0 + randx, 0.35 + randy, 5, 15, theta + randrot);
    z = z1 + z2 + 0.7*z3;
    TT = 2;

elseif sourceID == 17
    %% White matter tracts - posterior + splenium
    theta = 2*pi/3;
    z1 = make_blob_grad(x,y, 0.3 + randx,  -0.48 + randy, 7, 4, theta + randrot);
    z2 = fliplr(z1);
    theta = 0;
    z3 = make_blob(x,y, 0 + randx, -.32 + randy, 5, 18, theta + randrot);
    z = z1+z2+0.6*z3;
    TT = 2;

elseif sourceID == 18
    %% Dorsal Attention Network
    % superior parietal
    theta = pi/4;
    z1 = make_blob(x,y, 0.6 + randx, -.70 + randy, 12, 4, theta + randrot);
    z2 = fliplr(z1);
    % frontal-eye fields
    theta = 0;
    z3 = make_blob(x,y, 0.47 + randx,  0.55 + randy, 14, 10, theta + randrot);
    z4 = fliplr(z3);
    z = z1+z2+z3+z4;
    TT = 3;

elseif sourceID == 19
    %% Right Frontoparietal
    % parietal
    theta = pi/6;
    z1 = make_blob_grad(x,y, 0.75 + randx, -.40 + randy, 7, 4, theta + randrot);
    % frontal
    theta = 5*pi/6;
    z2 = make_blob_grad(x,y,  0.80 + randx, .35 + randy, 8, 4, theta + randrot);
    z = z1+z2;
    TT = 3;

elseif sourceID == 20
    %% Left Frontoparietal
    % parietal
    theta = 5*pi/6;
    z1 = make_blob_grad(x,y, -0.75 + randx, -.40 + randy, 7, 4, theta + randrot);
    % frontal
    theta = pi/6;
    z2 = make_blob_grad(x,y,  -0.80 + randx, .35 + randy, 8, 4, theta + randrot);
    z = z1+z2;
    TT = 3;
elseif sourceID == 21
    %% Subcortical nuclei -- thalamus
    theta = 0;
    z1 = make_blob(x,y, 0.1 + randx,  -0.1 + randy, 13, 9, theta + randrot);
    z2 = fliplr(z1);
    z = z1+z2;
    TT = 3;
elseif sourceID == 22
    %% Left SensoriMotor
    theta = 0;
    z = make_blob_grad(x,y,  -.72 + randx, 0 + randy, 3, 5, theta + randrot);
    TT = 3;

elseif sourceID == 23
    %% Right SensoriMotor
    theta = pi;
    z = make_blob_grad(x,y,  0.72 + randx, 0 + randy, 3, 5, theta + randrot);
    TT = 3;

elseif sourceID == 24
    %% Bilateral frontal
    theta = -pi/3;
    z1 = make_blob(x,y, 0.2 + randx, .6 + randy, 5, 11, theta + randrot);
    z2 = fliplr(z1);
    z = z1+z2;
    TT = 3;
elseif sourceID == 25
    %% Left frontal pole
    theta = pi/2.5;
    z = make_blob_grad(x,y,  -0.32 + randx, .8 + randy, 8, 6, theta + randrot);
    TT = 3;
elseif sourceID == 26
    %% Right frontal pole
    theta = pi-pi/2.5;
    z = make_blob_grad(x,y,  0.32 + randx, .8 + randy, 8, 6, theta + randrot);
    TT = 3;

elseif sourceID == 27
    %% Left Auditory
    theta = 0;
    z = make_blob(x,y, 0.5 + randx, -0.2 + randy, 7, 3, theta + randrot);
    TT = 3;
    
elseif sourceID == 28
    %% Right Auditory
    theta = 0;
    z = make_blob(x,y, -0.5 + randx, -0.2 + randy, 7, 3, theta + randrot);
    TT = 3;
    
elseif sourceID == 29
    %% Right Hippocampus
    theta = pi/4;
    z = make_blob(x,y, 0.31 + randx, -.22 + randy, 5, 13, theta + randrot);
    TT = 3;
    
elseif sourceID == 30
    %% Left Hippocampus
    theta = -pi/4;
    z = make_blob(x,y, -0.31 + randx, -.22 + randy, 5, 13, theta + randrot); 
    TT = 3;
    
else
    %% Important 'else' condition for determining number of components.  Do not remove.
    z = [];
    TT=[];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function B = make_blob(x, y, x0, y0, xwidth, ywidth, theta)
% Sub-function for making a 2-D Gaussian
xprime = cos(theta)*(x-x0) - sin(theta)*(y-y0);
yprime = sin(theta)*(x-x0) + cos(theta)*(y-y0);
xgauss = exp(-(xwidth*(xprime)).^2);
ygauss = exp(-(ywidth*(yprime)).^2);
B = xgauss.*ygauss;

function B = make_blob_grad(x, y, x0, y0, xwidth, ywidth, theta)
% Sub-function for making a 2-D Gaussian * a gradient in X.  
% To make the gradient in Y, rotate the blob pi/2 radians.
xprime = cos(theta)*(x-x0) - sin(theta)*(y-y0);
yprime = sin(theta)*(x-x0) + cos(theta)*(y-y0);
xgauss = exp(-(xwidth*(xprime)).^2);
ygauss = exp(-(ywidth*(yprime)).^2);
ygaussXgrad = exp(-((((sqrt(ywidth)+xprime).^2).*yprime)).^2);
B = xgauss.*ygaussXgrad;

