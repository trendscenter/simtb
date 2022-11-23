function simtb(varargin)
%   simtb()  - Initializes the simtb GUI
%
%   Usage:
%    >> simtb
%    >> simtb('param_filename');
%    >> simtb(sP);
%
%   INPUTS: (OPTIONAL)
%   If no input:        Opens GUI for interactive use of the simulation toolbox.
%   If string input:    Builds paramter structure based on  definitions in 'param_filename'
%                       opens the GUI to edit/run the simulation.
%                       Note that 'param_filename' must be on the user's path.
%   If structure input: Opens the GUI with the given parameter structure.
%
%   OUTPUTS:
%   (none)
%
%   see also: simtb_create_sP(), simtb_main()

%  check to make sure that simtb toolbox is on the path

p = which('simtb_create_sP');
if isempty(p)
    INSTALL_DIR = fileparts(which('simtb'));
    addpath(genpath(INSTALL_DIR));
end

if nargin && ischar(varargin{1})
    % create the structure from the given parameter file name
    [sP] = simtb_create_sP(varargin{1});
    %simtb_main(sP)
    simtb_GUI_main(sP);

elseif nargin && isstruct(varargin{1})
    % execute the simulations given the input structure
    simtb_GUI_main(varargin{1});

else
    % Open the GUI
    simtb_GUI_main;
end
