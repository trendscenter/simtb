function events = simtb_makeTC_event(nT, TC_event_n, TC_event_prob)
% simtb_makeTC_event()  -  Builds event time courses 
%
% Usage:
%  >> events = simtb_makeTC_event(nT, TC_event_n, TC_event_prob)
%
% INPUTS:
% nT              = number of time points
% TC_event_n      = Number of types of events
% TC_event_prob   = [1 x TC_event_n]  vector of probabilities that event occurs at each TR
%
% OUTPUTS:
% events =  nT x TC_event_n matrix of TC events
%
% see also: simtb_makeTC()

events = zeros(nT, TC_event_n);

% set the probability limits for each event type
PLIM = zeros(2,TC_event_n);
plow = 0;
for e = 1:TC_event_n
    PLIM(1,e) = plow;
    PLIM(2,e) = plow+TC_event_prob(e);
    plow = plow+TC_event_prob(e);
end

% draw random numbers
R = rand(nT,1);

for e = 1:TC_event_n
    % Events appear when the random number is within the limits
    events(:,e) = (R(:) >= PLIM(1,e)).*(R(:) < PLIM(2,e));
end
