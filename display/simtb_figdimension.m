function RECT = simtb_figdimension(aspectratio, scale, alignment)
%   simtb_figdimension() - Computes position of figure given desired aspect ratio and scale
%
%   Usage:
%    >> RECT = simtb_figdimension(aspectratio, scale, alignment);
%
%   INPUTS: (OPTIONAL)
%   aspectratio   = aspect ratio is width/height of the desired figure
%   scale         = multiplicative scale, 1 leaves the same size
%   alignment     = horizontal placement, vertical placement
%                       'cm' = center middle
%                       'lt' = left top
%                       'rb' = left bottom
%
%   OUTPUTS:
%   RECT          = figure position used as figure('Position', RECT)
%
%   see also: simtb_figure_params(), simtb_showSM()


if nargin < 3
    scale = 1;
    alignment = 'cm';
end

Ssize = get(0,'ScreenSize');
Ssize = Ssize-1;
% SSIZE is [1 1 W H] in pixels

% screen aspect ratio
Sar = Ssize(3)/Ssize(4);

if Sar < aspectratio
    % screen is skinny, width is limiting factor
    fW = Ssize(3);
    fH = fW/aspectratio;
else
    % screen is wide, height is limiting factor
    fH = Ssize(4);
    fW = aspectratio*fH;
end

RECT = [0 0 fW fH];
% now scale the figure
RECT  = scale*RECT;

% [left bottom width height]
% and translate 
switch lower(alignment(1))
    case {'c'} 
        % center
        RECT(1) = Ssize(3)/2 - RECT(3)/2;
    case {'l'}
        RECT(1) = RECT(3)/8;
        % left
    case {'r'}
        RECT(1) = Ssize(3) - RECT(3)*9/8;
        % right
end


switch lower(alignment(2))
    case {'t'} 
        % top
        RECT(2) = Ssize(4) - RECT(4)*9/8;
    case {'m'}
        % middle
        RECT(2) = Ssize(4)/2 - RECT(4)/2;
    case {'b'}
        % bottom
         RECT(2) = RECT(4)/8;

end
