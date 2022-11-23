function param_figures = simtb_figure_params(sP, paramlistin)
% simtb_figure_params()  - Shows simulation parameters
%
% USAGE:
% >> param_figures = simtb_figure_params(sP, paramlistin)
%
% INPUTS: 
% sP             = parameter structure
% paramlistin    = cell array of parameters to display. [OPTIONAL, default = all]
%                  Accepted parameters:
%                 'SM_present',        'SM_translate_x', 
%                 'SM_translate_y',    'SM_theta'
%                 'SM_spread',         'D_baseline'
%                 'D_CNR',             'D_pSC'
%                 'D_motion_deviates', 'TC_block_amp'
%                 'TC_event_amp',      'TC_unique_amp'
%                  
% OUTPUTS:
% param_figures   = figure handles
%
% see also: simtb_main()

SELECTPARAMS = {'SM_present',        'SM_translate_x', ...
                'SM_translate_y',    'SM_theta', ...
                'SM_spread',         'D_baseline', ...
                'D_CNR',             'D_pSC', ...
                'D_motion_deviates', 'TC_block_amp', ...
                'TC_event_amp',      'TC_unique_amp'};

if nargin < 2
    paramlistin = SELECTPARAMS; % default: do all
elseif ischar(paramlistin)
    temp{1} = paramlistin; % assign single parameter
    paramlistin = temp;
end
[paramlist paramind] = check_paramlist(paramlistin, SELECTPARAMS, sP); % check params against full list
param_figures = zeros(1,length(paramlist));  % figure handles

%% Figure to display the chosen params -- this will be updated a lot later, but here is a rough idea
nC = sP.nC;               % number of components
nV = sP.nV;               % number of voxels
nT = sP.nT;               % number of time points  assume a fixed sampling rate of 1 Hz
M  = sP.M;                % number of subjects

SM_present          = sP.SM_present;      % Status for component present % 1 if component is included, 0 O.W.
SM_translate_x      = sP.SM_translate_x;  % [M x nC] matrix of offsets in x for the picked SM
SM_translate_y      = sP.SM_translate_y;  % [M x nC] matrix of offsets in y for the picked SM
SM_theta            = sP.SM_theta;        % [M x nC] matrix of rotation angles for the picked SM
SM_spread           = sP.SM_spread;       % [M x nC] matrix of spatial magnification factor ( > 1 = larger, < 1 = smaller)
D_baseline          = sP.D_baseline;
D_CNR               = sP.D_CNR;
D_pSC               = sP.D_pSC;
D_motion_deviates   = sP.D_motion_deviates;
TC_block_amp        = sP.TC_block_amp;
TC_event_amp        = sP.TC_event_amp;
TC_unique_amp       = sP.TC_unique_amp;

% Parameter description in same order as SELECTPARAMS
LABELS = {'Component Presence (1=present, 0=absent)',   'SM Offset X (pixels)', ...
          'SM Offset Y (pixels)',                       'SM Rotation (Degrees)', ...
          'SM Magnification (extent, >1 larger)',       'Subject dataset baseline', ...
          'Subject Contrast-to-Noise ratio',            'Subject percent signal change', ...
          'Motion deviates (relative to maximum motion allowed)',  'TC block amplitudes', ...
          'TC event amplitudes',                        'TC unique amplitudes'};

% DLIMS codes: m = sign*abs(min,max), l = lower, u = upper
DLIMS = {{ 0 ,  1 }, {'m', 'm'}, ...
         {'m', 'm'}, {'m', 'm'}, ...
         {'l', 'u'}, {'l', 'u'}, ...
         {'l', 'u'}, {'l', 'u'}, ...
         { 0 ,  1 }, {'m', 'm'}, ...
         {'m', 'm'}, {'m', 'm'}};

CMAP = {'gray', 'jet', ...
        'jet',  'jet', ...
        'hot',  'hot', ...
        'hot',  'hot', ...
        'hot',  'jet', ...
        'jet',  'jet'};

aspectRatio = 2.5; % width/height
%aspectRatio = 2*nC/(length(SELECTPARAMS)*M); % width/height
fscale = 0.5; % relative to screen
RECT = simtb_figdimension(aspectRatio, fscale, 'lm');

Hmargin = 0.2;
Wmargin = 0.1;
W = 1-Wmargin;
H = (1-Hmargin);
Hdelta = Hmargin/1.5; 
L = Wmargin/2;


for ii = 1:length(paramlist)  %Nrows
    % %-----------Set Graphics Figure--------------------------
    figname = [paramlist{ii}];
    param_figures(ii) = figure('units', 'pixels', 'Position', RECT, 'MenuBar', 'figure', ...
        'color', [1 1 1], 'DefaultTextColor', 'k', 'DefaultAxesColor', 'w', ...
        'DefaultAxesYColor', 'k', 'DefaultAxesZColor', 'k', 'DefaultPatchFaceColor', 'k', ...
        'DefaultPatchEdgeColor', 'k','DefaultSurfaceEdgeColor', 'k', 'DefaultLineColor', 'k', ...
        'Visible', 'off', 'Name', figname, 'resize', 'on');
    
    HA = subplot('Position', [L, Hdelta, W, H]);
    set(HA, 'FontSize', 8)
    dtemp = eval(paramlist{ii});
    if strcmpi(paramlist(ii), 'SM_theta')
        % convert to angle [-180, 180]
        dtemp = mod(dtemp+180, 2*180) - 180;
    end
    if strcmpi(paramlist(ii), 'D_baseline') || strcmpi(paramlist(ii), 'D_CNR')
        simtb_pcolor(1, 1:M, dtemp');
    elseif strcmpi(paramlist(ii), 'D_motion_deviates')
        simtb_pcolor(1:3, 1:M, dtemp);
    elseif strcmpi(paramlist(ii), 'TC_block_amp')
        simtb_pcolor(1:nC, 1:sP.TC_block_n, dtemp');
    elseif strcmpi(paramlist(ii), 'TC_event_amp')
        simtb_pcolor(1:nC, 1:sP.TC_event_n, dtemp');
    else
        simtb_pcolor(1:nC, 1:M, dtemp);
    end

    colormap(eval(CMAP{paramind(ii)}))
    CLIM = get_clim(dtemp, DLIMS{paramind(ii)});
    set(gca, 'clim', CLIM)

    if CLIM(1) == -CLIM(2)
        cbary = sort([CLIM 0]);
    else
        cbary = CLIM;
    end
    for yy = 1:length(cbary)
        cbarylabel{yy} = sprintf('%0.1f', cbary(yy));
    end
    C = colorbar('position', [9*L/8+W, Hdelta, L/4, H], 'YAxisLocation', 'right','FontSize', 7);

    % label x-axis
    if strcmpi(paramlist{ii}, 'D_motion_deviates')
        set(HA, 'XTickLabel', {'x-trans' 'y-trans' 'rotation'})
        set(get(HA, 'XLabel'),  'FontSize', 8, 'String', 'Motion deviates')
    elseif strcmpi(paramlist{ii}, 'D_CNR') || strcmpi(paramlist{ii}, 'D_baseline')
        set(HA, 'XTickLabel', '')
        set(get(HA, 'XLabel'),  'FontSize', 8, 'String', 'Dataset')
    else
        set(HA, 'XTickLabel', sP.SM_source_ID)
        set(get(HA, 'XLabel'),  'FontSize', 8, 'String', 'Source ID')
    end

    % label y-axis
    if strcmpi(paramlist{ii}, 'TC_block_amp')
        set(get(HA, 'YLabel'),  'FontSize', 8, 'String', 'TC blocks')
    elseif strcmpi(paramlist{ii}, 'TC_event_amp')
        set(get(HA, 'YLabel'),  'FontSize', 8, 'String', 'TC events')
    else
        set(get(HA, 'YLabel'),  'FontSize', 8, 'String', 'subject')
    end


    set(get(HA, 'Title'), 'Units', 'normalized', 'Position', [0.5 1], ...
            'FontSize', 8, 'String', LABELS{paramind(ii)})

    %% now display the figure
    set(param_figures(ii), 'Visible', 'on')

end


%% get bounds for plots based on specified bounds or range of data as specified in DLIMS
function CLIM = get_clim(d, dlim)
% m=sign*abs(min,max), l=lower, u=upper
mv = max(abs(d(:)));
s = [-1, 1];
for ii = 1:length(dlim)
    if ischar(dlim{ii})
        if strcmp(dlim{ii}, 'm') % sign*abs(min, max), symmetric
            if mv == 0
                CLIM(ii) = s(ii);
            else
                CLIM(ii) = mv*s(ii);
            end
        end
        if strcmp(dlim{ii}, 'l') % lower bound
            CLIM(ii) = min(d(:));
        end
        if strcmp(dlim{ii}, 'u') % upper bound
            CLIM(ii) = max(d(:));
        end
    else
        CLIM(ii) = dlim{ii}; % specified bounds
    end
end
% if the limits are the same, add 1 to upper limit (doesn't plot with all common values)
if CLIM(1) == CLIM(2);
    CLIM(2) = CLIM(2) + 1;
end

% verify that the requested paramlist entries are in the possible SELECTPARAMS
function [paramlist paramind] = check_paramlist(paramlist, SELECTPARAMS, sP)
    badlist = [];
    paramind = [];
    for ii = 1:length(paramlist)
        [TF, LOC] = ismember(upper(paramlist{ii}),upper(SELECTPARAMS));
        if ~TF
            % not a valid parameter
            W = sprintf('invalid parameter ''%s'' requested in simtb_figure_params()', paramlist{ii});
            warning(W);
            badlist = [badlist ii];
        else
            % only plot if flag indicates parameter has been set
            if     strcmpi(paramlist(ii), 'D_CNR')
                if ~sP.D_noise_FLAG
                    badlist = [badlist ii];
                else
                    paramind = [paramind LOC];  % plot this parameter
                end
            elseif strcmpi(paramlist(ii), 'D_motion_deviates')
                if ~sP.D_motion_FLAG
                    badlist = [badlist ii];
                else
                    paramind = [paramind LOC];  % plot this parameter
                end
            elseif strcmpi(paramlist(ii), 'TC_block_amp')
                if ~sP.TC_block_n
                    badlist = [badlist ii];
                else
                    paramind = [paramind LOC];  % plot this parameter
                end
            elseif strcmpi(paramlist(ii), 'TC_event_amp')
                if ~sP.TC_event_n
                    badlist = [badlist ii];
                else
                    paramind = [paramind LOC];  % plot this parameter
                end
            elseif strcmpi(paramlist(ii), 'TC_unique_amp')
                if ~sP.TC_unique_FLAG
                    badlist = [badlist ii];
                else
                    paramind = [paramind LOC];  % plot this parameter
                end
            else
                paramind = [paramind LOC];  % plot this parameter
            end
        end
    end
    
    goodind = setdiff(1:length(paramlist),badlist);
    
    % return the parameter list of matching parameters (removing bad params)
    paramlist = paramlist(goodind);
% end check_paramlist
