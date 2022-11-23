function motion_figure = simtb_show_motion(sP, subs)
% simtb_show_motion() - Shows translational/rotational motion of subjects
%
%   Usage:
%    >> simtb_show_motion(sP, subs);
%
%   INPUTS:
%   sP            = parameter structure used in the simulations
%   subs          = subject indices
%
%   OUTPUTS:
%   none
%
%   see also: simtb_showTC(), simtb_figure_params()

if nargin < 2
    subs = 1; % just first subject if none are specified
end

nV = sP.nV;
nT = sP.nT;

for m = 1:length(subs)
    sub = subs(m);                                  % current subject
    fn = [sP.prefix '_subject_' sprintf('%03d',sub) '_MOT.txt'];  % filename
    fn_motion = fullfile(sP.out_path, fn);          % path/file
    motion = load(fn_motion);                  
%    motion = reshape(motion_temp',nT,3);            % motion in each column

    t = repmat([1:nT]',1,3);                        % time columns
    D = struct('t', t, 'motion', motion, 'nV', nV, 'nT', nT); % data to plot in D
    motion_figure = ETCdisplay(D, sub);             % plot data
end


function motion_figure = ETCdisplay(D, sub)

    aspectRatio = 2.5; % width/height
    fscale = 0.5; % relative to screen
    RECT = simtb_figdimension(aspectRatio, fscale, 'cm');

    figname = ['motion' sprintf('%03d',sub)];
    % %-----------Set Graphics Figure--------------------------
    motion_figure = figure('units', 'pixels', 'Position', RECT, 'MenuBar', 'figure', ...
        'color', [1 1 1], 'DefaultTextColor', 'k', 'DefaultAxesColor', 'w', ...
        'DefaultAxesYColor', 'k', 'DefaultAxesZColor', 'k', 'DefaultPatchFaceColor', 'k', ...
        'DefaultPatchEdgeColor', 'k','DefaultSurfaceEdgeColor', 'k', 'DefaultLineColor', 'k', ...
        'Visible', 'on', 'Name', figname, 'resize', 'on');

    %%
    % % zero reference line
    zref = plot([1 D.nT], [0, 0], 'k-'); % horizontal line at zero
    set(zref,'Color',repmat(.8,1, 3)); % gray
    hold on;
    % plot with two vertical axes, translation on left, rotation on right
    [ax, h1, h2] = plotyy(D.t(:,[1,2]), D.nV*D.motion(:,[1 2]), D.t(:,3), D.motion(:,3));
    % axes symmetric about zero
    y1max = max(abs(get(ax(1),'Ylim'))); 
    y2max = max(abs(get(ax(2),'Ylim'))); 
    % axis(ax(1), [0 D.t(end,1) -y1max y1max]);
    % axis(ax(2), [0 D.t(end,1) -y2max y2max]);
    set(ax(1),'Ylim', [-y1max y1max]);
    set(ax(2),'Ylim', [-y2max y2max]);
    % plot formatting
    title(['Motion Subject ' sprintf('%d',sub)]);
    xlabel('TR')
    ylabel(ax(1), 'translation (voxels)'); %, 'FontSize', 8); % left axis
    ylabel(ax(2), 'rotation (degrees)'  ); %, 'FontSize', 8); % right axis
    set(h1(1),'LineStyle','-' )
    set(h1(2),'LineStyle','--')
    set(h2,'LineStyle',':'    )

    %legend('rotation', 'x-translation', 'y-translation', 'Location', 'NorthWest');
    legend(h1, 'x-translation', 'y-translation', 'Location', 'NorthWest');
    legend(h2, 'rotation', 'Location', 'NorthEast');

    %% now display the figure
    set(motion_figure, 'Visible', 'on')
% end
