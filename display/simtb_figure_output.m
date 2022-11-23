function [cmTC, cmSM, comp_figure] = simtb_figure_output(sP, sub, TC, SM, plotit)
% simtb_figure_output() - Shows TC/SM output for a given subject 
%
%   Usage:
%    >> [cmTC, cmSM, comp_figure] = simtb_figure_output(sP, sub, TC, SM, plotit);
%    >> [cmTC, cmSM, comp_figure] = simtb_figure_output(sP, sub, [], [], plotit);
%    >> [cmTC, cmSM, comp_figure] = simtb_figure_output(sP, sub);
%
%   INPUTS:
%   sP            = parameter structure used in the simulations
%   sub           = subject index
%   TC            = component TCs for subject, size [nT, nC]; leave empty to load from file
%   SM            = component SMs for subject, size [nC, nV*nV]; leave empty to load from file
%   plotit        = 0|1 to create figure
%
%   OUTPUTS:
%   cmTC          = correlation matrix of TC
%   cmSM          = correlation matrix of SM
%   comp_figure   = figure handle
%
%   see also: simtb_makeTC(), simtb_TCsource()

if nargin < 3 || isempty(TC)
    % load the TC
    try
        TC = squeeze(simtb_group_getTC(sP, sub));
    catch
        disp('TC file not found.  Make sure data has been simulated.')
        return
    end
end

if nargin < 4 || isempty(SM)
    % load the SM
    try
        SM = squeeze(simtb_group_getSM(sP, sub));
    catch
        disp('SM file not found.  Make sure data has been simulated.')
        return
    end
end

if nargin < 5
    plotit = 1;
end

nT = sP.nT;
nV = sqrt(size(SM,2));
nC = sP.nC;

% First compute the temporal and spatial correlations
cmTC = corr(TC);
for ii = 1:size(cmTC,1)
    cmTC(ii,ii) = 0;
end

cmSM = corr(SM');
for ii = 1:size(cmSM,1)
    cmSM(ii,ii) = 0;
end

if plotit
    MAX_COMPS_COL = 8;
    MAX_COMPS_ROW = 9;

    if nC > MAX_COMPS_COL*MAX_COMPS_COL
        nC = MAX_COMPS_COL*MAX_COMPS_COL;
        fprintf('Displaying only first %d components\n', nC);
    end
%     % Use maximum number of rows
     Nrow = MAX_COMPS_ROW;
     Ncol = ceil(nC/Nrow);

%     % Try to make dimensions as square as possible
%     Ncol = floor(sqrt(nC));
%     Nrow = ceil(nC/Ncol);
%     %
%     if Nrow > MAX_COMPS_ROW
%         Ncol = Ncol+1;
%         Nrow = ceil(nC/Ncol);
%     end
    
    aspectratio = 1;
    scale = 0.75;
    alignment = 'rm';
    RECT = simtb_figdimension(aspectratio, scale, alignment);

    % %-----------Set Graphics Figure--------------------------
    comp_figure = figure('units', 'pixels', 'Position', RECT, 'MenuBar', 'figure', ...
        'color', [1 1 1], 'DefaultTextColor', 'k', 'DefaultAxesColor', 'w', ...
        'DefaultAxesYColor', 'k', 'DefaultAxesZColor', 'k', 'DefaultPatchFaceColor', 'k', ...
        'DefaultPatchEdgeColor', 'k','DefaultSurfaceEdgeColor', 'k', 'DefaultLineColor', 'k', ...
        'Visible', 'on', 'Name', ['subject_' simtb_returnFileIndex(sub)], 'resize', 'on');

    
    %% create a large bottom row for the correlation matrices
    DATANAME = {'cmTC', 'cmSM'};
    LABELS = {'TC Correlation', 'SM Correlation'};
    DLIMS = {{-1, 1}, {-1, 1}};
    CMAP = {'jet', 'jet'};


    Hmargin = 0.075;
    CMH = 0.23;
    cH = CMH-Hmargin; % percentage of fig dedicated to Cmatrices
    cW = cH/aspectratio;
    Wmargin = 1-cW*length(DATANAME);
    Wdelta = Wmargin/(length(DATANAME)+1);
    Hdelta = Hmargin/2;

    for ii = 1:length(DATANAME)
        HA(ii) = subplot('Position', [Wdelta*ii+cW*(ii-1), Hdelta, cW,cH]);

        dtemp = eval(DATANAME{ii});
        imagesc(1:nC,1:nC,dtemp);
        axis xy; %axis square
        colormap(eval(CMAP{ii}))
        CLIM = get_clim(dtemp, DLIMS{ii});
        set(gca, 'clim', CLIM)

        if CLIM(1) == -CLIM(2)
            cbary = sort([CLIM 0]);
        else
            cbary = CLIM;
        end
        for yy = 1:length(cbary)
            cbarylabel{yy} = sprintf('%0.1f', cbary(yy));
        end

        C(ii) = colorbar('position', [Wdelta*ii + 0.01 + cW*(ii), Hdelta, cW/10, cH], 'YAxisLocation', 'right','FontSize', 7);

        set(get(HA(ii), 'XLabel'),  'FontSize', 7, 'String', 'Component Index')
        set(get(HA(ii), 'YLabel'),  'FontSize', 7, 'String', 'Component Index')

        set(get(HA(ii), 'Title'), 'Units', 'normalized', 'Position', [0.5 1], 'FontSize', 8, 'String',LABELS{ii})
        freezeColors;
        set(C(ii), 'YTick', cbary)
        set(C(ii), 'YTickLabel', cbarylabel)
        set(C(ii), 'YAxisLocation', 'right')
        try
        cbfreeze;
        catch
        set(HA(ii), 'FontSize', 7)
        end
    end

    %% now create the subplots for all the components
    PH = 1-CMH;
  
    %left bottom width height
    bounds = [0 CMH 1 PH];
    [smPOS, tcPOS] = make_subplot_grid(Nrow,Ncol,bounds);
    thismax = max(abs(TC(:)));
    minSM = min(SM(:));
    maxSM = max(SM(:));
    for c = 1:nC
        %% TC
        HP_tc(c) = subplot('position',tcPOS{c});
        plot(1:nT, TC(:,c));
        %thismax = max(abs(TC(:,c)));  % find max for each TC 
        title(['S', num2str(sP.SM_source_ID(c)), '  (', num2str(c),')']);
        set(gca,'xtick',[1 nT]);
        if thismax > 0
            axis([1 nT -1.1*thismax 1.1*thismax])
        else
            set(gca, 'XLim', [1 nT])
        end
        set(HP_tc(c), 'FontSize', 7)
        set(get(HP_tc(c), 'title'), 'units', 'normalized', 'position', [.5,1,0], 'FontSize', 8)
        %% SM
        HP_sm(c) = subplot('position',smPOS{c});
        imagesc(reshape(SM(c,:), nV, nV), [minSM maxSM]); axis xy;
        colormap('gray');
        freezeColors;
        axis off;
        %axis image;
        set(HP_sm(c), 'FontSize', 7)
        
    end
else
    comp_figure = [];
end


function [smPOS, tcPOS] = make_subplot_grid(Nrow,Ncol,bounds)
%[left bottom width height]
Vspace = 0.02; % vertical space
Hspace = 0.05; % horizontal space
TCwide_ratio = 2.5; % TC are twice as wide as SM
H = (bounds(4)-(Nrow+1)*Vspace)/Nrow;
SMwidth = (1-Ncol*Hspace)/(Ncol*(1+TCwide_ratio));
H = min(H,SMwidth);
SMwidth = H;
%H = SMwidth;
TCwidth = SMwidth*TCwide_ratio;

% update Vspace and Hspace
Vspace = (bounds(4) - H*Nrow)/(Nrow+1);
Hspace = (bounds(3) - Ncol*(SMwidth+TCwidth))/(Ncol+1);


B = bounds(2);
L = bounds(1);

nP = Nrow*Ncol;

%[left bottom width height])
for ii = 1:nP
    thisrow = mod(ii,Nrow); if thisrow == 0, thisrow = Nrow; end
    thiscol = ceil(ii/Nrow);
    tcPOS{ii} = [L+0.9*Hspace*thiscol + (thiscol-1)*(SMwidth+TCwidth), 1-(Vspace*(thisrow)+H*(thisrow)), TCwidth, H];
    smPOS{ii} = [L+0.9*Hspace*thiscol + (thiscol-1)*(SMwidth+TCwidth)+TCwidth+0.1*Hspace, 1-(Vspace*(thisrow)+H*(thisrow)), SMwidth, H];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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