function simtb_saveMOT(mp, filename)
%   simtb_saveMOT()  - Writes motion parameters to file
%                   
%   Usage:
%    >> simtb_saveMOT(mp, filename)
%
%   INPUTS:
%   mp                = motion parameters (nT x 3)
%   filename          = filename to write data to
%   
%   OUTPUTS:
%   none
%
%   see also: simtb_main(), simtb_addMotion(), simtb_makeMotParams()

fid = fopen(filename,'w');
fprintf(fid, '%2.4f\t\t%2.4f\t\t%2.4f\n', mp');
fclose(fid);


