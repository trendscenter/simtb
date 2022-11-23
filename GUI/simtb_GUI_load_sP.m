   function varargout = simtb_GUI_load_sP(varargin)
% SIMTB_GUI_LOAD_SP M-file for simtb_GUI_load_sP.fig
%  SIMTB_GUI_LOAD_SP, by itself, creates a new SIMTB_GUI_LOAD_SP or raises
%  the existing singleton*.
%
%  H = SIMTB_GUI_LOAD_SP returns the handle to a new SIMTB_GUI_LOAD_SP or
%  the handle to the existing singleton*.
%
%  SIMTB_GUI_LOAD_SP('CALLBACK',hObject,eventData,handles,...) calls the
%  local function named CALLBACK in SIMTB_GUI_LOAD_SP.M with the given input
%  arguments.
%
%  SIMTB_GUI_LOAD_SP('Property','Value',...) creates a new SIMTB_GUI_LOAD_SP
%  or raises the existing singleton*.
%  Starting from the left, property value pairs are applied to the GUI
%  before simtb_GUI_load_sP_OpeningFcn
%  gets called.  An unrecognized property name or invalid value makes
%  property application stop.  All inputs are passed to
%  simtb_GUI_load_sP_OpeningFcn via varargin.
%
%  *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%  instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simtb_GUI_load_sP

% Last Modified by GUIDE v2.5 20-Jan-2011 17:12:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simtb_GUI_load_sP_OpeningFcn, ...
                   'gui_OutputFcn',  @simtb_GUI_load_sP_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before simtb_GUI_load_sP is made visible.
function simtb_GUI_load_sP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simtb_GUI_load_sP (see VARARGIN)

handles.fgColor = [0.6784    0.9216    1.0000];
handles.bgColor = [.5 .5 .5];

handles.output = '';  

% Update handles structure
guidata(hObject, handles);
uiwait;

% --- Outputs from this function are returned to the command line.
function varargout = simtb_GUI_load_sP_OutputFcn(hObject, eventdata,handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
close(gcf)


% --- Executes on button press in path.
function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.mat');
if filename == 0 % user hit 'Cancel'
    handles.output = ''; 
    filename = '';
else
    handles.output = fullfile(pathname, filename);
end
set(handles.pathtext,'String', filename);
set(handles.pathtext,'Foregroundcolor', handles.fgColor);
guidata(hObject, handles);


% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = '';  %%111 represent back without anything
guidata(hObject, handles);
uiresume;


% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);
uiresume;

% --- Executes during object creation, after setting all properties.
function pathtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Next_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





