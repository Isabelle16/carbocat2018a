function varargout = paramsGUI(varargin)
% PARAMSGUI M-file for paramsGUI.fig
%      PARAMSGUI, by itself, creates a new PARAMSGUI or raises the existing
%      singleton*.
%
%      H = PARAMSGUI returns the handle to a new PARAMSGUI or the handle to
%      the existing singleton*.
%
%      PARAMSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMSGUI.M with the given input arguments.
%
%      PARAMSGUI('Property','Value',...) creates a new PARAMSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before paramsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to paramsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help paramsGUI

% Last Modified by GUIDE v2.5 27-Sep-2008 12:47:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @paramsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @paramsGUI_OutputFcn, ...
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


% --- Executes just before paramsGUI is made visible.
function paramsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to paramsGUI (see VARARGIN)

% Choose default command line output for paramsGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes paramsGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = paramsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
