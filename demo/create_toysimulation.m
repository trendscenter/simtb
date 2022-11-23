% Elena Allen, 2/3/15 
% Code adapted from Allen et al., "Tracking whole-brain connectivity dynamics in the resting state." Cereb Cortex. 2014 24(3):663-76. 
% Dependency: SimTB toolbox (http://mialab.mrn.org/software/simtb/)
%
% Objective: create a toy simulation with time varying connectivity
% In this example we model 10 components whose connectivity structure varies through 4 discrete states.
% Variables of interest are the state vector ('STATE') and the final TCs ('TC').
% The order and duration (dwell time) of states are controlled by variables 'Sorder' and 'Sdwell'
% The amplitude of unique events (aU) relative to the shared events will  make the modular structure more or less apparent.

%%
clear all; close all; clc
rng(100) % to enable repeated generation of the same simulation


% number of components
nC = 10;

% number of time points
nT = 148;

% TR
TR = 2;

% number of different connectivity states
nStates = 4;

% probability of unique events
pU = 0.5;

% amplitude of unique events (relative to module-specific events)
aU = .5;

% probability of state specific events 
pState = .5;

%Module membership for each state
ModMem = zeros(nC,nStates);

% Number of event types (i.e., number of different modules)
nE = 3;

% Modules are formed by sharing of events.  In each state there are up to
% nE different modules. The matrix ModMem stores the membership of each
% component to a module.Note tjat module 2 in state 2 has nothing to do with 
% module 2 in the other states, it's just an index.
% Negative numbers indicate activity is negatively related to the events in
% the given module.
ModMem(1,:) = [2   -2   3    2];
ModMem(2,:) = [2   -2   3    2];
ModMem(3,:) = [2   -2   3    2];
ModMem(4,:) = [-2  3   3    2];
ModMem(5,:) = [-2  3   2    2];
ModMem(6,:) = [-2  3   2    2];
ModMem(7,:) = [-2  2   2    1];
ModMem(8,:) = [1   2    1   1];
ModMem(9,:) = [1   2    1   -2];
ModMem(10,:)= [1   2    1   -2];

% Check out the figure below -- should help make the ModMembership clear

%% Create figure of the connectivity matrix for each state
F = figure('color','w','Name', 'sim_neural_connectivity');

for ii = 1:nStates
    subplot(1,nStates,ii)
    CM = zeros(nC,nC);
    for jj = 1:nC
        for kk = 1:nC
            if ModMem(jj,ii) == ModMem(kk,ii)
                CM(jj,kk) = 1;
            elseif abs(ModMem(jj,ii)) == abs(ModMem(kk,ii))
                CM(jj,kk) = -1;
            else
                CM(jj,kk) = 0;
            end
        end
    end
    H = simtb_pcolor(1:nC, 1:nC, .8*CM);
    axis square; 
    axis ij
    set(gca, 'XTick', [], 'YTick', [], 'CLim', [-1 1])%, 'XColor', [1 1 1], 'YColor', [1 1 1])
    c = get(gca, 'Children');
    set(c(find(strcmp(get(c, 'Type'),'line'))), 'Color', 'w');
    title(sprintf('State %d', ii))
end


%% Create the event time courses

% random aspects (different for each component)
eT = rand(nT, nC) < pU;
eT = eT.*sign(rand(nT, nC)-0.5);
eT = eT*aU;

% define the order and time in each state
Sorder = [1   2  3  4   2]; % state order
Sdwell = [35 23 40  28  22];
%NOTE: the Sdwell should sum to nT, check here and amend the last partition:
if sum(Sdwell) ~= nT
    Sdwell(end) = nT - sum(Sdwell(1:end-1));
end
Cdwell = cumsum(Sdwell);
Cdwell = [0 Cdwell];
STATE = zeros(1,nT); % state vector
for ii = 1:length(Sorder)
    sIND = Cdwell(ii)+1:Cdwell(ii+1);
    % events related to each module
    e = rand(length(sIND),nE) < pState;
    e = e.*sign(rand(length(sIND), nE)-0.5);
    for cc = 1:nC
        eT(sIND,cc) = eT(sIND,cc) + sign(ModMem(cc,Sorder(ii)))*e(:,abs(ModMem(cc,Sorder(ii))));
    end
    STATE(sIND) = Sorder(ii);
end

% event time series are stored in eT
%% Convolve event TCs
[tc, MDESC, P, PDESC] = simtb_TCsource(eT(:,1), TR, 1);

P(1) = 6;     % delay of response (relative to onset)
P(2) = 15;    % delay of undershoot (relative to onset)
P(3) = 1;     % dispersion of response
P(4) = 1;     % dispersion of undershoot
P(5) = 3;     % ratio of response to undershoot
P(6) = 0;     % onset (seconds)
P(7) = 32;    % length of kernel (seconds)

TC  = zeros(nT,nC);
for cc = 1:nC
    TC(:,cc) = simtb_TCsource(eT(:,cc), TR, 1, P); % all use same HRF
    %TC(:,cc) = simtb_TCsource(eT(:,cc), TR, 1); % different HRFs
end

% Add a little gaussian noise
TC = TC + 0.1*randn(nT,nC);

%% Figure to display the states, TCs, and correlation matrices for each partition
F=figure('color','w','Name', 'sim_TCs_CorrMatrices'); 
subplot(4, length(Sorder), 1:length(Sorder))
plot((0:nT-1)*TR, STATE , 'k', 'Linewidth', 1); axis tight; box off
ylabel('State')
set(gca, 'YTick', 1:nStates, 'XTick', Cdwell*TR, 'TickDir', 'out', 'Layer', 'Bottom'); grid on

subplot(4, length(Sorder), length(Sorder)+1:length(Sorder)*2)
plot((0:nT-1)*TR, TC, 'LineWidth',0.75);
xlabel('Time (s)')
ylabel('Amplitude')
set(gca, 'TickDir', 'out', 'XTick', Cdwell*TR, 'Xgrid', 'on'); 
axis tight; box off

for ii = 1:length(Sorder)
    subplot(4,length(Sorder),length(Sorder)*3+ii)
    sIND = Cdwell(ii)+1:Cdwell(ii+1);
    temp = corr(TC(sIND,:));
    H = simtb_pcolor(1:nC, 1:nC, temp);
    axis square; axis ij 
    set(gca, 'XTick', [], 'YTick', [], 'CLim', [-1 1])%, 'XColor', [1 1 1], 'YColor', [1 1 1])
    c = get(gca, 'Children');
    set(c(find(strcmp(get(c, 'Type'),'line'))), 'Color', 'w');        
    text(1.5,-2,sprintf('Partition %d\nState %d', ii, Sorder(ii)), 'Fontsize', 8);
end