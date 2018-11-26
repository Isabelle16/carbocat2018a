function varargout = makeSeaLevelCurve(varargin)
% CALCSEALEVELCURVE M-file for calcSeaLevelCurve.fig
%      CALCSEALEVELCURVE, by itself, creates a new CALCSEALEVELCURVE or raises the existing
%      singleton*.
%
%      H = CALCSEALEVELCURVE returns the handle to a new CALCSEALEVELCURVE or the handle to
%      the existing singleton*.
%
%      CALCSEALEVELCURVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCSEALEVELCURVE.M with the given input arguments.
%
%      CALCSEALEVELCURVE('Property','Value',...) creates a new CALCSEALEVELCURVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before makeSeaLevelCurve_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to makeSeaLevelCurve_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help calcSeaLevelCurve

    % Last Modified by GUIDE v2.5 20-Sep-2009 11:07:45
    
        
   
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @makeSeaLevelCurve_OpeningFcn, ...
                       'gui_OutputFcn',  @makeSeaLevelCurve_OutputFcn, ...
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

end

    % --- Executes just before calcSeaLevelCurve is made visible.
    function makeSeaLevelCurve_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to calcSeaLevelCurve (see VARARGIN)
  
        % Declate structure sea as global
        % Note - don't really understand why, but to be both visible and modifiable
        % in callbacks, sea should be declared here and not in the initiation above
        % Perhaps something to do with the level of the functions involved??
        global sea;
   
        % Define structure sea
        sea.fileName = 'params\seaLevel.txt';
        sea.modelIterations = 200;
        sea.deltaT = 0.001;
        sea.curveType = 1;
        sea.amp1 = 20;
        sea.period1 = 0.115;
        sea.amp2 = 10;
        sea.period2 = 0.60;
        sea.amp3 = 5;
        sea.period3 = 0.25;
        sea.randomMin = -10;
        sea.randomMax = 10;
    
        % Choose default command line output for calcSeaLevelCurve
        handles.output = hObject;
        % Update handles structure
        guidata(hObject, handles);
   
        % UIWAIT makes calcSeaLevelCurve wait for user response (see UIRESUME)
        % uiwait(handles.figure1);
    end

    % --- Outputs from this function are returned to the command line.
    function varargout = makeSeaLevelCurve_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

        % Get default command line output from handles structure
        varargout{1} = handles.output;
    end

    % --- Executes on button press in calcSeaLevelCurve.
    function calcSeaLevelCurve_Callback(hObject, eventdata, handles)
    % hObject    handle to calcSeaLevelCurve (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        global sea;
        
        sea.curveArray = zeros(sea.modelIterations,1);
        
        emt = sea.deltaT;
        
        for i=1:sea.modelIterations
            
            sea.curveArray(i) = (sin((pi()*2)*(emt / sea.period1)) * sea.amp1) + ...
                (sin((pi()*2)*(emt / sea.period2)) * sea.amp2) + ...
                (sin((pi()*2)*(emt / sea.period3)) * sea.amp3);
        
            
            emt = emt + sea.deltaT;
        end
        
        axis ij;
        plot(sea.curveArray);
    end


    % --- Executes on button press in saveSeaLevelCurve.
    function saveSeaLevelCurve_Callback(hObject, eventdata, handles)
    % hObject    handle to saveSeaLevelCurve (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        global sea;
        
       
        seaLevelOutput = fopen(sea.fileName,'w');
        emt = sea.deltaT;
        
        for i=1:sea.modelIterations
            fprintf(seaLevelOutput,'%5.4f %4.3f\n', emt, sea.curveArray(i));
            emt = emt + sea.deltaT;
        end
        
        fclose(seaLevelOutput);
    
    end


    function amplitude1_Callback(hObject, eventdata, handles)
    % hObject    handle to amplitude1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of amplitude1 as text
        %        str2double(get(hObject,'String')) returns contents of amplitude1 as a double
        
        global sea;
        sea.amp1 = str2double(get(hObject,'String'));
        
    end

    % --- Executes during object creation, after setting all properties.
    function amplitude1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to amplitude1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

        % Hint: edit controls usually have a white background on Windows.
        %       See ISPC and COMPUTER.
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end


    function period1_Callback(hObject, eventdata, handles)
    % hObject    handle to period1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of period1 as text
        %        str2double(get(hObject,'String')) returns contents of period1 as a double
        global sea;
        sea.period1 = str2double(get(hObject,'String'));
    end

    % --- Executes during object creation, after setting all properties.
    function period1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to period1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

        % Hint: edit controls usually have a white background on Windows.
        %       See ISPC and COMPUTER.
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end


    function amplitude2_Callback(hObject, eventdata, handles)
    % hObject    handle to amplitude2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of amplitude2 as text
        %        str2double(get(hObject,'String')) returns contents of amplitude2 as a double
        global sea;
        sea.amp2 = str2double(get(hObject,'String'));
        
    end

    % --- Executes during object creation, after setting all properties.
    function amplitude2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to amplitude2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

        % Hint: edit controls usually have a white background on Windows.
        %       See ISPC and COMPUTER.
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end


    function period2_Callback(hObject, eventdata, handles)
    % hObject    handle to period2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of period2 as text
        %        str2double(get(hObject,'String')) returns contents of period2 as a double
         global sea;
        sea.period2 = str2double(get(hObject,'String'));
        
    end

    % --- Executes during object creation, after setting all properties.
    function period2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to period2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

        % Hint: edit controls usually have a white background on Windows.
        %       See ISPC and COMPUTER.
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end


    function amplitude3_Callback(hObject, eventdata, handles)
    % hObject    handle to amplitude3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of amplitude3 as text
        %        str2double(get(hObject,'String')) returns contents of amplitude3 as a double
        global sea;
        sea.ampl3 = str2double(get(hObject,'String'));
        
    end

    % --- Executes during object creation, after setting all properties.
    function amplitude3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to amplitude3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

        % Hint: edit controls usually have a white background on Windows.
        %       See ISPC and COMPUTER.
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end


    function period3_Callback(hObject, eventdata, handles)
    % hObject    handle to period3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

        % Hints: get(hObject,'String') returns contents of period3 as text
        %        str2double(get(hObject,'String')) returns contents of period3 as a double
         global sea;
        sea.period3 = str2double(get(hObject,'String'));
        
    end

    % --- Executes during object creation, after setting all properties.
    function period3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to period3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

        % Hint: edit controls usually have a white background on Windows.
        %       See ISPC and COMPUTER.
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end


    function randomWalkMin_Callback(hObject, eventdata, handles)
    % hObject    handle to randomWalkMin (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

        
         global sea;
         sea.randomMin = str2double(get(hObject,'String'));
    end

    % --- Executes during object creation, after setting all properties.
    function randomWalkMin_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to randomWalkMin (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

        
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end



    function randomWalkMax_Callback(hObject, eventdata, handles)
    % hObject    handle to randomWalkMax (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

        
         global sea;
         sea.randomMax = str2double(get(hObject,'String'));
        
    end

    % --- Executes during object creation, after setting all properties.
    function randomWalkMax_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to randomWalkMax (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

       
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end

    function seaLevelFilename_Callback(hObject, eventdata, handles)
    % hObject    handle to seaLevelFilename (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

        global sea;
        sea.fileName = get(hObject,'String');
    end

    % --- Executes during object creation, after setting all properties.
    function seaLevelFilename_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to seaLevelFilename (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end

    function modelIterations_Callback(hObject, eventdata, handles)
    % hObject    handle to modelIterations (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        global sea;
        sea.modelIterations = str2double(get(hObject,'String'));
    end

    % --- Executes during object creation, after setting all properties.
    function modelIterations_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to modelIterations (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end


    function deltaT_Callback(hObject, eventdata, handles)
    % hObject    handle to deltaT (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        global sea;
        sea.deltaT = str2double(get(hObject,'String'));
        
    end

    % --- Executes during object creation, after setting all properties.
    function deltaT_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to deltaT (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

        % Hint: edit controls usually have a white background on Windows.
        %       See ISPC and COMPUTER.
        if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
            set(hObject,'BackgroundColor','white');
        end
    end


% --- Executes on button press in sinusoidalZero.
function sinusoidalZero_Callback(hObject, eventdata, handles)
% hObject    handle to sinusoidalZero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sinusoidalZero
global sea;
if get(hObject,'Value')== 1 sea.curveType = 1; end
%fprintf('Curve type updated to %d\n', sea.curveType);
end

% --- Executes on button press in sinusoidalMax.
function sinusoidalMax_Callback(hObject, eventdata, handles)
% hObject    handle to sinusoidalMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sinusoidalMax
global sea;
if get(hObject,'Value')== 1 sea.curveType = 2; end
%fprintf('Curve type updated to %d\n', sea.curveType);
end

% --- Executes on button press in sinusoidalMin.
function sinusoidalMin_Callback(hObject, eventdata, handles)
% hObject    handle to sinusoidalMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sea;
if get(hObject,'Value')== 1 sea.curveType = 3; end

end

% --- Executes on button press in randomWalk.
function randomWalk_Callback(hObject, eventdata, handles)
% hObject    handle to randomWalk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sea;
if get(hObject,'Value')== 1 sea.curveType = 4; end

end

% --- Executes on button press in randomWalkMinMax.
function randomWalkMinMax_Callback(hObject, eventdata, handles)
% hObject    handle to randomWalkMinMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sea;
if get(hObject,'Value')== 1 sea.curveType = 5; end

end





