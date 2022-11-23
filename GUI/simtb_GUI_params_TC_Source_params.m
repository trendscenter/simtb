function varargout = simtb_GUI_params_TC_Source_params(varargin)
% SIMTB_GUI_PARAMS_TC_SOURCE_PARAMS M-file for simtb_GUI_params_TC_Source_params.fig
%      SIMTB_GUI_PARAMS_TC_SOURCE_PARAMS, by itself, creates a new SIMTB_GUI_PARAMS_TC_SOURCE_PARAMS or raises the existing
%      singleton*.
%
%      H = SIMTB_GUI_PARAMS_TC_SOURCE_PARAMS returns the handle to a new SIMTB_GUI_PARAMS_TC_SOURCE_PARAMS or the handle to
%      the existing singleton*.
%
%      SIMTB_GUI_PARAMS_TC_SOURCE_PARAMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMTB_GUI_PARAMS_TC_SOURCE_PARAMS.M with the given input arguments.
%
%      SIMTB_GUI_PARAMS_TC_SOURCE_PARAMS('Property','Value',...) creates a new SIMTB_GUI_PARAMS_TC_SOURCE_PARAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simtb_GUI_params_TC_Source_params_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simtb_GUI_params_TC_Source_params_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simtb_GUI_params_TC_Source_params

% Last Modified by GUIDE v2.5 15-Dec-2010 18:10:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simtb_GUI_params_TC_Source_params_OpeningFcn, ...
                   'gui_OutputFcn',  @simtb_GUI_params_TC_Source_params_OutputFcn, ...
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


% --- Executes just before simtb_GUI_params_TC_Source_params is made visible.
function simtb_GUI_params_TC_Source_params_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simtb_GUI_params_TC_Source_params (see VARARGIN)

% Choose default command line output for simtb_GUI_params_TC_Source_params
%handles.output = hObject;
handles.fgColor = [0.6784    0.9216    1.0000];
handles.bgColor = [.5 .5 .5];

set(handles.figure1, 'Name', 'Parameter Selection: Step 4b')

handles.com_same_FLAG = varargin{1};
handles.sub_same_FLAG = varargin{2};

if handles.com_same_FLAG
    set(handles.Com_yes,'BackgroundColor',handles.fgColor);
    set(handles.Com_no,'BackgroundColor',handles.bgColor);
else
    set(handles.Com_no,'BackgroundColor',handles.fgColor);
    set(handles.Com_yes,'BackgroundColor',handles.bgColor);
end

if handles.sub_same_FLAG
    set(handles.Sub_yes,'BackgroundColor',handles.fgColor);
    set(handles.Sub_no,'BackgroundColor',handles.bgColor);
else
    set(handles.Sub_no,'BackgroundColor',handles.fgColor);
    set(handles.Sub_yes,'BackgroundColor',handles.bgColor);
end


% Update handles structure
guidata(hObject, handles);
uiwait;

% --- Outputs from this function are returned to the command line.
function varargout = simtb_GUI_params_TC_Source_params_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = [handles.com_same_FLAG, handles.sub_same_FLAG];
delete(handles.figure1);

% --- Executes on button press in Com_yes.
function Com_yes_Callback(hObject, eventdata, handles)
% hObject    handle to Com_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.com_same_FLAG=1;
guidata(hObject, handles);
set(handles.Com_yes,'BackgroundColor',handles.fgColor);
set(handles.Com_no,'BackgroundColor',handles.bgColor);


% --- Executes on button press in Com_no.
function Com_no_Callback(hObject, eventdata, handles)
% hObject    handle to Com_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.com_same_FLAG=0;
guidata(hObject, handles);
set(handles.Com_no,'BackgroundColor',handles.fgColor);
set(handles.Com_yes,'BackgroundColor',handles.bgColor);
% No need to alert users since this is a reasonable default
%Message = 'For a given subject, components will have different TC model parameters.';
%h = msgbox(Message, 'Attention');


% --- Executes on button press in Sub_yes.
function Sub_yes_Callback(hObject, eventdata, handles)
% hObject    handle to Sub_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sub_same_FLAG=1;
guidata(hObject, handles);
set(handles.Sub_yes,'BackgroundColor',handles.fgColor);
set(handles.Sub_no,'BackgroundColor',handles.bgColor);

% --- Executes on button press in Sub_no.
function Sub_no_Callback(hObject, eventdata, handles)
% hObject    handle to Sub_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sub_same_FLAG=0;
guidata(hObject, handles);
set(handles.Sub_no,'BackgroundColor',handles.fgColor);
set(handles.Sub_yes,'BackgroundColor',handles.bgColor);
% No need to alert users since this is a reasonable default
% Message = 'Each subject will have different TC model parameters.';
% h = msgbox(Message, 'Attention');


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.com_same_FLAG=0;
handles.sub_same_FLAG=0;
guidata(hObject, handles);
set(handles.Com_no,'BackgroundColor',handles.fgColor);
set(handles.Com_yes,'BackgroundColor',handles.bgColor);
set(handles.Sub_no,'BackgroundColor',handles.fgColor);
set(handles.Sub_yes,'BackgroundColor',handles.bgColor);

% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume;

