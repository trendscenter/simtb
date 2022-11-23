   function varargout = simtb_GUI_params_output(varargin)
% SIMTB_GUI_PARAMS_OUTPUT M-file for simtb_GUI_params_output.fig
%  SIMTB_GUI_PARAMS_OUTPUT, by itself, creates a new SIMTB_GUI_PARAMS_OUTPUT or raises
%  the existing singleton*.
%
%  H = SIMTB_GUI_PARAMS_OUTPUT returns the handle to a new SIMTB_GUI_PARAMS_OUTPUT or
%  the handle to the existing singleton*.
%
%  SIMTB_GUI_PARAMS_OUTPUT('CALLBACK',hObject,eventData,handles,...) calls the
%  local function named CALLBACK in SIMTB_GUI_PARAMS_OUTPUT.M with the given input
%  arguments.
%
%  SIMTB_GUI_PARAMS_OUTPUT('Property','Value',...) creates a new SIMTB_GUI_PARAMS_OUTPUT
%  or raises the existing singleton*.
%  Starting from the left, property value pairs are applied to the GUI
%  before simtb_GUI_params_output_OpeningFcn
%  gets called.  An unrecognized property name or invalid value makes
%  property application stop.  All inputs are passed to
%  simtb_GUI_params_output_OpeningFcn via varargin.
%
%  *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%  instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simtb_GUI_params_output

% Last Modified by GUIDE v2.5 27-Nov-2010 20:10:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simtb_GUI_params_output_OpeningFcn, ...
                   'gui_OutputFcn',  @simtb_GUI_params_output_OutputFcn, ...
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


% --- Executes just before simtb_GUI_params_output is made visible.
function simtb_GUI_params_output_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simtb_GUI_params_output (see VARARGIN)

handles.fgColor = [0.6784    0.9216    1.0000];
handles.bgColor = [.5 .5 .5];

set(handles.figure1, 'Name', 'Parameter Selection: Step 1')
sP = varargin{1};
handles.sP=sP;

set(handles.text3,  'HorizontalAlignment', 'left');
set(handles.text4,  'HorizontalAlignment', 'left');
set(handles.text5,  'HorizontalAlignment', 'left');


Intro = 'Output parameters';
set(handles.text1, 'String', Intro);

set(handles.pathtext,'String', handles.sP.out_path, 'ForegroundColor', handles.fgColor)
set(handles.prefix, 'String', handles.sP.prefix, 'ForegroundColor', handles.fgColor)

if handles.sP.saveNII_FLAG
    set(handles.Savenii_yes,'BackgroundColor',handles.fgColor);
    set(handles.Savenii_no,'BackgroundColor',handles.bgColor);
else
    set(handles.Savenii_no,'BackgroundColor',handles.fgColor);
    set(handles.Savenii_yes,'BackgroundColor',handles.bgColor);
end

if handles.sP.verbose_display
    set(handles.VerboseD_yes,'BackgroundColor',handles.fgColor);
    set(handles.VerboseD_no,'BackgroundColor',handles.bgColor);
else
    set(handles.VerboseD_no,'BackgroundColor',handles.fgColor);
    set(handles.VerboseD_yes,'BackgroundColor',handles.bgColor);
end

guidata(hObject, handles);

handles.output = handles.sP;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = simtb_GUI_params_output_OutputFcn(hObject, eventdata,handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in path.
function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sP.out_path = uigetdir;
set(handles.pathtext,'String', handles.sP.out_path);
set(handles.pathtext,'Foregroundcolor', handles.fgColor);
guidata(hObject, handles);

function pathtext_Callback(hObject, eventdata, handles)
% hObject    handle to pathtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathtext as text
%        str2double(get(hObject,'String')) returns contents of pathtext as a double


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


function prefix_Callback(hObject, eventdata, handles)
% hObject    handle to prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prefix as text
%        str2double(get(hObject,'String')) returns contents of prefix as a double
handles.sP.prefix = get(hObject,'String');
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function prefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Savenii_yes.
function Savenii_yes_Callback(hObject, eventdata, handles)
% hObject    handle to Savenii_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sP.saveNII_FLAG = 1;
guidata(hObject, handles);
set(hObject,'BackgroundColor',handles.fgColor);
set(handles.Savenii_no,'BackgroundColor',handles.bgColor);

% --- Executes on button press in Savenii_no.
function Savenii_no_Callback(hObject, eventdata, handles)
% hObject    handle to Savenii_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sP.saveNII_FLAG = 0;
guidata(hObject, handles);
set(hObject,'BackgroundColor',handles.fgColor);
set(handles.Savenii_yes,'BackgroundColor',handles.bgColor);

% --- Executes on button press in VerboseD_yes.
function VerboseD_yes_Callback(hObject, eventdata, handles)
% hObject    handle to VerboseD_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sP.verbose_display = 1;
guidata(hObject, handles);
set(hObject,'BackgroundColor',handles.fgColor);
set(handles.VerboseD_no,'BackgroundColor',handles.bgColor);


% --- Executes on button press in VerboseD_no.
function VerboseD_no_Callback(hObject, eventdata, handles)
% hObject    handle to VerboseD_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sP.verbose_display = 0;
guidata(hObject, handles);
set(hObject,'BackgroundColor',handles.fgColor);
set(handles.VerboseD_yes,'BackgroundColor',handles.bgColor);


% --- Executes on button press in Back.
function Back_Callback(hObject, eventdata, handles)
% hObject    handle to Back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB 
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
simtb_GUI_main(handles.sP);


% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[errorflag, Message] = simtb_checkparams(handles.sP, '1');

if errorflag
   Title = 'Error';
   Icon = 'error';
   h = msgbox(Message,Title,Icon);
else       
  close(gcf);
  handles.sP = simtb_GUI_params_primary(handles.sP); 
end


% --- Executes on button press in help_out_path.
function help_out_path_Callback(hObject, eventdata, handles)
% hObject    handle to help_out_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('out_path');

% --- Executes on button press in help_prefix.
function help_prefix_Callback(hObject, eventdata, handles)
% hObject    handle to help_prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('prefix');

% --- Executes on button press in help_saveNII_FLAG.
function help_saveNII_FLAG_Callback(hObject, eventdata, handles)
% hObject    handle to help_saveNII_FLAG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('saveNII_FLAG');

% --- Executes on button press in help_verbose_display.
function help_verbose_display_Callback(hObject, eventdata, handles)
% hObject    handle to help_verbose_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('verbose_display');
