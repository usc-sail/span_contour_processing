function varargout = tvlocs(varargin)
% TVLOCS - MATLAB code for tvlocs.fig
%      TVLOCS, by itself, creates a new TVLOCS or raises the existing
%      singleton*. TVLOCS is used to manually annotate the phonetic places
%      of articulation
% 
% INPUT:
%  Variable name: configStruct
%  Size: 1x1
%  Class: struct
%  Description: Fields correspond to constants and hyperparameters. 
%  Fields: 
%  - outPath: (string) path for saving MATLAB output
%  - aviPath: (string) path to the AVI files
%  - graphicsPath: (string) path to MATALB graphical output
%  - trackPath: (string) path to segmentation results
%  - manualAnnotationsPath: (string) path to manual annotations
%  - timestamps_file_name_<dataset>: (string) file name with path of 
%      timestamps file name for each data-set <dataset> of the analysis
%  - folders_<dataset>: (cell array) string folder names which belong to 
%      each data-set <dataset> of the analysis
%  - tasks: (cell array) string identifiers for different tasks
%  - FOV: (double) size of field of view in mm^2
%  - Npix: (double) number of pixels per row/column in the imaging plane
%  - framespersec_<dataset>: (double) frame rate of reconstructed real-time
%      magnetic resonance imaging videos in frames per second for each 
%      data-set <dataset> of the analysis
%  - ncl: (double array) entries are (i) the number of constriction 
%      locations at the hard and soft palate and (ii) the number of 
%      constriction locations at the hypopharynx (not including the 
%      nasopharynx).
%  - f: (double) hyperparameter which determines the percent of data used 
%      in locally weighted linear regression estimator of the jacobian; 
%      multiply f by 100 to obtain the percentage
%  - verbose: controls non-essential graphical and text output
%  
%  Variable name: dataset
%  Size: arbitrary
%  Class: char
%  Description: determines which data-set to analyze; picks out the
%  appropriate constants from configStruct.
% 
% FUNCTION OUTPUT: 
%  none
% 
% SAVED OUTPUT: 
%  Path: configStruct.manualAnnotationsPath
%  File name: tvlocs_<dataset>.mat
%  Variable name: tvlocs 
%  Size: 1x1
%  Class: struct
%  Description: Struct with fields for each subject (field name is subject ID, e.g., 'at1_rep'). The fields are structs with the following fields.
%  Fields: 
%  - pharL: lower (hypo-)pharynx
%  - pharU: upper (naso-)pharynx
%  - alv: alveolar ridge (i.e., coronal place)
%  - pal: hard palate
%  - softpal: soft palate
%  The fields for place of articulation are structs with the following fields:
%  - start: index of the vertex start of the place of articulation along the contour
%  - stop: index of the vertex end of the place of articulation along the contour
%  - aux: contour ID(s) on which the place of articulation exists (07: pharynx; 11: hard palate; 12: soft palate)
% 
% EXAMPLE USAGE:
%
%      H = TVLOCS returns the handle to a new TVLOCS or the handle to
%      the existing singleton*.
%
%      TVLOCS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TVLOCS.M with the given input arguments.
%
%      TVLOCS('Property','Value',...) creates a new TVLOCS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tvlocs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tvlocs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% SEE ALSO:
%  GUIDE, GUIDATA, GUIHANDLES
% 
% Tanner Sorensen
% Signal Analysis and Interpretation Laboratory
% Apr. 14, 2017

% Edit the above text to modify the response to help tvlocs

% Last Modified by GUIDE v2.5 09-Mar-2016 14:03:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tvlocs_OpeningFcn, ...
                   'gui_OutputFcn',  @tvlocs_OutputFcn, ...
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

% --- Executes just before tvlocs is made visible.
function tvlocs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tvlocs (see VARARGIN)

% Choose default command line output for tvlocs
configStruct = varargin{1};

load(fullfile(configStruct.outPath,'contourdata.mat'))

handles.output = hObject;
handles.configStruct = configStruct;
handles.contourdata = contourdata;
handles.folder = configStruct.folders;
for i=1:length(handles.folder)
    handles.tvlocs.(handles.folder{i}) = struct();
end

set(handles.popupmenu1, 'String', handles.folder);

% Update handles structure
guidata(hObject, handles);

% % This sets up the initial plot - only do when we are invisible
% % so window can get raised using tvlocs.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end

% UIWAIT makes tvlocs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tvlocs_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

% load(fullfile(handles.outPath,'contourdata.mat'))
contourdata = handles.contourdata;
popup_sel_index = get(handles.popupmenu1, 'Value');
folder = get(handles.popupmenu1, 'String');

fl = dir(fullfile(handles.configStruct.aviPath,folder{popup_sel_index},'avi'));
fl = {fl.name};
fl = fl(3:end); % exclude '.', '..', which are always initial
v = VideoReader(fullfile(handles.configStruct.aviPath,...
    folder{popup_sel_index},'avi',fl{randi(length(fl))}));
frame_index = randi(round(v.Duration*v.FrameRate));
v.CurrentTime = frame_index/v.FrameRate;
width = v.Width;
imshow(mat2gray(readFrame(v)), 'XData',[-(width-1)/2 (width-1)/2],...
    'YData',[-(width-1)/2 (width-1)/2],'Border','tight','InitialMagnification',500); hold on;
axis tight, axis equal

guidata(hObject,handles);

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', 'DUMMY');


% --- Executes on button press in pharL_button.
function pharL_button_Callback(hObject, eventdata, handles)
% hObject    handle to pharL_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pharID = [7 8];

[x,y] = getpts(handles.figure1);
y = -y; % figure is inverted across the x-axis compared to contours

% load(fullfile(handles.outPath,'contourdata.mat'))
contourdata = handles.contourdata;
popup_sel_index = get(handles.popupmenu1, 'Value');
folder = get(handles.popupmenu1, 'String');
sectionsID = contourdata.(folder{popup_sel_index}).SectionsID;

X = median(contourdata.(folder{popup_sel_index}).X(:,ismember(sectionsID,pharID)));
Y = median(contourdata.(folder{popup_sel_index}).Y(:,ismember(sectionsID,pharID)));

[~,start] = min(sqrt((X-x(1)).^2+(Y-y(1)).^2));
[~,stop] = min(sqrt((X-x(2)).^2+(Y-y(2)).^2));

folder = get(handles.popupmenu1,'String');
indx = get(handles.popupmenu1,'Value');
handles.tvlocs.(folder{indx}).pharL.start = start;
handles.tvlocs.(folder{indx}).pharL.stop = stop;
handles.tvlocs.(folder{indx}).pharL.aux = pharID;

guidata(hObject,handles);


% --- Executes on button press in pharU_button.
function pharU_button_Callback(hObject, eventdata, handles)
% hObject    handle to pharU_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pharID = [7 8];

[x,y] = getpts(handles.figure1);
y = -y; % figure is inverted across the x-axis compared to contours

% load(fullfile(handles.outPath,'contourdata.mat'))
contourdata = handles.contourdata;
popup_sel_index = get(handles.popupmenu1, 'Value');
folder = get(handles.popupmenu1, 'String');
sectionsID = contourdata.(folder{popup_sel_index}).SectionsID;

X = median(contourdata.(folder{popup_sel_index}).X(:,ismember(sectionsID,pharID)));
Y = median(contourdata.(folder{popup_sel_index}).Y(:,ismember(sectionsID,pharID)));

[~,start] = min(sqrt((X-x(1)).^2+(Y-y(1)).^2));
[~,stop] = min(sqrt((X-x(2)).^2+(Y-y(2)).^2));

folder = get(handles.popupmenu1,'String');
indx = get(handles.popupmenu1,'Value');
handles.tvlocs.(folder{indx}).pharU.start = start;
handles.tvlocs.(folder{indx}).pharU.stop = stop;
handles.tvlocs.(folder{indx}).pharU.aux = pharID;

guidata(hObject,handles);

% --- Executes on button press in alv_button.
function alv_button_Callback(hObject, eventdata, handles)
% hObject    handle to alv_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
alvID = 11;

[x,y] = getpts(handles.figure1);
y = -y; % figure is inverted across the x-axis compared to contours

% load(fullfile(handles.outPath,'contourdata.mat'))
contourdata = handles.contourdata;
popup_sel_index = get(handles.popupmenu1, 'Value');
folder = get(handles.popupmenu1, 'String');
sectionsID = contourdata.(folder{popup_sel_index}).SectionsID;

X = median(contourdata.(folder{popup_sel_index}).X(:,sectionsID==alvID));
Y = median(contourdata.(folder{popup_sel_index}).Y(:,sectionsID==alvID));

[~,start] = min(sqrt((X-x(1)).^2+(Y-y(1)).^2));
[~,stop] = min(sqrt((X-x(2)).^2+(Y-y(2)).^2));

folder = get(handles.popupmenu1,'String');
indx = get(handles.popupmenu1,'Value');
handles.tvlocs.(folder{indx}).alv.start = start;
handles.tvlocs.(folder{indx}).alv.stop = stop;
handles.tvlocs.(folder{indx}).alv.aux = 11;

guidata(hObject,handles);

% --- Executes on button press in pal_button.
function pal_button_Callback(hObject, eventdata, handles)
% hObject    handle to pal_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
palID = 11;

[x,y] = getpts(handles.figure1);
y = -y; % figure is inverted across the x-axis compared to contours

% load(fullfile(handles.outPath,'contourdata.mat'))
contourdata = handles.contourdata;
popup_sel_index = get(handles.popupmenu1, 'Value');
folder = get(handles.popupmenu1, 'String');
sectionsID = contourdata.(folder{popup_sel_index}).SectionsID;

X = median(contourdata.(folder{popup_sel_index}).X(:,sectionsID==palID));
Y = median(contourdata.(folder{popup_sel_index}).Y(:,sectionsID==palID));

[~,start] = min(sqrt((X-x(1)).^2+(Y-y(1)).^2));
[~,stop] = min(sqrt((X-x(2)).^2+(Y-y(2)).^2));

folder = get(handles.popupmenu1,'String');
indx = get(handles.popupmenu1,'Value');
handles.tvlocs.(folder{indx}).pal.start = start;
handles.tvlocs.(folder{indx}).pal.stop = stop;
handles.tvlocs.(folder{indx}).pal.aux = 11;

guidata(hObject,handles);

% --- Executes on button press in softpal_button.
function softpal_button_Callback(hObject, eventdata, handles)
% hObject    handle to softpal_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
velID = 12;

[x,y] = getpts(handles.figure1);
y = -y; % figure is inverted across the x-axis compared to contours

% load(fullfile(handles.outPath,'contourdata.mat'))
contourdata = handles.contourdata;
popup_sel_index = get(handles.popupmenu1, 'Value');
folder = get(handles.popupmenu1, 'String');
sectionsID = contourdata.(folder{popup_sel_index}).SectionsID;

X = median(contourdata.(folder{popup_sel_index}).X(:,sectionsID==velID));
Y = median(contourdata.(folder{popup_sel_index}).Y(:,sectionsID==velID));

[~,start] = min(sqrt((X-x(1)).^2+(Y-y(1)).^2));
[~,stop] = min(sqrt((X-x(2)).^2+(Y-y(2)).^2));

folder = get(handles.popupmenu1,'String');
indx = get(handles.popupmenu1,'Value');
handles.tvlocs.(folder{indx}).softpal.start = start;
handles.tvlocs.(folder{indx}).softpal.stop = stop;
handles.tvlocs.(folder{indx}).softpal.aux = 12;

guidata(hObject,handles);


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tvlocs = handles.tvlocs;
save(fullfile(handles.configStruct.manualAnnotationsPath,'tvlocs.mat'), 'tvlocs')


% --- Executes on button press in print_button.
function print_button_Callback(hObject, eventdata, handles)
% hObject    handle to print_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axID = handles.axes1;
figID = handles.figure1;
fnam = 'test.pdf';
printPDF(axID,figID,fnam)
