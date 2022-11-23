function simtb_doc(fname)
% simtb_doc() - Opens HTML documentation for a given function
%
% Usage:
%  >> simtb_doc
%  >> simtb_doc('fname')
%
% INPUTS:
%  fname   = function name as a string [OPTIONAL, default = 'index.html']
%            function name may omit the simtb prefix, i.e., 'main' opens 'simtb_main'
% OUTPUTS:
%  none

INSTALL_DIR = fileparts(which('simtb'));
HTML_DIR = fullfile(INSTALL_DIR, 'htmldoc');

if nargin < 1
    htmlname = fullfile(HTML_DIR,  'index.html');
else
    M = load(fullfile(HTML_DIR, 'm2html.mat'));
    prefix = 'simtb_';
    if strmatch(prefix, {fname})
    else % add the prefix
        fname = [prefix fname];
    end
    
    fIND = find(strcmpi(fname, M.names));
    if isempty(fIND)
        fprintf('No HTML documentation is found for %s.\n', fname)
        return
    else
        htmlname = fullfile(HTML_DIR, M.mdirs{fIND}, [fname '.html']);
    end
end

web(htmlname)
