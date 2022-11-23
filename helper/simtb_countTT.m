function [TT_count, TT_levels] = simtb_countTT
% simtb_countTT() - Determines the number and default levels of Tissue Types  
%
% Usage:
%  >> simtb_countTT;
%  >> [TT_count, TT_levels] = simtb_countTT;
%
% INPUTS: 
%  none
%
% OUTPUTS:
%  TT_count  = number of TT defined
%  TT_levles = TT level default values 
%
% see also: simtb_SMsource()

testx = [-1 ,1];
testy = [-1 ,1];
randx = 0;
randy = 0;
randrot = 0;

% get the number of defined sources
nSM = simtb_countSM;

% initialize
allTT = zeros(1,nSM);

for c = 1:nSM
    % collect the TTs
    [SMtemp, TT] = simtb_SMsource(testx, testy, randx, randy, randrot, c);
    allTT(c) = TT;
end

% count the unique Tissue Types
TT_count = length(unique(allTT));

%-------------------------------------------------------------------------
%% edit here to change defaults for the TT_levels
% As a default, levels 1-4 are defined.
% Any additional TT_levels are set to 1.
TT_levels = ones(1,TT_count);
TT_levels(1) = 0.3; %signal dropout 
TT_levels(2) = 0.7; %WM
TT_levels(3) = 1.0; %GM
TT_levels(4) = 1.5; %CSF
%-------------------------------------------------------------------------

if nargout == 0 % print information to the command window
    fprintf('\tNumber of defined TT levels: %d\n', TT_count)
    s = sprintf('\tDefault TT levels: [%s]', num2str(TT_levels, '%0.1f, '));
    fprintf('%s%s\n',s(1:end-2),s(end))
end
