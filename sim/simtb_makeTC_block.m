function blocks = simtb_makeTC_block(nT, TC_block_n, TC_block_length, TC_block_ISI)
% simtb_makeTC_block()  -  Builds task blocks 
%
% Usage:
%  >> blocks = simtb_makeTC_block(nT, TC_block_n, TC_block_length,TC_block_ISI)
%
% INPUTS:
% nT                = number of time points
% TC_block_n        = FLAGS (1 for yes, 0 for no) for making TCs with block events
% TC_block_length   = length of each  block
% TC_block_ISI      = inter-stimulus-intervals
%
% OUTPUTS:
% blocks =  nT x TC_block_n matrix of TC blocks
%
% see also: simtb_makeTC()

period = TC_block_length+TC_block_ISI; 
ncycle = ceil(nT/period); % the number of cycles that can occur
stimon = repmat(TC_block_ISI+1:(TC_block_ISI+1+TC_block_length), ncycle, 1);

%% set up pseudorandom order, but make sure that the block types are fairly evently distributed
%initalize event order
eventorder = repmat([1:TC_block_n], 1, ceil(ncycle/TC_block_n));
%randomize
eventorder = eventorder(randperm(length(eventorder)));
%truncate
eventorder = eventorder(1:ncycle);

blocks = zeros(nT, TC_block_n);

for tt = 1:ncycle
    % pick which block type
    block_ind = eventorder(tt);
    
    % advance the stimulus onset
    stim_ind = stimon + (tt-1)*period;
    
    % check the last condition to update indicies
    if tt == ncycle && stim_ind(end)> nT
        stim_ind = stim_ind(1):nT;
    end    
    
    blocks(stim_ind,block_ind) = 1;
end