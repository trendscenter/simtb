function varargout = simtb_GUI_params_primary(varargin)
% SIMTB_GUI_PARAMS_PRIMARY M-file for simtb_GUI_params_primary.fig
%      SIMTB_GUI_PARAMS_PRIMARY, by itself, creates a new SIMTB_GUI_PARAMS_PRIMARY or raises the existing
%      singleton*.
%
%      H = SIMTB_GUI_PARAMS_PRIMARY returns the handle to a new SIMTB_GUI_PARAMS_PRIMARY or the handle to
%      the existing singleton*.
%
%      SIMTB_GUI_PARAMS_PRIMARY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMTB_GUI_PARAMS_PRIMARY.M with the given input arguments.
%
%      SIMTB_GUI_PARAMS_PRIMARY('Property','Value',...) creates a new SIMTB_GUI_PARAMS_PRIMARY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simtb_GUI_params_primary_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simtb_GUI_params_primary_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simtb_GUI_params_primary

% Last Modified by GUIDE v2.5 28-Nov-2010 19:21:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simtb_GUI_params_primary_OpeningFcn, ...
                   'gui_OutputFcn',  @simtb_GUI_params_primary_OutputFcn, ...
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


% --- Executes just before simtb_GUI_params_primary is made visible.
function simtb_GUI_params_primary_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simtb_GUI_params_primary (see VARARGIN)
handles.fgColor = [0.6784    0.9216    1.0000];
handles.bgColor = [.5 .5 .5];

set(handles.figure1, 'Name', 'Parameter Selection: Step 2')
sP = varargin{1};
handles.sP=sP;

Intro = 'Parameters specifying simulation dimensions';
set(handles.text0, 'String', Intro);

set(handles.text1,  'HorizontalAlignment', 'left');
set(handles.text2,  'HorizontalAlignment', 'left');
set(handles.text3,  'HorizontalAlignment', 'left');
set(handles.text4,  'HorizontalAlignment', 'left');
set(handles.text5,  'HorizontalAlignment', 'left');

set(handles.edit_M, 'String', num2str(handles.sP.M))
set(handles.edit_nC, 'String', num2str(handles.sP.nC))
set(handles.edit_nT, 'String', num2str(handles.sP.nT))
set(handles.edit_nV, 'String', num2str(handles.sP.nV))
set(handles.edit_TR, 'String', num2str(handles.sP.TR))


set(handles.text1, 'String', simtb_GUI_format_paramlabel('M'), 'HorizontalAlignment', 'left');
set(handles.text2, 'String', simtb_GUI_format_paramlabel('nC'), 'HorizontalAlignment', 'left');
set(handles.text3, 'String', simtb_GUI_format_paramlabel('nV'), 'HorizontalAlignment', 'left');
set(handles.text4, 'String', simtb_GUI_format_paramlabel('nT'), 'HorizontalAlignment', 'left');
set(handles.text5, 'String', simtb_GUI_format_paramlabel('TR'), 'HorizontalAlignment', 'left');

guidata(hObject, handles);
handles.output = handles.sP;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes simtb_GUI_params_primary wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simtb_GUI_params_primary_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit_M_Callback(hObject, eventdata, handles)
% hObject    handle to edit_M (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_M as text
%        str2double(get(hObject,'String')) returns contents of edit_M as a double
handles.sP.M = str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_M_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_M (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in help_M.
function help_M_Callback(hObject, eventdata, handles)
% hObject    handle to help_M (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('M');

function edit_nC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nC as text
%        str2double(get(hObject,'String')) returns contents of edit_nC as a double
handles.sP.nC = str2num(get(hObject,'String'));
handles.sP.SM_source_ID = 1:handles.sP.nC;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_nC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in help_nC.
function help_nC_Callback(hObject, eventdata, handles)
% hObject    handle to help_nC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('nC');


function edit_nV_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nV as text
%        str2double(get(hObject,'String')) returns contents of edit_nV as a double
handles.sP.nV = str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_nV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in help_nV.
function help_nV_Callback(hObject, eventdata, handles)
% hObject    handle to help_nV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('nV');


function edit_nT_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nT as text
%        str2double(get(hObject,'String')) returns contents of edit_nT as a double
handles.sP.nT = str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_nT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in help_nT.
function help_nT_Callback(hObject, eventdata, handles)
% hObject    handle to help_nT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('nT');


function edit_TR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TR as text
%        str2double(get(hObject,'String')) returns contents of edit_TR as a double
handles.sP.TR = str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_TR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in help_TR.
function help_TR_Callback(hObject, eventdata, handles)
% hObject    handle to help_TR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('TR');

% --- Executes on button press in Back.
function Back_Callback(hObject, eventdata, handles)
% hObject    handle to Back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
simtb_GUI_params_output(handles.sP);


% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)

% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[errorflag, Message] = simtb_checkparams(handles.sP, '2');
if errorflag  
   Title = 'Error';
   Icon = 'error';
   h = msgbox(Message,Title,Icon);
else
   close(gcf);
   handles.sP = simtb_GUI_params_SMs(handles.sP); 
 
end
