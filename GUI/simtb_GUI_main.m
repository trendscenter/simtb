function varargout = simtb_GUI_main(varargin)
%SIMTB_GUI_MAIN M-file for simtb_GUI_main.fig
%      SIMTB_GUI_MAIN, by itself, creates a new SIMTB_GUI_MAIN or raises the existing
%      singleton*.
%
%      H = SIMTB_GUI_MAIN returns the handle to a new SIMTB_GUI_MAIN or the handle to
%      the existing singleton*.
%
%      SIMTB_GUI_MAIN('Property','Value',...) creates a new SIMTB_GUI_MAIN using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to simtb_GUI_main_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.   
%
%      SIMTB_GUI_MAIN('CALLBACK') and SIMTB_GUI_MAIN('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SIMTB_GUI_MAIN.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simtb_GUI_main

% Last Modified by GUIDE v2.5 14-Dec-2010 16:10:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simtb_GUI_main_OpeningFcn, ...
                   'gui_OutputFcn',  @simtb_GUI_main_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before simtb_GUI_main is made visible.
function simtb_GUI_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simtb_GUI_main (see VARARGIN)

handles.fgColor = [0.6784    0.9216    1.0000];
handles.bgColor = [.5 .5 .5];

%set(handles.figure1, 'Name', 'simtb')

if nargin > 3
    sP = varargin{1};
    handles.sP=sP;
    handles.sP
else
     handles.sP = simtb_create_sP();
     handles.sP.out_path = pwd;
end

% Choose default command line output for simtb_GUI_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = simtb_GUI_main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Parameter_setup.
function Parameter_setup_Callback(hObject, eventdata, handles)
% hObject    handle to Parameter_setup (see GCBO)% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.sP = simtb_GUI_params_output(handles.sP); 
guidata(hObject, handles);


% --- Executes on button press in SimulateData.
function SimulateData_Callback(hObject, eventdata, handles)
% hObject    handle to SimulateData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = simtb_GUI_load_sP;
if ~isempty(filename)
    % elseif filename == 0   %%No file selected
    %        Title ='';
    %        Icon ='error';
    %        Message = 'Please select the data file path';
    %        msgbox(Message,Title,Icon);
    %    else
    try
        A = load(filename);       
    catch exception
        rep = getReport(exception);
        Title ='Loading Error';
        Icon ='error';
        msgbox(rep,Title,Icon);
    end

    if isfield(A, 'sP')
        simtb_main(A.sP);
    else
        Title ='File Error';
        Icon ='error';
        msgbox('File does not contain parameter structure (''sP''). Please choose another file.',Title,Icon)
    end
end


% --- Executes on button press in display.
function display_Callback(hObject, eventdata, handles)
% hObject    handle to display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% load(simtb_makefilename(handles.sP, 'DATA', 1), 'D');
% simtb_movie(D, handles.sP);
filename = simtb_GUI_load_sP;

% --- Executes on button press in exit.
function about_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  Title = 'simtb';
  Icon = 'custom';
  Message = ['Simtb is created by the Medical Image Analysis Lab at the Mind Research Network and the University of New Mexico.'...
            ' The purpose of simtb is to facilitate evaluation and comparisons of tools developed for the analysis of fMRI data.'...
            ' Please send comments and bug reports to vcalhoun@mrn.org or eallen@mrn.org.'];
  IM = imread('simtb_icon.jpg');
  msgbox(Message,Title,Icon, IM);           
 

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
