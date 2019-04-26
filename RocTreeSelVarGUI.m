function varargout = RocTreeSelVarGUI(varargin)
% ROCTREESELVARGUI M-file for RocTreeSelVarGUI.fig
%      ROCTREESELVARGUI, by itself, creates a new ROCTREESELVARGUI or raises the existing
%      singleton*.
%
%      H = ROCTREESELVARGUI returns the handle to a new ROCTREESELVARGUI or the handle to
%      the existing singleton*.
%
%      ROCTREESELVARGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROCTREESELVARGUI.M with the given input arguments.
%
%      ROCTREESELVARGUI('Property','Value',...) creates a new ROCTREESELVARGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RocTreeSelVarGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RocTreeSelVarGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RocTreeSelVarGUI

% Last Modified by GUIDE v2.5 19-Dec-2009 17:28:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RocTreeSelVarGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @RocTreeSelVarGUI_OutputFcn, ...
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


% --- Executes just before RocTreeSelVarGUI is made visible.
function RocTreeSelVarGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RocTreeSelVarGUI (see VARARGIN)

% Choose default command line output for RocTreeSelVarGUI
handles.output = hObject;


global iExit;
global textdata;
VarNames = textdata;
%VarNames = evalin ('caller', 'textdata');
%Drop the outcome name
VarNames (1) = [];

set(handles.listbox1, 'String', VarNames, 'Value', 1);


%Inizialize variable contain a cell array of the variable selected
handles.UsedVariablesStr = VarNames;
handles.VarNames = VarNames;
handles.HasBeenSelected = 0;
handles.HasBeenSelected2 = 0;


set(handles.listbox2, 'String', VarNames, 'Value', 1);

% Update handles structure
guidata(hObject, handles);


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


% UIWAIT makes RocTreeSelVarGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RocTreeSelVarGUI_OutputFcn(hObject, eventdata, handles) 
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

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
index_selected = get(hObject,'Value');

%Return a list of variable in string cell array string
list = get(hObject,'String');
handles.HasBeenSelected=1; 

%Return a cell array of variable selected
item_selected = list{index_selected};
%Gui data
handles.VarSelectedStr = list{index_selected};

%assignin('base', 'selected', index_selected);
%assignin('base', 'VarSelectedStr', item_selected);
guidata(hObject, handles);


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


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
handles.HasBeenSelected2=1; 
index_selected = get(hObject,'Value');

%Return a list of variable in string cell array string
list = get(hObject,'String');

%Return a cell array of variable selected
item_selected = list{index_selected};
%Gui data
handles.VarSelectedStr = list{index_selected};
guidata(hObject, handles);

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


% --- Executes on button press in pushbutton1 = ADD A VARIABLE
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%VarNames = evalin ('base', 'VarSelectedStr');

%Test is almost one's variable has been selected
%Else do nothing.
if handles.HasBeenSelected == 1
    %Find if the string with that name is present in VarSelectedStr
    %If it is an empty matrix add the string
    if isempty(find (strcmp(handles.UsedVariablesStr, handles.VarSelectedStr))) 
        %Length of the array of the selected variables
        selectedlength = length(handles.UsedVariablesStr);
        %Find the position in the List of Total Variables 
        elementposition = find (strcmp(handles.VarNames, handles.VarSelectedStr));
        if elementposition == 1
            TempArray = cellstr(handles.VarSelectedStr);
            TempArray(1, 2:selectedlength+1) = handles.UsedVariablesStr (1,1:selectedlength);
        else
            if elementposition == (selectedlength+1)
                TempArray = handles.UsedVariablesStr;
                TempArray(selectedlength+1) = cellstr(handles.VarSelectedStr);
            else
                if elementposition <= selectedlength
                    TempArray (1:elementposition-1) = handles.UsedVariablesStr (1:elementposition-1);
                    TempArray (elementposition) = cellstr(handles.VarSelectedStr);
                    TempArray (elementposition+1:selectedlength+1) = handles.UsedVariablesStr (elementposition:selectedlength);
                else
                    TempArray = handles.UsedVariablesStr;
                    TempArray(selectedlength+1) = cellstr(handles.VarSelectedStr);
                end
            end
        end
                     
       %Copy Temp to Used 
       handles.UsedVariablesStr = TempArray;
                
  
    end
    
    %Fill ListBox and set position to 1  
    set(handles.listbox2, 'String', handles.UsedVariablesStr, 'Value', 1);
    %Set VarSelectedStr to position 1, otherwise if you push Remove button
    %it take the variable stored to VarSelectedStr, a random choice in this
    %point of the program.
    handles.VarSelectedStr = handles.UsedVariablesStr(1);

else
    warndlg('Select a variable on the left first', 'Tree Classificatory Algorithm')
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton2 = REMOVE A VARIABLE
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%If the variables is not selected do nothing.
if handles.HasBeenSelected2 == 1
    
    %Added
    index_selected = get(handles.listbox2,'Value');

    %Return a list of variable in string cell array string
    list = get(handles.listbox2,'String');


    %Return a cell array of variable selected
    handles.VarSelectedStr = list{index_selected};

    
    
    %Delete this variable from the list.
    position = find(strcmp(handles.UsedVariablesStr, handles.VarSelectedStr));
    handles.UsedVariablesStr (position) = [];
    
    set(handles.listbox2, 'String', handles.UsedVariablesStr, 'Value', 1);
   
    %Pass the list at the program
    
    %assignin('caller', 'sSelectedVariables', handles.UsedVariablesStr);
else
    warndlg('Select a variable on the rigth first', 'Tree Classificatory Algorithm')
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global iExit;
global sSelectedVariables;
iExit = 0;

%Save the contents of the variables
sSelectedVariables = handles.UsedVariablesStr;

close(handles.figure1);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
