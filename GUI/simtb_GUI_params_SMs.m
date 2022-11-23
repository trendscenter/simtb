  function varargout = simtb_GUI_params_SMs(varargin)
% SIMTB_GUI_PARAMS_SMS M-file for simtb_GUI_params_SMs.fig
%      SIMTB_GUI_PARAMS_SMS, by itself, creates SM_present new SIMTB_GUI_PARAMS_SMS or raises the existing
%      singleton*.
%
%      H = SIMTB_GUI_PARAMS_SMS returns the handle to SM_present new SIMTB_GUI_PARAMS_SMS or the handle to
%      the existing singleton*.
%
%      SIMTB_GUI_PARAMS_SMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMTB_GUI_PARAMS_SMS.M with the given input arguments.
%
%      SIMTB_GUI_PARAMS_SMS('Property','Value',...) creates SM_present new SIMTB_GUI_PARAMS_SMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simtb_GUI_params_SMs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simtb_GUI_params_SMs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simtb_GUI_params_SMs

% Last Modified by GUIDE v2.5 27-Nov-2010 20:16:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simtb_GUI_params_SMs_OpeningFcn, ...
                   'gui_OutputFcn',  @simtb_GUI_params_SMs_OutputFcn, ...
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


% --- Executes just before simtb_GUI_params_SMs is made visible.
function simtb_GUI_params_SMs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in SM_present future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simtb_GUI_params_SMs (see VARARGIN)

handles.fgColor = [0.6784    0.9216    1.0000];
handles.bgColor = [.5 .5 .5];

set(handles.figure1, 'Name', 'Parameter Selection: Step 3')
sP = varargin{1};
handles.sP=sP;

Intro = 'Parameters for component spatial maps (SMs)';
set(handles.text0, 'String', Intro);

set(handles.text1, 'String', simtb_GUI_format_paramlabel('SM_source_ID'), 'HorizontalAlignment', 'left');
set(handles.text2, 'String', simtb_GUI_format_paramlabel('SM_present'), 'HorizontalAlignment', 'left');
set(handles.text3, 'String', simtb_GUI_format_paramlabel('SM_translate_x'), 'HorizontalAlignment', 'left');
set(handles.text4, 'String', simtb_GUI_format_paramlabel('SM_translate_y'), 'HorizontalAlignment', 'left');
set(handles.text5, 'String', simtb_GUI_format_paramlabel('SM_theta'), 'HorizontalAlignment', 'left');
set(handles.text6, 'String', simtb_GUI_format_paramlabel('SM_spread'), 'HorizontalAlignment', 'left');

guidata(hObject, handles);
handles.output = handles.sP;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simtb_GUI_params_SMs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simtb_GUI_params_SMs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in SM_present future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pickSM.
function pickSM_Callback(hObject, eventdata, handles)
% hObject    handle to pickSM (see GCBO)
% eventdata  reserved - to be defined in SM_present future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sP.SM_source_ID = simtb_pickSM(handles.sP.SM_source_ID); 

if handles.sP.nC ~= length(handles.sP.SM_source_ID)
    Message = sprintf('Note: The number of components has been updated from %d to %d.',handles.sP.nC, length(handles.sP.SM_source_ID));
    Icon = 'warning';
    h = msgbox(Message,Icon);
end
    
handles.sP.nC = length(handles.sP.SM_source_ID);

handles.sP.M
handles.sP.nC

guidata(hObject, handles); 

set(hObject,'BackgroundColor',handles.fgColor);
set(handles.SM_present,'BackgroundColor',handles.bgColor);
set(handles.SM_translate_x,'BackgroundColor',handles.bgColor);
set(handles.SM_translate_y,'BackgroundColor',handles.bgColor);
set(handles.SM_theta,'BackgroundColor',handles.bgColor);
set(handles.SM_spread,'BackgroundColor',handles.bgColor);


% --- Executes on button press in SM_present.
function SM_present_Callback(hObject, eventdata, handles)
% hObject    handle to SM_present (see GCBO)
% eventdata  reserved - to be defined in SM_present future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xlabel = 'Source ID (component index)';
ylabel = 'Subject Index';
cnames={};
rnames={};

[m,n] = size(handles.sP.SM_present);
default = handles.sP.SM_present;  
mxsize.row=handles.sP.M;
mxsize.col=handles.sP.nC;

if m~=mxsize.row || n~=mxsize.col
   m=mxsize.row;
   n=mxsize.col;
   default = ones(m,n);
end

for i= 1:m
%   rnames{i} = num2str(i);
  rnames{i} = sprintf('      %3d',i);  % 9 character column
end

for i= 1:n
%   cnames{i} = strcat(num2str(handles.sP.SM_source_ID(i)), ' (', num2str(i), ')');
  cnames{i} = sprintf('%3d (%3d)',handles.sP.SM_source_ID(i),i);  % 9 character column
end

instruction = ['Fill in the values for component presence for each subject and component. 1 indicates the component is included, 0 indicates it is absent.'...
'To get started, use the drop-down menu at left and select a method to initialize values.  If desired, then update the values by hand.  When you are satisfied, hit "Done".'];
panelname = 'Parameter Selection: Step 3a';
paneltitle = 'SM presence/absence';
handles.sP.SM_present = simtb_GUI_matrix_gen_B(2, xlabel, ylabel, cnames, rnames,instruction, default,panelname, paneltitle, 'SM_present');

%% Value for component presence must be either 0 or 1
if any((handles.sP.SM_present(:) ~= 0 ) & (handles.sP.SM_present(:) ~= 1 ))
   Title ='';
   Icon ='error';
   Message = 'ERROR: Component presence values must be either 0 or 1. Re-enter ''SM_present'' value.';
   msgbox(Message,Title,Icon)
   set(hObject,'BackgroundColor','red');
else
   set(hObject,'BackgroundColor',handles.fgColor);
end
%%

guidata(hObject, handles); 


% --- Executes on button press in SM_translate_x.
function SM_translate_x_Callback(hObject, eventdata, handles)
% hObject    handle to SM_translate_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xlabel = ' Source ID (Component Index)';
ylabel = 'Subject Index';
cnames={};
rnames={};

[m,n] = size(handles.sP.SM_translate_x);
default = handles.sP.SM_translate_x;  
mxsize.row=handles.sP.M;
mxsize.col=handles.sP.nC;

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
%   cnames{i} = strcat(num2str(handles.sP.SM_source_ID(i)), ' (', num2str(i), ')');
  cnames{i} = sprintf('%3d (%3d)',handles.sP.SM_source_ID(i),i);  % 9 character column
end

instruction = ['Fill in the values for SM x-translation (in voxels) for each subject and component. '...
'To get started, use the drop-down menu at left and select a method to initialize values.  If desired, then update the values by hand.  When you are satisfied, hit "Done".'];
%type = 1;  %% define as binary or not for data generating
panelname = 'Parameter Selection: Step 3b';
paneltitle = 'SM translation in X';
handles.sP.SM_translate_x = simtb_GUI_matrix_gen(2,xlabel, ylabel, cnames, rnames,instruction, default,panelname, paneltitle, 'SM_translate_x');
guidata(hObject, handles); 
set(hObject,'BackgroundColor',handles.fgColor);


% --- Executes on button press in SM_translate_y.
function SM_translate_y_Callback(hObject, eventdata, handles)
% hObject    handle to SM_translate_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xlabel = 'Source ID (Component Index)';
ylabel = 'Subject Index';
cnames={};
rnames={};

[m,n] = size(handles.sP.SM_translate_y);
default = handles.sP.SM_translate_y;  
mxsize.row=handles.sP.M;
mxsize.col=handles.sP.nC;

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
%   cnames{i} = strcat(num2str(handles.sP.SM_source_ID(i)), ' (', num2str(i), ')');
  cnames{i} = sprintf('%3d (%3d)',handles.sP.SM_source_ID(i),i);  % 9 character column
end

instruction = ['Fill in the values for SM y-translation (in voxels) for each subject and component. '...
'To get started, use the drop-down menu at left and select a method to initialize values.  If desired, then update the values by hand.  When you are satisfied, hit "Done".'];

panelname = 'Parameter Selection: Step 3c';
paneltitle = 'SM translation in Y';
handles.sP.SM_translate_y = simtb_GUI_matrix_gen(2,xlabel, ylabel, cnames, rnames,instruction, default,panelname, paneltitle, 'SM_translate_y');
guidata(hObject, handles); 
set(hObject,'BackgroundColor',handles.fgColor);


% --- Executes on button press in SM_theta.
function SM_theta_Callback(hObject, eventdata, handles)
% hObject    handle to SM_theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xlabel = 'Source ID (Component Index)';
ylabel = 'Subject Index';
cnames={};
rnames={};

[m,n] = size(handles.sP.SM_theta);
default = handles.sP.SM_theta;  
mxsize.row=handles.sP.M;
mxsize.col=handles.sP.nC;

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
%   cnames{i} = strcat(num2str(handles.sP.SM_source_ID(i)), ' (', num2str(i), ')');
  cnames{i} = sprintf('%3d (%3d)',handles.sP.SM_source_ID(i),i);  % 9 character column
end

instruction = ['Fill in the values for SM x-translation (in degrees) for each subject and component.'...
'To get started, use the drop-down menu at left and select a method to initialize values.  If desired, then update the values by hand.  When you are satisfied, hit "Done".'];

panelname = 'Parameter Selection: Step 3d';
paneltitle = 'SM rotation';
handles.sP.SM_theta = simtb_GUI_matrix_gen(2,xlabel, ylabel, cnames, rnames,instruction, default,panelname, paneltitle, 'SM_theta');
guidata(hObject, handles); 
set(hObject,'BackgroundColor',handles.fgColor);


% --- Executes on button press in SM_spread.
function SM_spread_Callback(hObject, eventdata, handles)
% hObject    handle to SM_spread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xlabel = 'Source ID (Component Index)';
ylabel = 'Subject Index';
cnames={};
rnames={};

[m,n] = size(handles.sP.SM_spread);
default = handles.sP.SM_spread;  
mxsize.row=handles.sP.M;
mxsize.col=handles.sP.nC;

if m~=mxsize.row || n~=mxsize.col
   m=mxsize.row;
   n=mxsize.col;
   default = ones(m,n);
end

for i= 1:m
%   rnames{i} = num2str(i);
  rnames{i} = sprintf('      %3d',i);  % 9 character column
end

for i= 1:n
%   cnames{i} = strcat(num2str(handles.sP.SM_source_ID(i)), ' (', num2str(i), ')');
  cnames{i} = sprintf('%3d (%3d)',handles.sP.SM_source_ID(i),i);  % 9 character column
end

instruction = ['Fill in the values for SM size for each subject and component.  Values greater than 1 indicate SM magnification, values less than 1 indicate contraction.'...
'To get started, use the drop-down menu at left and select a method to initialize values.  If desired, then update the values by hand.  When you are satisfied, hit "Done".'];
panelname = 'Parameter Selection: Step 3e';
paneltitle = 'SM size';
handles.sP.SM_spread = simtb_GUI_matrix_gen(2,xlabel, ylabel, cnames, rnames,instruction, default,panelname, paneltitle, 'SM_spread');
guidata(hObject, handles); 
set(hObject,'BackgroundColor',handles.fgColor);


% --- Executes on button press in Back.
function Back_Callback(hObject, eventdata, handles)
% hObject    handle to Back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
simtb_GUI_params_primary(handles.sP);
%set(simtb_GUI_params_primary(handles.sP),'windowstyle','modal');


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in SM_present future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[errorflag, Message] = simtb_checkparams(handles.sP, '3');

if errorflag
   Title = 'Error';
   Icon = 'error';
   h = msgbox(Message,Title,Icon);
else          
  close(gcf);
  handles.sP = simtb_GUI_params_TC_Basic(handles.sP); 
end


% --- Executes on button press in help_SM_source_ID.
function help_SM_source_ID_Callback(hObject, eventdata, handles)
% hObject    handle to help_SM_source_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('SM_source_ID');

% --- Executes on button press in help_SM_present.
function help_SM_present_Callback(hObject, eventdata, handles)
% hObject    handle to help_SM_present (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('SM_present');

% --- Executes on button press in help_SM_translate_x.
function help_SM_translate_x_Callback(hObject, eventdata, handles)
% hObject    handle to help_SM_translate_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('SM_translate_x');

% --- Executes on button press in help_SM_translate_y.
function help_SM_translate_y_Callback(hObject, eventdata, handles)
% hObject    handle to help_SM_translate_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('SM_translate_y');

% --- Executes on button press in help_SM_theta.
function help_SM_theta_Callback(hObject, eventdata, handles)
% hObject    handle to help_SM_theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('SM_theta');

% --- Executes on button press in help_SM_spread.
function help_SM_spread_Callback(hObject, eventdata, handles)
% hObject    handle to help_SM_spread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('SM_spread');
