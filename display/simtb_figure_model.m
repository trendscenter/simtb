function model_figure = simtb_figure_model(sP, sub, contour_level, WhichPanels)
% simtb_figure_model() - Shows SM contours and/or Tissue Model
%
% USAGE:
% >> model_figure = simtb_figure_model(sP, sub, contour_level, WhichPanel)
%
% INPUTS: 
% sP             = parameter structure
% sub            = subject index [OPTIONAL, default = 1]
% contour_level  = level at which to draw contours [OPTIONAL, default = 0.5]
% WhichPanels    = Type of data to plot, 1 = Map of Sources; 2 = Tissue Type Model; 
%                  [OPTIONAL, default is both([1,2])]
%
% OUTPUTS:
% model_figure   = figure handle
%
%   see also: simtb_main()

if nargin < 2
    sub = 1;
end

if nargin < 3
    contour_level = 0.5;
end

if nargin < 4
    WhichPanels = [1,2];
end

DATANAME = {'Component Map', 'Baseline Map'};
DATANAME = DATANAME(WhichPanels);

if length(DATANAME) == 1
    aspectRatio = 1.2; % width/height
    fscale = 0.45; % relative to screen
else
    aspectRatio = 0.65; % width/height
    fscale = 0.8; % relative to screen
end

figname = 'simulation model';
RECT = simtb_figdimension(aspectRatio, fscale, 'cm');
% %-----------Set Graphics Figure--------------------------
model_figure = figure('units', 'pixels', 'Position', RECT, 'MenuBar', 'figure', ...
    'color', [0 0 0], 'DefaultTextColor', 'w', 'DefaultAxesColor', 'w', ...
    'DefaultAxesYColor', 'w', 'DefaultAxesZColor', 'w', 'DefaultPatchFaceColor', 'w', ...
    'DefaultPatchEdgeColor', 'w','DefaultSurfaceEdgeColor', 'w', 'DefaultLineColor', 'w', ...
    'Visible', 'off', 'Name', figname, 'resize', 'on');

Hmargin = 0.2;
Wmargin = 0.2;
W = 1-Wmargin;
H = (1-Hmargin)/(length(DATANAME)); 
Hdelta = Hmargin/(length(DATANAME)+1); % allow for top buffer
L = Wmargin/4;

Nrows = length(DATANAME);
Ncols = 1;
for ii = 1:Nrows
    HA(ii) = subplot('Position', [L, Hdelta*(ii) + H*(ii-1), W,H]);
    set(HA(ii), 'FontSize', 7)
    if strcmp(DATANAME{ii}, 'Component Map')
        [CH, CMAP] = simtb_figure_pickedSM(sP.SM_source_ID, HA(ii), sP.nV, contour_level, sP, sub);
    elseif strcmp(DATANAME{ii}, 'Baseline Map')
        Baseline = simtb_makeBaseline(sP, sub);
        %Tissue Map
        imagesc([-1,1], [-1,1],Baseline); axis square; axis xy; axis off
        colormap(gray);
        axPos = get(HA(ii), 'Position');
        C = colorbar('units', 'normalized','position', [axPos(1)+axPos(3), axPos(2), .03, axPos(4)],...
            'YAxisLocation', 'right','FontSize', 7, 'YColor', [1 1 1], 'XColor', [1 1 1]);
    end
    set(get(HA(ii), 'Title'), 'Units', 'normalized', 'Position', [0.5 1], 'FontSize', 8, 'String',DATANAME{ii})
       
end


%% now display the figure
set(model_figure, 'Visible', 'on')


function CLIM = get_clim(d, dlim)
mv = max(abs(d(:)));
s = [-1, 1];
for ii = 1:length(dlim)
    if ischar(dlim{ii})
        if mv == 0
            CLIM(ii) = s(ii);
        else
            CLIM(ii) = mv*s(ii);
        end
    else
        CLIM(ii) = dlim{ii};
    end
end




