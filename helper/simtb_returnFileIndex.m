function fileIndex = simtb_returnFileIndex(subIndex)
%   simtb_returnFileIndex()  - Returns the file index for naming
%  
%   Usage:
%    >> [fileIndex] = simtb_returnFileIndex(subIndex)
%
%   INPUTS: 
%   subIndex   = subject index in [1, 999]
%
%   OUTPUTS:
%   fileIndex  = formatted subject index as 3-character string
%

% check index
if subIndex < 10
    fileIndex = ['00', num2str(subIndex)];
elseif subIndex < 100
    fileIndex = ['0', num2str(subIndex)];
else
    fileIndex = num2str(subIndex);
end