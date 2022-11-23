function count = simtb_countSM
% simtb_countSM() - Determines the number of sources defined in simtb_SMsource()
%
% Usage:
%  >> simtb_countSM;
%  >> count = simtb_countSM;
%
% OUTPUTS:
%  count = number of SM sources defined.
%
% see also: simtb_SMsource()

testx = [-1 ,1];
testy = [-1 ,1];
randx = 0;
randy = 0;
randrot = 0;

smtemp = 1;
count = 0;
while ~isempty(smtemp)
    count = count + 1;
    [smtemp] = simtb_SMsource(testx, testy, randx, randy, randrot, count);
end
count = count-1;


if nargout == 0 % print information to the command window
    fprintf('\tNumber of defined sources: %d\n', count)
end