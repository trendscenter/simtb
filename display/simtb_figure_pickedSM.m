function [CH, CMAP] = simtb_figure_pickedSM(SM_ind, H, nV, contour_level, sP, sub)
%   simtb_figure_pickedSM() - Draws and fills SM contours for selected sources
%
%   USAGE:
%    >> [CH, CMAP] = simtb_figure_pickedSM(SM_ind, H, nV, contour_level, sP, sub);
%
%   INPUTS:
%   SM_ind        = indexes of sources in SM [OPTIONAL, default = []]
%   H             = figure handle [OPTIONAL, default = gca]
%   nV            = number of voxels in SM [OPTIONAL, default = 256]
%   contour_level = which contour to draw, smaller is lower and wider [OPTIONAL, default = 0.5]
%   sP            = parameter structure used in the simulations [OPTIONAL, default = []]
%   sub           = index number for current running subject [OPTIONAL, default = []]
%
%   OUTPUTS:
%   CH            = children figure handles
%   CMAP          = colormap
%
%   see also: simtb_main(), simtb_figure_model()

if nargin < 1
    SM_ind = [];
end

if nargin < 2
    H = gca;
    nV = 256;
    contour_level = 0.5;
    sP = [];
    sub = [];
end

[CH, CMAP] = simtb_figure_drawSMs(H, nV, contour_level, sP, sub);

if (simtb_get_matlab_version > 2014 || strcmpi(version('-release'), '2014b'))
    
    for nc = 1:numel(CH)
        cmat = get(CH{nc}, 'contourMatrix');
        colorTmp = simtb_lighten_color(CMAP(nc,:), 0.7);
        while ~isempty(cmat)
            len = cmat(2, 1);
            OH(nc) = patch('faces', (1:len), 'vertices', cmat(:, 2:len+1)', 'facecolor', colorTmp, 'tag', ['patch_simtb_', num2str(nc)]);
            cmat(:, 1:len+1) = [];
        end
    end
    
else
    
    for ii = 1:length(SM_ind)
        set(CH{ii}, 'fill', 'on'); patches = get(CH{ii}, 'Children');
        set(patches, 'FaceColor', simtb_lighten_color(CMAP(ii,:), 0.7));
        OH(ii) = patches(1);
    end
    
end


%% make a legend

if ~isempty(SM_ind)
    set(H, 'units', 'normalized');
    axPos = get(H, 'Position');
    L = legend(OH, num2str(SM_ind'));
    
    % [left bottom width height]
    set(L, 'units', 'normalized', 'Position', [axPos(1)+axPos(3), axPos(2), .01, axPos(4)], 'FontSize', 7);
end
