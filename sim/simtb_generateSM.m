function [SM,TT] = simtb_generateSM(sourceID, nV, offset_x, offset_y, theta, spread)
% simtb_generateSM()  - Generates a SM based on definitions in simtb_SMsource()
%
% Usage:
%  >> [SM,TT] = simtb_generateSM(sourceID, nV);  
%  >> [SM,TT] = simtb_generateSM(sourceID, nV, offset_x, offset_y, theta, spread);
%  
% INPUTS:
% sourceID   = ID of source to generate
% nV         = number of 1-D voxels; image will be nV x nV
% offset_x   = offset in x (in pixels) [OPTIONAL, default = 0]
% offset_y   = offset in y (in pixels) [OPTIONAL, default = 0]
% theta      = rotation in degrees [OPTIONAL, default = 0]  
% spread     = spatial magnification factor [OPTIONAL, default = 1]
%
% OUTPUTS:
% SM         = nV x nV spatial mapindices of the selected spatial map
% TT         = Tissue Type of SM [e.g., 1 = SIGNAL DROPUT, 2 = WM, 3 = GM, 4 = CSF]
%
% see also: simtb_SMsource()

if nargin < 5
    offset_x = 0;
    offset_y = 0;
    theta = 0;
    spread = 1;
end

%%  function defined over [-1, 1]
domain = [-1,1];
arg1 = linspace(domain(1),domain(end),nV);  
[x,y] = meshgrid(arg1,arg1); 

%% convert from pixels to units in [-1, 1]
offset_x = diff(domain)*offset_x/nV;
offset_y = diff(domain)*offset_y/nV;

theta_rad = theta*(pi/180); % convert from degrees to radians
[SM,TT] = simtb_SMsource(x, y, offset_x, offset_y, theta_rad, sourceID);

%% normalize the SM to have maximum absolute amplitude of 1
absmax = max(abs(SM(:)));
SM = SM/absmax;

%% Alter distribution to be more narrow or broad
SMsign = sign(SM);
SM = SMsign.*abs(SM).^(1/spread);
