function varargout = RocTreeGUI(varargin)
% ROCTREEGUI M-file for RocTreeGUI.fig
%      ROCTREEGUI, by itself, creates a new ROCTREEGUI or raises the existing
%      singleton*.
%
%      H = ROCTREEGUI returns the handle to a new ROCTREEGUI or the handle to
%      the existing singleton*.
%
%      ROCTREEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROCTREEGUI.M with the given input arguments.
%
%      ROCTREEGUI('Property','Value',...) creates a new ROCTREEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RocTreeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RocTreeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RocTreeGUI

% Last Modified by GUIDE v2.5 20-Dec-2009 14:35:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RocTreeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RocTreeGUI_OutputFcn, ...
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


% --- Executes just before RocTreeGUI is made visible.
function RocTreeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RocTreeGUI (see VARARGIN)

% Choose default command line output for RocTreeGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
initialize_gui(hObject, handles, false);


%Added code for center the GUI. From
%http://www.mathworks.de/matlabcentral/newsreader/view_thread/152171
set( handles.figure1, ...
    'Units', 'pixels' );

%get your display size
screenSize = get(0, 'ScreenSize');

%calculate the center of the display
position = get( handles.figure1, ...
    'Position' );
position(1) = (screenSize(3)-position(3))/2;
position(2) = (screenSize(4)-position(4))/2;

%center the window
set( handles.figure1, ...
    'Position', position );

%Finish added code

% UIWAIT makes RocTreeGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);

function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
%if ~isreset
 %   return;
%end
global textdata;
global iExit;

iExit = 0;

handles.output = handles;
handles.HasBeenSelectedL1 = 0;
handles.HasBeenSelectedL2 = 0;

VarNames = textdata;
%VarNames = evalin ('caller', 'textdata');
%Drop the outcome name
VarNames (1) = [];

set(handles.listbox1, 'String', VarNames);

%Inizialize variable contain a cell array of the categorical variables
handles.CatVarSelectedStr={};
guidata(fig_handle,handles)
set(handles.listbox2, 'String', handles.CatVarSelectedStr);

% Update handles structure
guidata(handles.figure1, handles);



% --- Outputs from this function are returned to the command line.
function varargout = RocTreeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure

varargout{1} = 0;



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
%Return the number of the item selected
index_selected = get(hObject,'Value');

%Return a list of variable in string cell array string
list = get(hObject,'String');

%Almost a variable has been selected
handles.HasBeenSelectedL1=1;

%Return a cell array of variable selected
item_selected = list{index_selected};
%Gui data
handles.VarSelectedStr = list{index_selected};

%assignin('base', 'selected', index_selected);
%assignin('base', 'VarSelectedStr', item_selected);

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

%Almost a variable has been selected
handles.HasBeenSelectedL2=1;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1. Add a variable
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%VarNames = evalin ('base', 'VarSelectedStr');

global CatSelected;

if handles.HasBeenSelectedL1 == 1
    
    %Aggiungere al cell array
    %Find the string with that name if present in CatVarNames
    %If it isn't an empty matrix add the string
    if isempty(find (strcmp(handles.CatVarSelectedStr, handles.VarSelectedStr))) 
        yposition = length(handles.CatVarSelectedStr)+1;
        handles.CatVarSelectedStr (yposition,1) = cellstr(handles.VarSelectedStr);
    end

    set(handles.listbox2, 'String', handles.CatVarSelectedStr, 'Value', 1);
    %Pass the list at the program

    CatSelected= handles.CatVarSelectedStr;

else
    warndlg('Select a Variable on the left first!', 'Tree Classificatory Algorithm')
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton2 = REMOVE A VARIABLE
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CatSelected;

if handles.HasBeenSelectedL2 == 1
    index_selected = get(handles.listbox2,'Value');

    %Return a list of variable in string cell array string
    list = get(handles.listbox2,'String');


    %Return a cell array of variable selected
    item_selected = list{index_selected};

    %Delete this variable from the list.
    position = find(strcmp(handles.CatVarSelectedStr, item_selected));
    handles.CatVarSelectedStr (position) = [];
    %CatVarSelectedStr have the list of the variables.
    set(handles.listbox2, 'String', handles.CatVarSelectedStr, 'Value', 1);
    guidata(hObject, handles);
    %Pass the list at the program
    CatSelected = handles.CatVarSelectedStr;
    %assignin('caller', 'CatSelected', handles.CatVarSelectedStr);
else
    warndlg('Select a Variable on the right first!', 'Tree Classificatory Algorithm')
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global iExit;
iExit = 0;

close(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global iExit;
choice = questdlg('Exit ? It will stop the algorithm !', 'Tree Classificatory Algorithm');
% Handle response
switch choice 
    case 'Yes'
        iExit = -1;
        close(handles.figure1);
    otherwise 
        iExit = 0;
             
end
