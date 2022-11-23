function [TC, eTC, blocks, events, uevents, sP] = simtb_makeTC(sP, sub)
% simtb_makeTC() - Makes component TCs (time courses)
%                  Builds event time course based on experimental design.
%                  Generates the TC based on the chosen model.
%                  Normalizes the TC based on the peak-to-peak difference.
%                  Adds Gaussian noise.
%  
%   Usage:
%    >> [TC, eTC] = simtb_makeTC(sP, sub);
%
%   INPUTS: 
%   sP            = parameter structure used in the simulations
%   sub           = subject index
%
%   OUTPUTS:
%   TC            = Generated time courses 
%   eTC           = Event time course (prior to modeling)
%   blocks        = Event time courses of each block
%   events        = Event time courses of each event type
%   uevents       = Event time courses for each component
%   sP            = Updated parameter structure with parameters for TC models
%
%   see also: simtb_showTC(), simtb_TCsource(), simtb_main()


seed = sP.seed;
nC = sP.nC;
nT = sP.nT;
TR = sP.TR;
TC_block_n = sP.TC_block_n;
TC_event_n = sP.TC_event_n;
TC_unique_FLAG = sP.TC_unique_FLAG;
SM_present = sP.SM_present;
TC_source_type = sP.TC_source_type;

% set the state of the RNG, specific for each subject
simtb_rand_seed(7*(2*sub+seed));

%% initialize TCs
eTC = zeros(nT,nC); % 'event' time courses

blocks  = zeros(nT, TC_block_n); %blocks
events  = zeros(nT, TC_event_n); %events
uevents = zeros(nT,nC); %unique events

%% Add blocks for each component
if TC_block_n

    TC_block_ISI =  sP.TC_block_ISI;      %inter-stimulus-intervals
    TC_block_length = sP.TC_block_length;    %length of each  block
    TC_block_amp  = sP.TC_block_amp;     %[nC x TC_block_n] matrix of task-modulation amplitudes relative to unique events
    TC_block_same_FLAG = sP.TC_block_same_FLAG;

    %% set the seed so events will all be the same between subjects
    if TC_block_same_FLAG, simtb_rand_seed(nT*seed); end; 

    %% make the Block TimeSeries
    blocks = simtb_makeTC_block(nT, TC_block_n, TC_block_length, TC_block_ISI); 
    % nT x TC_block_n matrix

    %% reset seed to be different for each subject
    simtb_rand_seed(150*(sub+seed));

    for c = 1:nC
        eTC(:,c) = sum( blocks.*(repmat(TC_block_amp(c,:), nT, 1)) , 2);
    end;
    
end;


%% for event-related design
if TC_event_n
    TC_event_n = sP.TC_event_n;          %Number of types of events
    TC_event_amp = sP.TC_event_amp;
    TC_event_prob = sP.TC_event_prob;
    TC_event_same_FLAG = sP.TC_event_same_FLAG;

    %% set the seed so events will all be the same between subjects
    if TC_event_same_FLAG, simtb_rand_seed(nC*seed); end;

    %% make the Event TimeSeries
    events = simtb_makeTC_event(nT, TC_event_n, TC_event_prob); 
    % nT x TC_event_n matrix

    %% reset seed to be different for each subject
    simtb_rand_seed(100*(sub+seed));

    for c = 1:nC
        eTC(:,c) = eTC(:,c) + sum(events.*(repmat(TC_event_amp(c,:), nT, 1)) , 2);
    end 
end

if TC_unique_FLAG
    TC_unique_prob = sP.TC_unique_prob;
    TC_unique_amp = sP.TC_unique_amp;

    for c = 1:nC
        uevents(:,c) = TC_unique_amp(sub,c)*(rand(nT,1) <  TC_unique_prob(c));
        uevents(:,c) = uevents(:,c).*sign((rand(nT,1)>(0.5))-.5);
        eTC(:,c) = eTC(:,c) + uevents(:,c);
    end
end


%% now generate the TC for each component, given the source type
TC = zeros(nT,nC);

for c = 1:nC
    if isempty(sP.TC_source_params) || isempty(sP.TC_source_params{sub,c})
        % Use the default parameters
        [TC(:,c), j, P] = simtb_TCsource(eTC(:,c), TR, TC_source_type(c));
        % update the parameter structure
        sP.TC_source_params{sub,c} = P;
    else
        % Use the user-defined parameters
        TC(:,c) = simtb_TCsource(eTC(:,c), TR, TC_source_type(c), sP.TC_source_params{sub,c});
    end
end



%% normalize the TC 
for c= 1:nC
    % remove mean and normalize by the peak-to-peak
    mdiff = max(TC(:,c)) - min(TC(:,c));
    TC(:,c) = TC(:,c) - mean(TC(:,c));
    TC(:,c) = TC(:,c)/mdiff;
    % add a bit of Gaussian noise so TC will never be flat
    TC(:,c) = SM_present(sub,c)*TC(:,c);% + 0.005*randn(nT, 1);
end

