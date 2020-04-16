function varargout = maingui(varargin)
% MAINGUI MATLAB code for maingui.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before maingui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to maingui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help maingui

% Last Modified by GUIDE v2.5 10-Jul-2019 12:38:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @maingui_OpeningFcn, ...
                   'gui_OutputFcn',  @maingui_OutputFcn, ...
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


% --- Executes just before maingui is made visible.
function maingui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to maingui (see VARARGIN)

% Choose default command line output for maingui
handles.output = hObject;

a=ones([256 256]);
axes(handles.axes1);
imshow(a);

axes(handles.axes2);
imshow(a);

axes(handles.axes3);
imshow(a);



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes maingui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = maingui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in input.
function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
global inp Freg
cd input
[file path] = uigetfile('*.bmp;*.png;*.tif','Pick an Image File');


if isequal(file,0)
       warndlg('File not selected');
else

inp = imread(file);
cd ..
axes(handles.axes1);
imshow(inp);
img=inp;
if size(inp,3)>1
    Freg = rgb2gray(inp);                                                            
end
handles.img=img;
end
guidata(hObject, handles);

% --- Executes on button press in preprocess.
function preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  Freg input

input = imresize(Freg,[480 640]);
pcrop = imcrop(input,[180 180 250 250]);
Freg = imresize(pcrop,[256,256]);
axes(handles.axes2);
 imshow(Freg);



% --- Executes on button press in drltp.
function drltp_Callback(hObject, eventdata, handles)
% hObject    handle to drltp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Freg OpIm input
OpIm=DRLTP(Freg,3);
axes(handles.axes3);imshow(OpIm,[]);
input=imresize(input,[256 256])

% --- Executes on button press in swt.
function swt_Callback(hObject, eventdata, handles)
% hObject    handle to swt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%swt%%%%%
global Freg OpIm
[ll lh hl hh]=swt2(Freg,1,'sym2');
out=[ll lh;hl hh]
figure;
imshow(out,[]);
%%Gray level Co-occurance matrix 
 inp=uint8(ll);
 max_level = max(max(inp));
 min_level = min(min(inp));
 NLevels = max_level-min_level;
 
 Gmatrix = graycomatrix(inp,'NumLevels',NLevels,'GrayLimits',[min_level max_level]);
 GLCM = graycoprops(Gmatrix);
 
 cont = GLCM.Contrast;
 corr = GLCM.Correlation;
 En = GLCM.Energy;
 Homo =  GLCM.Homogeneity;
 QFeat =[cont;corr;En;Homo]; 


%Gray level Co-occurance matrix 
 inp1=uint8(OpIm);
 max_level1 = max(max(inp1));
 min_level1 = min(min(inp1));
 NLevels1 = max_level-min_level;
 
 Gmatrix1 = graycomatrix(inp1,'NumLevels',NLevels1,'GrayLimits',[min_level1 max_level1]);
 GLCM1 = graycoprops(Gmatrix1);
 
 cont1 = GLCM.Contrast;
 corr1 = GLCM.Correlation;
 En1 = GLCM.Energy;
 Homo1 =  GLCM.Homogeneity;
 QFeat1 =[cont;corr;En;Homo]; 
 outfin={QFeat,OpIm};
 
 handles.outfin=outfin;
 
helpdlg('Features extracted')

% Update handles structure
guidata(hObject, handles);
% --- Executes on button press in db.
function db_Callback(hObject, eventdata, handles)
% hObject    handle to db (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
database;
msgbox('Database loaded')


% --- Executes on button press in clasify.
function clasify_Callback(hObject, eventdata, handles)
% hObject    handle to clasify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%outfin=handles.outfin;
img=handles.img;
%inp=outfin;
inp=img;
load trainedNet.mat
im=imresize(inp,[227 227]);
Output = char(classify(net,im));
msgbox(Output);
