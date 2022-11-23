function [TC, eTC, blocks, events, uevents] = simtb_showTC(sP, comps, subs)
%   simtb_showTC() - Show generation of TCs (time courses)
%
%   Usage:
%    >> [TC, eTC, blocks, events, uevents] = simtb_showTC(sP, comps, subs);
%
%   INPUTS:
%   sP            = parameter structure used in the simulations
%   comps         = component indices
%   subs          = subject indices
%
%   OUTPUTS:
%   TC            = Generated time courses
%   eTC           = Event time course (prior to modeling)
%   blocks        = Event time courses of each block
%   events        = Event time courses of each event type
%   uevents       = Event time courses for each component
%
%   see also: simtb_makeTC(), simtb_TCsource()

if nargin < 3
    subs = 1;
end

if nargin < 2
    comps = 1;
end
nT = sP.nT;

for m = 1:length(subs)
    [TC, eTC, blocks, events, uevents] = simtb_makeTC(sP, subs(m));
    if isempty(blocks)
        blocks = zeros(nT,0);
        sP.TC_block_amp = zeros(sP.nC,0);
        dlblock = 'Experiment Blocks (none)';
    else
        dlblock = 'Experiment Blocks';
    end
    if isempty(events)
        events = zeros(nT,0);
        sP.TC_event_amp = zeros(sP.nC,0);
        dlevents = 'Experiment Events (none)';
    else
        dlevents = 'Experiment Events';
    end
    if isempty(uevents) || all(uevents(:) == 0)
        uevents = zeros(nT,sP.nC);
        sP.TC_unique_amp = zeros(sP.M, sP.nC);
        dlu = 'Unique Events (none)';
    else
        dlu = 'Unique Events';
    end


    for c = 1:length(comps)
        comp_presence = sP.SM_present(subs(m), comps(c));

        D{1} = blocks.*(repmat(sP.TC_block_amp(comps(c),:), nT, 1));
        D{2} = events.*(repmat(sP.TC_event_amp(comps(c),:), nT, 1));
        D{3} = uevents(:,comps(c))*sP.TC_unique_amp(subs(m), comps(c));
        D{4} = eTC(:,comps(c));
        D{5} = TC(:,comps(c));
        dletc = 'Time Series (sum of events)';
        dltc = ['Time Course (model ' num2str(sP.TC_source_type(c)) ')'];
        
        if comp_presence == 0
            dlblock = [dlblock '; note that component is ABSENT from subject dataset'];
            dlevents = [dlevents '; note that component is ABSENT from subject dataset'];
            dlu = [dlu '; note that component is ABSENT from subject dataset'];
            dltc = [dltc '; note that component is ABSENT from subject dataset'];
            dletc = [dletc '; note that component is ABSENT from subject dataset'];
        end

        
        DL = {dlblock, dlevents, dlu, dletc, dltc};
        ETCdisplay(D, DL, subs(m), sP.SM_source_ID(comps(c)));
    end
end


function ETCdisplay(DATA, DATANAME, sub, c)

aspectRatio = 0.9; % width/height
fscale = 0.46; % relative to screen
RECT = simtb_figdimension(aspectRatio, fscale, 'cm');


figname = ['Subject ' num2str(sub) ', Source ID ' num2str(c)];
% %-----------Set Graphics Figure--------------------------
TC_figure = figure('units', 'pixels', 'Position', RECT, 'MenuBar', 'figure', ...
    'color', [1 1 1], 'DefaultTextColor', 'k', 'DefaultAxesColor', 'w', ...
    'DefaultAxesYColor', 'k', 'DefaultAxesZColor', 'k', 'DefaultPatchFaceColor', 'k', ...
    'DefaultPatchEdgeColor', 'k','DefaultSurfaceEdgeColor', 'k', 'DefaultLineColor', 'k', ...
    'Visible', 'on', 'Name', figname, 'resize', 'on');

%%
Amax = max(abs([DATA{1}(:); DATA{2}(:); DATA{3}(:)]));

Hmargin = 0.25;
Wmargin = 0.18;
W = 1-Wmargin;
H = (1-Hmargin)/(length(DATA));
Hdelta = Hmargin/(length(DATA)+2); % allow for top buffer and bottom buffer
L = Wmargin/2;

Nrows = length(DATA);
Ncols = 1;
for ii = 1:Nrows
    HA(ii) = subplot('Position', [L, Hdelta*(ii+0.7) + H*(ii-1), W,H]);
    set(HA(ii), 'FontSize', 7)
    dtemp = DATA{length(DATA)-ii+1};


    if ii > 2 % binary/tertiary data

        if strfind(DATANAME{length(DATA)-ii+1}, 'none')
            axis off
        else
            imagesc(1:length(dtemp), 1:size(dtemp,2), dtemp')
            colormap(gray)
            axis xy
            set(gca, 'CLim', [-Amax, Amax])
            set(gca, 'YTick', 1:size(dtemp,2))
        end

    else % continuous data
        absmax = max(abs(dtemp(:)));
        plot(dtemp)
        if absmax > 0
            axis([1, length(dtemp), -1.1*absmax, 1.1*absmax]);
        else
            set(gca, 'XLim', [1, length(dtemp)])
        end
        box off
    end


    if ii == 3
        % make a large colorbar
        if Amax > 0
            C = colorbar('position', [10*L/9+W, Hdelta*(3+0.7) + H*(3-1), L/4, H*3+Hdelta*2], 'YAxisLocation', 'right','FontSize', 7);
            ytick = linspace(-Amax, Amax, 5);
            set(C, 'YTick', ytick);
            set(get(C, 'YLabel'), 'FontSize', 10, 'String', 'amplitude (arbitrary)', 'Units', 'normalized', 'Position', [2,.5])
        end
    end

    if ii == 1
        set(get(HA(ii), 'XLabel'),  'FontSize', 10, 'String', 'Time (TR)')
        set(get(HA(ii), 'YLabel'),  'FontSize', 10, 'String', 'amplitude (arbitrary)')
    end
    set(get(HA(ii), 'Title'), 'Units', 'normalized', 'Position', [0.5 1], 'FontSize', 10, 'String',DATANAME{length(DATA)-ii+1})
    
    if ii > 1
        set(HA(ii), 'XTickLabel', '')
    end
    % Make a title for the figure
    if ii == Nrows
        set(HA(ii), 'Units', 'normalized')
        text(-0.09, 1.16, figname, 'Units', 'normalized','FontSize', 12);
    end
end

%% now display the figure
set(TC_figure, 'Visible', 'on')