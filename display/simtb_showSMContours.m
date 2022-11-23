function [F, CH] = simtb_showSMContours(SM, contour_level, CMAP, FILL_flag, LEGEND_flag, BLKbg_flag, fignameORAxis)
%   simtb_showSMContours()  - Plot SMs as contours
%
%   Usage:
%    >> [F, CH] = simtb_showSMContours(SM, contour_level, CMAP, FILL_flag, LEGEND_flag, BLKbg_flag, fignameORAxis)
%
%   INPUTS:
%   SM            = SMs, size = [number of components x number of voxels]
%   contour_level = level at which to draw contours [OPTIONAL, default = 0.5]
%   CMAP          = [nC x 3] matrix of colors for contours [OPTIONAL, default = 'jet']
%                   e.g., for 3 components: [[1 0 0]; [0 1 0], [0 0 1]];
%   FILL_flag     = 1|0, 1 to fill the contours [OPTIONAL, default = 1]
%   LEGEND_flag   = 1|0, 1 to include legend [OPTIONAL, default = 1]
%   BLKbg_flag    = 1|0, 1 to have black background [OPTIONAL, default = 1]
%   fignameORAxis = name of figure (OPTIONAL); Alternatively, can be the handle of an axis to plot on
%
%   OUTPUTS:
%   F             = Figure handle
%   CH            = Contour handles
%
% see also: simtb_showSM()

if nargin < 7
    figname = '';
    HA = [];
else
    if ~ischar(fignameORAxis)
      HA = fignameORAxis;
      figname = '';
    else
        HA = [];
        figname = fignameORAxis;
    end
end

if nargin < 6 || isempty(BLKbg_flag)
    BLKbg_flag = 1;
end

if nargin < 5 || isempty(LEGEND_flag)
    LEGEND_flag = 1;
end

if nargin < 4 || isempty(FILL_flag)
    FILL_flag = 1;
end

if nargin < 3 || isempty(CMAP)
    CMAP = jet(size(SM,1));
end

if nargin < 2 || isempty(contour_level)
    contour_level = 0.5;
end

if LEGEND_flag
    aspectRatio = 1.21; % width/height
else
    aspectRatio = 1; % width/height
end
fscale = 0.3; % relative to screen

RECT = simtb_figdimension(aspectRatio, fscale, 'cm');

if BLKbg_flag
    bg = [0 0 0];
    fg = [1 1 1];
else
    bg = [1 1 1];
    fg = [0 0 0];
end

% %-----------Set Graphics Figure--------------------------
if isempty(HA)
F = figure('units', 'pixels', 'Position', RECT, 'MenuBar', 'figure', ...
    'color', bg, 'DefaultTextColor', fg, 'DefaultAxesColor', bg, ...
    'DefaultAxesYColor', bg, 'DefaultAxesZColor', bg, 'DefaultPatchFaceColor', fg, ...
    'DefaultPatchEdgeColor', fg,'DefaultSurfaceEdgeColor', fg, 'DefaultLineColor', fg, ...
    'Visible', 'off', 'Name', figname, 'resize', 'on');
else
    F = gcf;
end

Hmargin = 0.05;
Wmargin = 0.2;
W = 1-Wmargin;
H = (1-Hmargin);
Hdelta = Hmargin/2; % allow for top buffer

if LEGEND_flag == 1
    L = Wmargin*.025;
else
    L = Wmargin/2;
end

if isempty(HA)
    HA = axes('Position', [L, Hdelta, W,H]);
end
set(HA, 'FontSize', 7)
CH = plot_SMs_and_contours(F, SM, contour_level, CMAP, FILL_flag, LEGEND_flag, bg, fg);
  
% now display the figure
set(F, 'Visible', 'on')


function [CH] = plot_SMs_and_contours(F, SM, contour_level, CMAP, FILL_flag, LEGEND_flag, bg, fg)
figure(F)
[nC, nVV] = size(SM);
nV = sqrt(nVV);
SM = reshape(SM, nC, nV, nV);

MAP = zeros(nV,nV);
arg1 = linspace(-1,1,nV);
[x,y] = meshgrid(arg1,arg1);
MAP = squeeze(sum(SM,1));

%% plot the summed activation
CLIM = [min(abs(MAP(:))), max(abs(MAP(:)))];
IM = imagesc(arg1,arg1,MAP, CLIM); colormap(gray);
axis xy
set(gca, 'Color', 'k');
axis square;
set(gca, 'XTick', [], 'YTick', [])
axis off
hold on


%% plot contours and collect the contour handles
for ii = 1:nC;
    SMtemp = squeeze(SM(ii,:,:));
    absmax = max(abs(SMtemp(:)));
    SMtemp = SMtemp/absmax;
    SM(ii,:,:) = SMtemp;
    SMtemp = abs(ii*SMtemp);
    threshold = ii*contour_level;
    [junk, CH(ii)] = contour(arg1,arg1, SMtemp, [threshold threshold]);
    hold on
    set(CH(ii), 'LineColor', CMAP(ii,:), 'LineWidth', 1)
end


for ii = 1:nC
    set(CH(ii), 'fill', 'on', 'LineWidth', 2);
    patches = get(CH(ii), 'Children');
    if FILL_flag
        set(patches, 'FaceColor', simtb_lighten_color(CMAP(ii,:), 0.8));
        OH(ii) = patches(1);
    else
        set(CH(ii), 'fill', 'off');
        OH(ii) = CH(ii);
    end
end

delete(IM)

%% plot the boundaries of the head
BL = polar(linspace(0,2*pi,256),ones(1,256));
set(BL, 'Color', fg, 'LineWidth', 1)


if LEGEND_flag
    %% make a legend
    set(gca, 'units', 'normalized');
    axPos = get(gca, 'Position');
    L = legend(OH, num2str([1:nC]'));
    set(L, 'units', 'normalized','FontSize', 8 ,'Color', bg, 'EdgeColor', bg);
    LPos = get(L, 'Position');     % [left bottom width height]
    set(L, 'Position', [axPos(1)+axPos(3), .5-LPos(4)/2, LPos(3), LPos(4)])
    %set(L, 'Location', 'EastOutside')
end
