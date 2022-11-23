function varargout = simtb_GUI_params_TC_Basic(varargin)
% SIMTB_GUI_PARAMS_TC_BASIC M-file for simtb_GUI_params_TC_Basic.fig
%      SIMTB_GUI_PARAMS_TC_BASIC, by itself, creates SM_present new SIMTB_GUI_PARAMS_TC_BASIC or raises the existing
%      singleton*.
%
%      H = SIMTB_GUI_PARAMS_TC_BASIC returns the handle to SM_present new SIMTB_GUI_PARAMS_TC_BASIC or the handle to
%      the existing singleton*.
%
%      SIMTB_GUI_PARAMS_TC_BASIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMTB_GUI_PARAMS_TC_BASIC.M with the given input arguments.
%
%      SIMTB_GUI_PARAMS_TC_BASIC('Property','Value',...) creates SM_present new SIMTB_GUI_PARAMS_TC_BASIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simtb_GUI_params_TC_Basic_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simtb_GUI_params_TC_Basic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simtb_GUI_params_TC_Basic

% Last Modified by GUIDE v2.5 25-Dec-2010 12:12:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @simtb_GUI_params_TC_Basic_OpeningFcn, ...
    'gui_OutputFcn',  @simtb_GUI_params_TC_Basic_OutputFcn, ...
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


% --- Executes just before simtb_GUI_params_TC_Basic is made visible.
function simtb_GUI_params_TC_Basic_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in SM_present future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simtb_GUI_params_TC_Basic (see VARARGIN)
handles = guihandles(hObject);
handles.fgColor = [0.6784    0.9216    1.0000];
handles.bgColor = [.5 .5 .5];

set(handles.figure1, 'Name', 'Parameter Selection: Step 4')

set(handles.text1,  'HorizontalAlignment', 'left');
set(handles.text2,  'HorizontalAlignment', 'left');
set(handles.text3,  'HorizontalAlignment', 'left');
set(handles.text4,  'HorizontalAlignment', 'left');
set(handles.text5,  'HorizontalAlignment', 'left');

sP = varargin{1};
handles.sP=sP;

set(handles.TC_block_n, 'String', num2str(handles.sP.TC_block_n))
set(handles.TC_event_n, 'String', num2str(handles.sP.TC_event_n))

if handles.sP.TC_unique_FLAG
    set(handles.TC_unique_FLAG_yes,'BackgroundColor',handles.fgColor);
    set(handles.TC_unique_FLAG_no,'BackgroundColor',handles.bgColor);
else
    set(handles.TC_unique_FLAG_no,'BackgroundColor',handles.fgColor);
    set(handles.TC_unique_FLAG_yes,'BackgroundColor',handles.bgColor);
end


set(handles.text1, 'String', simtb_GUI_format_paramlabel('TC_source_type'), 'HorizontalAlignment', 'left');
set(handles.text2, 'String', simtb_GUI_format_paramlabel('TC_source_params'), 'HorizontalAlignment', 'left');
set(handles.text3, 'String', simtb_GUI_format_paramlabel('TC_block_n'), 'HorizontalAlignment', 'left');
set(handles.text4, 'String', simtb_GUI_format_paramlabel('TC_event_n'), 'HorizontalAlignment', 'left');
set(handles.text5, 'String', simtb_GUI_format_paramlabel('TC_unique_FLAG'), 'HorizontalAlignment', 'left');

% Get the status of the TC params (same or different for comps and subjects)
[com_SAME, sub_SAME] = get_TC_source_params_status(handles.sP.TC_source_params,handles.sP.TC_source_type);
handles.com_same_FLAG=com_SAME;
handles.sub_same_FLAG=sub_SAME;


handles.output = handles.sP;
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = simtb_GUI_params_TC_Basic_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in SM_present future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% varargout{2} = handles.com_same_FLAG;
% varargout{1} = handles.sub_same_FLAG;

% --- Executes on button press in TC_source_type.
function TC_source_type_Callback(hObject, eventdata, handles)
% hObject    handle to TC_source_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TCM_type=simtb_countTCmodels();
xlabel = 'Source ID (Component Index)';
ylabel = '';   %'TC Model Index';
rnames={};
cnames={};

[m,n] = size(handles.sP.TC_source_type);
default = handles.sP.TC_source_type;
mxsize.row=1;
mxsize.col=handles.sP.nC;

if m~=mxsize.row || n~=mxsize.col
    m=mxsize.row;
    n=mxsize.col;
    default = ones(m,n);
end

for i= 1:m
    rnames{i} = '';%num2str(i);
end

for i= 1:n
%     cnames{i} = strcat(num2str(handles.sP.SM_source_ID(i)), ' (', num2str(i), ')');
    cnames{i} = sprintf('%3d (%3d)',handles.sP.SM_source_ID(i),i);  % 9 character column
end

instruction = sprintf(['Fill in model types (1 to %d) used to generate TCs for each component (see model descriptions below).'...
    'To get started, use the drop-down menu at left and select a method to initialize values.'...
    'Then, update the values by hand.  When you are satisfied, hit "Done".\n'], TCM_type);

panelname = 'Parameter Selection: Step 4a';
paneltitle = 'TC Model Index';
handles.sP.TC_source_type = simtb_GUI_matrix_gen_TCST(2, xlabel, ylabel, cnames, rnames, instruction, default, panelname, TCM_type, paneltitle, 'TC_source_type');
guidata(hObject, handles);
set(hObject,'BackgroundColor',handles.fgColor);


% --- Executes on button press in TC_source_params.
function TC_source_params_Callback(hObject, eventdata, handles)
% hObject    handle to TC_source_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if  any(size(handles.sP.TC_source_type) ~= [1, handles.sP.nC])
    Title = '';
    Icon = 'error';
    Message = strvcat('ERROR: Please update parameter TC_source_type first.');
    msgbox(Message, Title, Icon);
else
    
paramFLAGS = simtb_GUI_params_TC_Source_params(handles.com_same_FLAG,handles.sub_same_FLAG);
handles.com_same_FLAG = paramFLAGS(1);
handles.sub_same_FLAG = paramFLAGS(2);
handles.sP.TC_source_params = cell(handles.sP.M, handles.sP.nC);

Models = unique(handles.sP.TC_source_type);
nModels = length(Models);

if handles.com_same_FLAG == 1 && handles.sub_same_FLAG == 1
    %% All subjects and components with the same model have same parameters
    for h = 1:nModels
        % these comps have the same model
        compINDs = find(Models(h) == handles.sP.TC_source_type);
        % get a single set of params
        temp_params = get_default_params(Models(h));
        for c = compINDs
            for sub = 1:handles.sP.M
                handles.sP.TC_source_params{sub,c} = temp_params;
            end
        end

    end
elseif handles.com_same_FLAG == 1 && handles.sub_same_FLAG == 0
    %% All components with same model in an individual have same parameters,
    %% parameters differ between subjects
    for h = 1:nModels
        % these comps have the same model
        compINDs = find(Models(h) == handles.sP.TC_source_type);
        for sub = 1:handles.sP.M
            % get new parameters for each subject
            temp_params = get_default_params(Models(h));
            for c = compINDs
                handles.sP.TC_source_params{sub,c} = temp_params;
            end
        end

    end

elseif handles.com_same_FLAG == 0 && handles.sub_same_FLAG == 1
    %% Components with same model in an individual have different parameters,
    %% but the parameters are identical across subjects
    for h = 1:nModels
        % these comps have the same model
        compINDs = find(Models(h) == handles.sP.TC_source_type);
        for c = compINDs
            % get a single set of params for all subjects
            temp_params = get_default_params(Models(h));
            for sub = 1:handles.sP.M
                handles.sP.TC_source_params{sub,c} = temp_params;
            end
        end

    end
else
    %% Parameters are different for each subject and component
    for h = 1:nModels
        % these comps have the same model
        compINDs = find(Models(h) == handles.sP.TC_source_type);
        for sub = 1:handles.sP.M
            for c = compINDs
                % get new parameters for each component
                temp_params = get_default_params(Models(h));
                handles.sP.TC_source_params{sub,c} = temp_params;
            end
        end

    end

end

end
guidata(hObject, handles);
set(hObject,'BackgroundColor',handles.fgColor);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function TC_block_n_Callback(hObject, eventdata, handles)
% hObject    handle to TC_block_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TC_block_n as text
%        str2double(get(hObject,'String')) returns contents of TC_block_n as a double
handles.sP.TC_block_n = str2num(get(hObject,'String'));

if handles.sP.TC_block_n > 0
    handles.sP = simtb_GUI_params_TC_Block(handles.sP);
    set(hObject,'BackgroundColor',handles.fgColor);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TC_block_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TC_block_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TC_event_n_Callback(hObject, eventdata, handles)
% hObject    handle to TC_event_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TC_event_n as text
%        str2double(get(hObject,'String')) returns contents of TC_event_n as a double
handles.sP.TC_event_n = str2num(get(hObject,'String'));

if handles.sP.TC_event_n > 0
    handles.sP = simtb_GUI_params_TC_Event(handles.sP);
    set(hObject,'BackgroundColor',handles.fgColor);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TC_event_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TC_event_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TC_unique_FLAG_yes.
function TC_unique_FLAG_yes_Callback(hObject, eventdata, handles)
% hObject    handle to TC_unique_FLAG_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sP.TC_unique_FLAG = 1;
handles.sP = simtb_GUI_params_TC_UniqueEvent(handles.sP);
set(hObject,'BackgroundColor',handles.fgColor);
set(handles.TC_unique_FLAG_no,'BackgroundColor',handles.bgColor);
guidata(hObject, handles);

% --- Executes on button press in TC_unique_FLAG_no.
function TC_unique_FLAG_no_Callback(hObject, eventdata, handles)
% hObject    handle to TC_unique_FLAG_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sP.TC_unique_FLAG = 0;
set(hObject,'BackgroundColor',handles.fgColor);
set(handles.TC_unique_FLAG_yes,'BackgroundColor',handles.bgColor);
guidata(hObject, handles);

% --- Executes on button press in Back.
function Back_Callback(hObject, eventdata, handles)
% hObject    handle to Back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
simtb_GUI_params_SMs(handles.sP);


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in SM_present future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[errorflag, Message] = simtb_checkparams(handles.sP, '8');

if errorflag
    Title = 'Error';
    Icon = 'error';
    h = msgbox(Message,Title,Icon);
else
    close(gcf);
    handles.sP = simtb_GUI_params_Dataset(handles.sP);
end

% --- Executes on button press in help_TC_source_type.
function help_TC_source_type_Callback(hObject, eventdata, handles)
% hObject    handle to help_TC_source_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('TC_source_type');

% --- Executes on button press in help_TC_source_params.
function help_TC_source_params_Callback(hObject, eventdata, handles)
% hObject    handle to help_TC_source_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('TC_source_params');

% --- Executes on button press in help_TC_block_n.
function help_TC_block_n_Callback(hObject, eventdata, handles)
% hObject    handle to help_TC_block_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('TC_block_n');

% --- Executes on button press in help_TC_event_n.
function help_TC_event_n_Callback(hObject, eventdata, handles)
% hObject    handle to help_TC_event_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('TC_event_n');

% --- Executes on button press in help_TC_unique.
function help_TC_unique_Callback(hObject, eventdata, handles)
% hObject    handle to help_TC_unique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
simtb_GUI_format_paramhelp('TC_unique');

%--------------------------------------------------------------------------
%                    SUB-FUNCTIONS
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
function  P = get_default_params(sourceType)
[tc, MDESC, P, PDESC] = simtb_TCsource(1, 1, sourceType);

%--------------------------------------------------------------------------
function [com_SAME, sub_SAME] = get_TC_source_params_status(TC_params, TC_models)

[M, nC] = size(TC_params);
Models = unique(TC_models);
compIND = find(TC_models == Models(1));

if isempty(TC_params) || isempty(TC_params{1,1})
    % Values are not filled yet, default to have different params for all subjects/components
    com_SAME = 0;
    sub_SAME = 0;
    return
end

if all(TC_params{1,1} == TC_params{M,1}) && all(TC_params{1,nC} == TC_params{M,nC})
    sub_SAME = 1;
else
    sub_SAME = 0;
end

if all(TC_params{1,compIND(1)} == TC_params{1,compIND(end)}) && all(TC_params{M,compIND(1)} == TC_params{M,compIND(1)})
    com_SAME = 1;
else
    com_SAME = 0;
end
%--------------------------------------------------------------------------
