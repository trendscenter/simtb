function simtb_movie(D, sP, avi, filename, sub)
%   simtb_movie()  - Displays a movie of a subject dataset at 10 frames a second
%   Usage:
%    >> simtb_movie(D, sP);
%
%   INPUTS: 
%   D             = subject dataset from [prefix]_subject_[num]_DATA.mat
%   sP            = parameter structure used in the simulations
%   avi           = [OPTIONAL] 1/0 whether to produce an .avi movie file
%   filename      = [OPTIONAL] filename (without extension, automatically appends '.avi')
%   sub           = [OPTIONAL] subject number associated with D, [] for blank
%
%   OUTPUTS:
%   none
%
%   see also: 

if nargin < 3 | ~ismember(avi,[0,1])
    avi = 0; % no movie file by default
end
if ~exist('avifile','file')
    avi = 0; % if your system doesn't have avifile, don't make a movie
end
if nargin < 5
    sub = [];
end
if isempty(filename)
    filename = 'movie';
end

% reshape data if necessary
if ndims(D) == 2
    nV = sqrt(size(D,2));
    A = reshape(D, sP.nT, nV, nV);
else
    A = D;
end

% create movie file
if avi 
    % helpful: http://www.mathworks.com/support/tech-notes/1200/1204.html
    aviobj = avifile(filename, 'Fps', 8, 'Quality', 100, ... % 8 frames per second
        'VideoName', ['simtb_' filename], ...  % filename (with .avi automatically appended)
        'Compression', 'None'); % Unix likes None
    if ispc
        aviobj.Compression = 'Cinepak'; % Windows likes Cinepak (about 4% of None)
    end
end

% create figure, show movie, and write avi file if requested
h = figure;
voxelsize = 2; % two pixels on screen for each voxel
pp=get(h,'Position');
set(h,'Position',[pp(1),pp(2),voxelsize*sP.DnV,voxelsize*sP.DnV]); % size the figure window
set(gca,'Position',[0 0 1 1]); % make image full size
amax = max(A(:));
for ii = 1:size(A,1)
    imagesc(squeeze(A(ii,:,:)), [0 amax]); axis xy; axis square; axis off;pp=get(h,'Position');
    %title(num2str(ii));
    tt = text(0.03*sP.DnV, 0.98*sP.DnV, ['TR ' num2str(ii)]); set(tt,'Color',[1 1 1]);
    tt = text(0.85*sP.DnV, 0.98*sP.DnV, [num2str(ii*sP.TR) 's']); set(tt,'Color',[1 1 1]);
    tt = text(0.03*sP.DnV, 0.03*sP.DnV, [sP.prefix]); set(tt,'Color',[1 1 1]);
    if ~isempty(sub)
        tt = text(0.85*sP.DnV, 0.03*sP.DnV, ['sub ' num2str(sub)]); set(tt,'Color',[1 1 1]);
    end
    if avi 
        F = getframe(h);
        aviobj = addframe(aviobj,F);
    else
        pause(.1);
    end
end

% close movie file
if avi 
    aviobj = close(aviobj);
%     aviinfo(filename);
end
