function lighter = simtb_lighten_color(rgbvalue, saturation)
%   simtb_lighten_color() - Lightens color (reduces saturation)
%                           Converts RGB to HSV, 
%                           Reduces saturation,
%                           Converts HSV back to RGB
%
%   USAGE:
%    >> lighter = simtb_lighten_color(rgbvalue, saturation);
%
%   INPUTS: (OPTIONAL)
%   rgbvalue      = rgb color to lighten
%   saturation    = desired fraction of saturation [1 = original, 0 = white]
%
%   OUTPUTS:
%   lighter       = lightened rgb color
%
%   see also: simtb_figure_pickSM(), simtb_showSMCountours()

% convert to hue saturation value
hsvvalue = rgb2hsv(rgbvalue);

% turn down saturation
hsvvalue(:,2) = hsvvalue(:,2)*saturation;

% convert back to rgb
lighter = hsv2rgb(hsvvalue);

