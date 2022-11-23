function varargout = simtb_GUI_params_TC_Event(varargin)
% SIMTB_GUI_PARAMS_TC_EVENT M-file for simtb_GUI_params_TC_Event.fig
%      SIMTB_GUI_PARAMS_TC_EVENT, by itself, creates SM_present new SIMTB_GUI_PARAMS_TC_EVENT or raises the existing
%      singleton*.
%
%      H = SIMTB_GUI_PARAMS_TC_EVENT returns the handle to SM_present new SIMTB_GUI_PARAMS_TC_EVENT or the handle to
%      the existing singleton*.
%
%      SIMTB_GUI_PARAMS_TC_EVENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMTB_GUI_PARAMS_TC_EVENT.M with the given input arguments.
%
%      SIMTB_GUI_PARAMS_TC_EVENT('Property','Value',...) creates SM_present new SIMTB_GUI_PARAMS_TC_EVENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simtb_GUI_params_TC_Event_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simtb_GUI_params_TC_Event_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simtb_GUI_params_TC_Event

% Last Modified by GUIDE v2.5 27-Nov-2010 20:27:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simtb_GUI_params_TC_Event_OpeningFcn, ...
                   'gui_OutputFcn',  @simtb_GUI_params_TC_Event_OutputFcn, ...
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


% --- Executes just before simtb_GUI_params_TC_Event is made visible.
function simtb_GUI_params_TC_Event_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in SM_present future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simtb_GUI_params_TC_Event (see VARARGIN)
handles.fgColor = [0.6784    0.9216    1.0000];
handles.bgColor = [.5 .5 .5];

set(handles.figure1, 'Name', 'Parameter Selection: Step 4d')
set(handles.text1, 'String', simtb_GUI_format_paramlabel('TC_event_same_FLAG'), 'HorizontalAlignment', 'left');
set(handles.text2, 'String', simtb_GUI_format_paramlabel('TC_event_prob'), 'HorizontalAlignment', 'left');
set(handles.text3, 'String', simtb_GUI_format_paramlabel('TC_event_amp'), 'HorizontalAlignment', 'left');

sP = varargin{1};
handles.sP=sP;

if handles.sP.TC_event_same_FLAG 
    set(handles.TC_event_same_FLAG_yes,'BackgroundColor',handles.fgColor);
    set(handles.TC_event_same_FLAG_no,'BackgroundColor',handles.bgColor);
else
    set(handles.TC_event_same_FLAG_no,'BackgroundColor',handles.fgColor);
    set(handles.TC_event_same_FLAG_yes,'BackgroundColor',handles.bgColor);
end


guidata(hObject, handles);
handles.output = handles.sP;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simtb_GUI_params_TC_Event wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simtb_GUI_params_TC_Event_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in SM_present future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in TC_event_same_FLAG_yes.
function TC_event_same_FLAG_yes_Callback(hObject, eventdata, handles)
% hObject    handle to TC_event_same_FLAG_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sP.TC_event_same_FLAG = 1;
guidata(hObject, handles);
set(hObject,'BackgroundColor',handles.fgColor);
set(handles.TC_event_same_FLAG_no,'BackgroundColor',handles.bgColor);


% --- Executes on button press in TC_event_same_FLAG_no.
function TC_event_same_FLAG_no_Callback(hObject, eventdata, handles)
% hObject    handle to TC_event_same_FLAG_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sP.TC_event_same_FLAG = 0;
guidata(hObject, handles);
set(hObject,'BackgroundColor',handles.fgColor);
set(handles.TC_event_same_FLAG_yes,'BackgroundColor',handles.bgColor);



function TC_event_prob_Callback(hObject, eventdata, handles)
% hObject    handle to TC_event_prob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TC_event_prob as text
%        str2double(get(hObject,'String')) returns contents of TC_event_prob as a double
xlabel = 'Event Trial Type';     %xlabel = 'TC_event type number';
ylabel = '';
cnames={};
rnames={};

[m,n] = size(handles.sP.TC_event_prob);
default = handles.sP.TC_event_prob;  
mxsize.row=1;
mxsize.col=handles.sP.TC_event_n;

if m~=mxsize.row || n~=mxsize.col
   m=mxsize.row;
   n=mxsize.col;
   default = zeros(m,n);
end

for i= 1:m
%   rnames{i} = num2str(i);
  rnames{i} = sprintf('      %3d',i);  % 9 character column
end

for i= 1:n
%   cnames{i} = strcat(num2str(i));
  cnames{i} = sprintf('      %3d',i);  % 9 character column
end

instruction = 'Fill in the probability that an event occurs at each TR for each event type. To get started, use the drop-down menu at left and select a method to initialize values.  Then, update the values by hand.  When you are satisfied, hit "Done". ';
panelname = 'Parameter Selection: Step 4d1';
paneltitle = 'TC event probability';
handles.sP.TC_event_prob = simtb_GUI_matrix_gen(2, xlabel, ylabel, cnames, rnames,instruction, default, panelname, paneltitle, 'TC_event_prob');
guidata(hObject, handles); 
set(hObject,'BackgroundColor',handles.fgColor);

% --- Executes on button press in TC_event_amp.
function TC_event_amp_Callback(hObject, eventdata, handles)
% hObject    handle to TC_event_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xlabel = 'Event Trial Type';     %xlabel = 'TC_block type number';
ylabel = 'Source ID (Component Index)';
cnames={};
rnames={};

[m,n] = size(handles.sP.TC_event_amp);
default = handles.sP.TC_event_amp;  
mxsize.row=handles.sP.nC;
mxsize.col=handles.sP.TC_event_n;

if m~=mxsize.row || n~=mxsize.col
   m=mxsize.row;
   n=mxsize.col;
   default = zeros(m,n);
end

for i= 1:m
  %rnames{i} = num2str(i);
%   rnames{i} = strcat(num2str(handles.sP.SM_source_ID(i)), ' (', num2str(i), ')');
  rnames{i} = sprintf('%3d (%3d)',handles.sP.SM_source_ID(i),i);  % 9 character column
end

for i= 1:n
%   cnames{i} = strcat(num2str(i));
  cnames{i} = sprintf('      %3d',i);  % 9 character column
end

instruction = 'Fill in the matrix of task-modulation amplitudes relative to unique events for eachcomponent. To get started, use the drop-down menu at left and select a method to initialize values.  Then, update the values by hand.  When you are satisfied, hit "Done". ';
panelname = 'Parameter Selection: Step 4d2';
paneltitle = 'TC event amplitude';
handles.sP.TC_event_amp = simtb_GUI_matrix_gen(2, xlabel, ylabel, cnames, rnames,instruction, default, panelname, paneltitle, 'TC_event_amp');
guidata(hObject, handles); 
set(hObject,'BackgroundColor',handles.fgColor);



 % --- Executes on button press in Done.
function Done_Callback(hObject, eventdata, handles)
% hObject    handle to Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[errorflag, Message] = simtb_checkparams(handles.sP, '5');
if errorflag
    Title = 'Error';
    Icon = 'error';
    h = msgbox(Message,Title,Icon);
else
    close(gcf);
    simtb_GUI_params_TC_Basic(handles.sP);  
end



% --- Executes on button press in help_TC_event_same_FLAG.
function help_TC_event_same_FLAG_Callback(hObject, eventdata, handles)
% hObject    handle to help_TC_event_same_FLAG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('TC_event_same_FLAG');

% --- Executes on button press in help_TC_event_prob.
function help_TC_event_prob_Callback(hObject, eventdata, handles)
% hObject    handle to help_TC_event_prob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('TC_event_prob');

% --- Executes on button press in help_TC_event_amp.
function help_TC_event_amp_Callback(hObject, eventdata, handles)
% hObject    handle to help_TC_event_amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('TC_event_amp');
