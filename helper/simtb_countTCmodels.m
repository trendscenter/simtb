function varargout = simtb_countTCmodels
% simtb_countTCmodels() - Determines the number of TC models defined in simtb_TCsource()
%
% Usage:
%  >> simtb_countTCmodels;
%  >> [count, MDESC, NPARAMS, PDESC] = simtb_countTCmodels;
%
% INPUTS: 
%  none:   uses the model definitions in simtb_TCsource()
%
% OUTPUTS (OPTIONAL):
%  if none:   displays a description of each model and model parameters
%  if output: 
%   count  = number of TC generation models defined in simtb_TCsource()
%   MDESC  = string description of each model
%   NPARAM = number of parameters required for each model 
%   PDESC  = string description of the parameters required for each model
%
% see also: simtb_TCsource()

testeTC = round(rand(1,1));
testTR = 1;

tctemp = 1;
count = 0;
while ~isempty(tctemp)
    count = count + 1;
    [tctemp, mdesc, p, pdesc] = simtb_TCsource(testeTC, testTR, count);
    if ~isempty(tctemp)
        MDESC{count} = mdesc;
        NPARAMS(count) = length(p);
        PDESC{count} = pdesc;
    end
end
count = count-1;

if nargout
    varargout{1} = count;
    varargout{2} = MDESC;
    varargout{3} = NPARAMS;
    varargout{4} = PDESC;
else
    % display the output
    for ii = 1:count
        fprintf(' SOURCE TYPE: %d\n', ii)
        fprintf('  MODEL DESC: %s\n', MDESC{ii})
        fprintf('  PARAM DESC: [%d parameters]\n%s\n\n', NPARAMS(ii), PDESC{ii})
    end
end
