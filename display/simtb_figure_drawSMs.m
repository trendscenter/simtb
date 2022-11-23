function [CH, CMAP] = simtb_figure_drawSMs(H, nV, contour_level, sP, sub)
% simtb_figure_drawSMs() - Shows contours for all defined SMs
%
% Usage: 
%  >> [CH, CMAP] = simtb_figure_drawSMs;
%  >> [CH, CMAP] = simtb_figure_drawSMs(H, nV, contour_level)
%  >> [CH, CMAP] = simtb_figure_drawSMs(H, nV, contour_level, sP, sub)
%
% INPUTS:
% H             = axis handle [OPTIONAL, default = gca]
% nV            = number of 1-D voxels; image will be nV x nV [OPTIONAL, default = 256]
% contour_level = level at which to draw contours [OPTIONAL, default = 0.5]
% sP            = parameter structure [OPTIONAL, but required if sub is defined]
% sub           = subject index [OPTIONAL]
%
% OUTPUTS:
% CH            = children figure handles
% CMAP          = colormap
%
%   see also: simtb_pickSM(), simtb_pickedSM()

if nargin < 1 || isempty(H)
    H = gca;
end

if nargin < 2 || isempty(nV)
    nV = 256;
end

if nargin < 3 || isempty(contour_level)
   contour_level = 0.5;
end

if nargin < 4
    sP = [];
    sub = [];
end

nSM = simtb_countSM; % number of SM that are defined
neach = ceil(nSM/5);
CMAP = [ (jet(neach+5)); ...
    summer(neach-1); ...
    cool(neach-1); ...
    autumn(neach-2); ...
    winter(neach-1); ...
    ];

CMAP = [.5 .5 .5; CMAP(1:nSM-1,:)];




if isempty(sP)
    SMID = 1:nSM;
else
    nSM = length(sP.SM_source_ID);
    SMID = sP.SM_source_ID;
    CMAP = CMAP(SMID,:);
end



%% initialize
MAP = zeros(nV,nV);
arg1 = linspace(-1,1,nV);
[x,y] = meshgrid(arg1,arg1);
r = sqrt(x.^2 + y.^2);
MASK = r<1;

%% Load up each SM -- if given sP only show selected SMs
for ii = 1:nSM;
    %  [SM,TT] = simtb_generateSM(sourceID, nV, offset_x, offset_y, theta, spread)
    if isempty(sP)
        SMtemp =  simtb_generateSM(SMID(ii),nV);
    else
        SMtemp = simtb_generateSM(SMID(ii),nV, sP.SM_translate_x(sub,ii), sP.SM_translate_y(sub,ii), sP.SM_theta(sub,ii), sP.SM_spread(sub,ii));
    end
    SMtemp = SMtemp.*MASK;
    MAParray{ii} =  SMtemp;
    MAP = MAP+SMtemp;
end

%% plot the combination of all spatial maps
axes(H)
CLIM = [min(abs(MAP(:))), max(abs(MAP(:)))];
imagesc(arg1,arg1,MAP, CLIM); colormap(gray);
axis xy
set(gca, 'Color', 'k');
axis square;
axis off
hold on

%% plot the boundaries of the head
 BL = polar(linspace(0,2*pi,256),ones(1,256));
 set(BL, 'Color', 'w', 'LineWidth', 2)

%% plot contours and collect the contour handles
for ii = 1:nSM;
    SMtemp = MAParray{ii};
    SMtemp = (abs(ii*SMtemp));
    threshold = ii*contour_level;  
    [junk, CH{ii}] = contour(arg1,arg1, SMtemp, [threshold threshold], 'fill', 'on');
  %  set(CH{ii}, 'FaceColor', simtb_lighten_color(CMAP(ii,:), 0.7));
    hold on
    set(CH{ii}, 'LineColor', CMAP(ii,:), 'LineWidth', 1)
end
