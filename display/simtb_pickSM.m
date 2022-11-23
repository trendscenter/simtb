function varargout = simtb_pickSM(varargin)
% simtb_pickSM() - GUI for selecting sources
%
% USAGE:
% >> simtb_pickSM
% >> simtb_pickSM(SM_source_ID)
% >> SM_source_ID = simtb_pickSM;
%
% INPUTS:
% SM_source_ID = IDs for initial desired sources [OPTIONAL, default = [] ]
%
% OUTPUTS: (OPTIONAL)
% SM_source_ID = IDs for selected sources


% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @simtb_pickSM_OpeningFcn, ...
    'gui_OutputFcn',  @simtb_pickSM_OutputFcn, ...
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


% --- Executes just before simtb_pickSM is made visible.
function simtb_pickSM_OpeningFcn(hObject, eventdata, handles, varargin)

MB = msgbox('SM selector is loading, please wait.', 'Loading...');


% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simtb_pickSM (see VARARGIN)

% Choose default command line output for simtb_pickSM
[CH, CMAP] = simtb_figure_drawSMs(handles.axes1, 256, 0.5);

drawnow;
if (simtb_get_matlab_version > 2014 || strcmpi(version('-release'), '2014b'))
    
    for nc = 1:numel(CH)
        cmat = get(CH{nc}, 'contourMatrix');
        colorTmp = simtb_lighten_color(CMAP(nc,:), 0.7);
        while ~isempty(cmat)
            len = cmat(2, 1);
            patch('faces', (1:len), 'vertices', cmat(:, 2:len+1)', 'facecolor', colorTmp, 'tag', ['patch_simtb_', num2str(nc)]);
            cmat(:, 1:len+1) = [];
        end
    end
    
    
end

contH = findobj('type', 'contour');

patchH = findobj('-regexp', 'tag', 'patch\_simtb');
if (~isempty(patchH))
    uistack([patchH(:); contH(:)], 'top');
end

try
    handles.contours = cell2mat(CH);
catch
    handles.contours = CH;
end
handles.cmap = CMAP;
handles.contourfilled = zeros(1,length(CH));
if ~isempty(varargin)
    handles.nC =  length(varargin{1});
    handles.SM_ID = varargin{1};
    handles.contourfilled(handles.SM_ID) = 1;
else
    handles.nC = length(CH);
    handles.SM_ID = 1:length(CH);
end

updateFills(handles);

updateLegend(handles);

% Update handles structure
set(get(handles.axes1, 'Children'),'buttondownfcn',{@axes1_ButtonDownFcn,handles})
guidata(handles.figure1, handles);
try
    delete(MB)
catch
end
uiwait;
handles = guidata(handles.figure1);
guidata(handles.figure1, handles);

drawnow;

% UIWAIT makes simtb_pickSM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simtb_pickSM_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles = guidata(handles.figure1);
varargout{1} = find(handles.contourfilled);
fprintf('Number of selected components: %d\n', length(varargout{1}))
fprintf('Component Source IDs:\n \t[%s]\n', num2str(varargout{1}, '%d '))
%close(handles.figure1)

function handles = axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject handle to image (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
currentPt = get(handles.axes1, 'CurrentPoint');
% plot(currentPt(1,1), currentPt(1,2), 'r.', 'MarkerSize', 20);
handles = guidata(handles.figure1);
handles.P = [currentPt(1,1), currentPt(1,2)];
guidata(handles.figure1, handles);
evaluatePoint_Callback(hObject, eventdata, handles);


% --- Executes on button press in donebutton.
function donebutton_Callback(hObject, eventdata, handles)
% hObject    handle to donebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(get(handles.axes1, 'Children'),'buttondownfcn',[])
%set(handles.donebutton, 'Visible', 'off')
uiresume;
guidata(handles.figure1, handles);
set(handles.donebutton, 'Visible', 'off')
set(handles.RandomButton, 'Visible', 'off')
set(handles.Resetbutton, 'Visible', 'off')
%close(handles.figure1)

% --- Evaluate the point where user clicks
function evaluatePoint_Callback(hObject,  eventdata, handles)
P = handles.P;
CH = handles.contours;
hit = 0;
ii = length(CH);
% loop through the components -- counting backwards
while (hit == 0 && ii > 0)
    
    if (iscell(CH))
        verts = getPatchVert(CH{ii});
    else
        verts = getPatchVert(CH(ii));
    end
    
    %EachContour =  get(CH(ii),'Children');
    anyhit = 0;
    
    % loop through each contour
    for cc = 1:length(verts)
        tempvert = verts{cc};
        %tempvert = get(EachContour(cc),'Vertices');
        anyhit = anyhit + simtb_inpoly(P,tempvert(1:end-1,:));
    end
    
    
    if anyhit
        hit = 1;
        handles.contourfilled(ii) = ~handles.contourfilled(ii);
        updateFills(handles, ii);
    else
        ii = ii-1;
    end % of this component, move on to next
end

updateLegend(handles)

guidata(handles.figure1, handles);

% ---- Update the fills of components
function updateFills(handles, ThisComp)
CH = handles.contours;
CMAP = handles.cmap;

if nargin < 2
    ThisComp = 1:length(CH);
end

drawnow;

set(handles.figure1, 'pointer', 'watch');

for ii = ThisComp
    if handles.contourfilled(ii)
        if (iscell(CH))
            set(CH{ii}, 'fill', 'on');
            patches = get(CH{ii}, 'Children');
        else
            set(CH(ii), 'fill', 'on');
            patches = get(CH(ii), 'Children');
        end
        
        colorTmp = simtb_lighten_color(CMAP(ii,:), 0.7);
        if (~isempty(patches))
            set(patches, 'FaceColor', colorTmp);
        else
            tmpPatchH = findobj(handles.figure1, 'tag', ['patch_simtb_', num2str(ii)]);
            if (ii ~= 1)
                uistack([tmpPatchH; CH{ii}], 'top');
            end
            set(tmpPatchH, 'visible', 'on');
        end
    else
        if (simtb_get_matlab_version > 2014 || strcmpi(version('-release'), '2014b'))
            tmpPatchH = findobj(handles.figure1, 'tag', ['patch_simtb_', num2str(ii)]);
            set(tmpPatchH, 'visible', 'off');
            if (ii ~= 1)
                uistack([CH{ii}; tmpPatchH], 'top');
            end
        else
            set(CH(ii), 'fill', 'off');
        end
    end
end


set(handles.figure1, 'pointer', 'arrow');

% ---- Update the legend
function updateLegend(handles)
CH = handles.contours;
if (~iscell(CH))
    for ii = 1:length(CH)
        Ptemp = get(CH(ii), 'Children');
        P(ii) = Ptemp(1);
    end
end

set(handles.axes1, 'units', 'normalized');
axPos = get(handles.axes1, 'Position');
if (~iscell(CH))
    L = legend(P, num2str([1:length(P)]'));
else
    for ii = 1:length(CH)
        tmpPatchH = findobj(handles.figure1, 'tag', ['patch_simtb_', num2str(ii)]);
        patchH(ii) = tmpPatchH(1);
    end
    L = legend(patchH, num2str([1:length(patchH)]'));
    clear patchH;
end
%L = legend(num2str([1:length(CH)]'));

% [left bottom width height]
%set(L, 'units', 'normalized', 'Position', [axPos(1)+axPos(3), axPos(2), .01, axPos(4)], 'FontSize', 7);
set(L, 'units', 'normalized', 'Position', [.9, 0, .05, .95], 'FontSize', 7);
set(L, 'TextColor', [1 1 1]);

set(handles.nCText, 'String', length(find(handles.contourfilled)))

% --- Executes on button press in Resetbutton.
function Resetbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Resetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.contourfilled(1:length(handles.contourfilled)) = 0;
updateFills(handles)
updateLegend(handles)
guidata(handles.figure1, handles);

% --- Executes on button press in RandomButton.
function RandomButton_Callback(hObject, eventdata, handles)
% hObject    handle to RandomButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answernC = inputdlg({'How many sources should be picked randomly?'},'nC' ,1, {num2str(handles.nC)});
nC = str2num(answernC{1});
handles.nC = nC;
CH = handles.contours;
nSources = length(CH);
CMAP = handles.cmap;
% first turn them all off
set(CH, 'fill', 'off');
handles.contourfilled(1:length(CH)) = 0;
updateFills(handles)

% now fill in the chosen ones
INDS = randperm(nSources);
chosen = INDS(1:nC);
handles.contourfilled(chosen) = 1;
updateFills(handles)
updateLegend(handles)
guidata(handles.figure1, handles);


function verts = getPatchVert(CH)

if (simtb_get_matlab_version > 2014 || strcmpi(version('-release'), '2014b'))
    cmat = get(CH, 'contourMatrix');
    verts = {};
    while ~isempty(cmat)
        len = cmat(2, 1);
        verts{end + 1} = cmat(:, 2:len+1)';
        cmat(:, 1:len+1) = [];
    end
else
    EachContour =  get(CH, 'Children');
    verts = cell(1, length(EachContour));
    for nv = 1:length(verts)
        verts{nv}  = get(EachContour(nv),'Vertices');
    end
end

