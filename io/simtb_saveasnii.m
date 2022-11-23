function simtb_saveasnii(D, filename)
% simtb_saveasnii()  - Save data matrix as an .nii file
%
% Usage:
%  >> simtb_saveasnii(D, filename);
%
% INPUTS:
% D         = four dimensional data: [x,y,z,t]
% filename  = the full name (with path) to save nifti file
%
% OUTPUTS:
% none
% see also: simtb_main()

%% reference mat from EPI template:

mat = [    -2     0     0    92; ...
            0     2     0  -128; ...
            0     0     2   -74; ...
            0     0     0     1]; 

%% Build volume info
V = struct('fname',  filename,...
    'dim',    [size(D, 1), size(D, 2),size(D, 3)],...
    'dt',     [spm_type('int16'), spm_platform('bigend')],...
    'mat',    mat,...
    'pinfo',  [1 0 0]',...
    'descrip','spm:');
  
%% find limits of data
mx   = -Inf;
mn   = Inf;
for i=1:size(D, 4)    
    dat      = squeeze(D(:, :, :, i));
    dat      = dat(isfinite(dat));
    mx       = max(mx,max(dat(:)));
    mn       = min(mn,min(dat(:)));
end;

sf         = max(mx,-mn)/32767;
ni         = nifti;
ni.dat     = file_array(filename, [V.dim(1:3), size(D, 4)], 'INT16-BE',0,sf,0);
ni.mat     = V.mat; 
ni.mat0    = V.mat;
ni.descrip = V.descrip;
%disp(['Writing 4D .NII file: ', filename]);
create(ni);

for i=1:size(ni.dat,4),
    ni.dat(:,:,:,i) = D(:, :, :, i); 
    spm_get_space([ni.dat.fname ',' num2str(i)], V.mat);
end;

%disp('Done writing 4D file');