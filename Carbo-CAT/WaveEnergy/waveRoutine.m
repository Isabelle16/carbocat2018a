function [glob] = waveRoutine(glob, subs, iteration) 
%% Calculates the wave energy distribution over the model area using a ray-tracing approach


%% Initialize params and arrays 
ySize = glob.ySize;
xSize = glob.xSize;
dx = glob.dx; % cell size
WD = glob.wd(:,:,iteration);
bathymetry = glob.strata(:,:,iteration);

% wind parameters
glob.windDir = [glob.yWind glob.xWind]; % initial incident ray vector component
winDir = glob.winDir;
dump = glob.dump; % dump (larger = wave energy decrease more steeply with depth)
extFetch = glob.extFetch*dx^2;

rho = 1024;        %water density kg/m^3  
g = 9.81;          %m/s^2

Ldeep = (g*glob.wavePeriod^2)/(2*pi); %Wave length in deep water (WD>L/2) 

fetchCell = dx^2; % fetch area of a single model cell (cell length*cell size)

% Define the axis length accordingly to the wind direction
if strcmp(winDir,'-y') 
    ortoAx = xSize; % length of the axis orthogonal to the wind propagation direction (also define the initial number of traced rays)
    parAx = ySize; % length of the axis that is parallel to the wind direction
    startRow = ySize; % coordinate along the wind parallel axis from which the rays will start propagating (defines the wave direction)
elseif strcmp(winDir,'+y') 
    ortoAx = xSize; % length of the axis orthogonal to the wind propagation direction (also define the initial number of traced rays)
    parAx = ySize; % length of the axis that is parallel to the wind direction
    startRow = 1; 
elseif strcmp(winDir,'-x') 
    ortoAx = ySize; % length of the axis orthogonal to the wind propagation direction (also define the initial number of traced rays)
    parAx = xSize; % length of the axis that is parallel to the wind direction
    startRow = xSize;
elseif strcmp(winDir,'+x') 
    ortoAx = ySize; % length of the axis orthogonal to the wind propagation direction (also define the initial number of traced rays)
    parAx = xSize; % length of the axis that is parallel to the wind direction
    startRow = 1;
end

% initialize arrays to record ray step params
glob.rayStep = zeros(ySize,xSize,ortoAx);
glob.rayComponent = zeros(ySize,xSize,ortoAx); %refracted ray components
glob.rayComponent = num2cell(glob.rayComponent);
glob.waveEnergy = zeros(ySize,xSize,ortoAx);
meanWaveEnergy = zeros(ySize,xSize);

% % % y = 1:ySize;
% % % x = 1:xSize;
% % % [x,y] = meshgrid(x,y);
% % % % Plot bathymetry and wind direction
% % % figure(1)
% % % surface(bathymetry);
% % % hold on
% % % q = quiver(25,100,V(2)*10,V(1)*10);
% % % q.LineWidth = 3;
% % % q.MaxHeadSize = 30;
% % % hold off

% % % %% Smooth bathymetry
% % % N = 3; % smoothing factor
% % % for i = 1:N
% % % smoothBathymetry = smooth2a(bathymetry,2,2);
% % % bathymetry = smoothBathymetry;
% % % end


% % % % plot smoothed bathymetry
% % % figure(2)
% % % surface(smoothBathymetry);

%% Calculate the surface local norm vector (correponding to the gradient vector)

% Calculate numerical gradient (2D)
[gx,gy] = gradient(bathymetry);

% gz = zeros(size(gy));
% % Plot gradient over the bathymetry
% figure(3)
% surface(bathymetry);
% hold on
% quiver3(bathymetry,gx,-gy,gz) 
% hold off

% Normalize the norm vector
gradMag = sqrt(gx.^2 + gy.^2); % magnitude of the gradient vector
gx = gx./gradMag;
gy = gy./gradMag;

gx(isnan(gx)) = 0; 
gy(isnan(gy)) = 0;

% % % figure(4)
% % % % contour(x,y,bathymetry)
% % % hold on
% % % quiver(x,y,gx,gy)
% % % hold on
% % % q = quiver(25,100,V(2)*10,V(1)*10);
% % % q.LineWidth = 3;
% % % q.MaxHeadSize = 30;
% % % % set(gca,'Ydir','reverse') %%!!!!!!!!!!!!!!!
% % % hold on

% % % figure(6)
% % % contour(x,y,bathymetry)
% % % hold on
% % % hh = pcolor(iAngleInit);
% % % alpha(hh,0.5)
% % % hh = colorbar;

%% Calculate ray-path and energy distribution
for i = 1:ortoAx
    
    % Initialize one ray tracing 
    yOut = startRow; % cell from which current ray tracing begins
    xOut = i; 
    step = 1; %ray propagation step
    rayDone = false;
    rowDone = false;
    waveBreak = false;
    % Initialize incident ray component (wind direction)
    xi = glob.windDir(2);
    yi = glob.windDir(1);
    dir = [yi,xi];
    Li = Ldeep; %wave length of the incidence wave (coming from outside model boundary, deep water)
    % calculate wavelength of the first cell
    [Lr] = calculateWaveLength(glob,g,WD,yOut,xOut,Ldeep,Li);
    % calculate wave energy
    fetch = fetchCell + extFetch;
    waveEnergy = 0;
    [~,waveEnergy,~] = calculateWaveEnergy(glob,g,rho,extFetch,WD,yOut,xOut,Li,waveEnergy);
    
    [iAngle,yi,xi] = calculateIncidenceAngle(gy,gx,startRow,i,yi,xi);
    
    
  while rowDone == false % this while loop ends when all the cell of the same row has been considered
        
     if WD(yOut,xOut) >= 0.1
        
           % calculate current cell wave height and energy density at the
           % sea level
           [~,waveEnergy,waveBreak] = calculateWaveEnergy(glob,g,rho,fetch,WD,yOut,xOut,Li,waveEnergy);

            % 1. calculate refraction angle
            [rAngle] = calculateRefractionAngle(iAngle,Li,Lr);
            
            Li = Lr;
            
            % 2. calculate the component of the refracted ray vector
            [xr,yr] = vectorRotation(rAngle,iAngle, xi, yi);
            
            % Record ray path step and refracted vector components in the
            % current cell
            
            if waveBreak == false
                    glob.rayStep(yOut,xOut,i) = step;
                    glob.rayComponent{yOut,xOut,i} = [yr xr];   
                    glob.waveEnergy(yOut,xOut,i) = waveEnergy;
            else
                for l = 1:glob.reefExtent
                    glob.waveEnergy(yOut,xOut,i) = waveEnergy;
                    glob.rayStep(yOut,xOut,i) = step;
                    glob.rayComponent{yOut,xOut,i} = [yr xr];
                    
                    yN = yOut + dir(1);
                    xN = xOut + dir(2);
                    
                  if yN <= ySize && yN > 0 && xN <= xSize...
                        && xN > 0 && WD(yN,xN) > 0.000 
                        yOut = yOut + dir(1);
                        xOut = xOut + dir(2);
                        step = step +1;
                  else
                      break
                    
                  end
                end
            end

            % 3. calculate destination cell accordingly to rAngle
            [yDest,xDest,dir] = calculateRayDestinationCell(yOut,xOut,yr,xr);           
            
            % Check destination cell
            [yOut,xOut,step,rayDone,rowDone] = checkDestCell(glob,yOut,xOut,yDest,xDest,ySize,xSize,step,rayDone,i,rowDone,WD,waveBreak,winDir);
            
%              % calculate current wavelength L
%             [Lr] = calculateWaveLength(glob,g,WD,yOut,xOut,Ldeep,Li);
            
            
            if rowDone == false && rayDone == false
             % calculate current wavelength L
            [Lr] = calculateWaveLength(glob,g,WD,yOut,xOut,Ldeep,Li);
            % 4. calculate new incidence angle and new components
            [iAngle,yi,xi] = calculateIncidenceAngle(gy,gx,yDest,xDest,yr,xr);
%             % calculate current wavelength L
%             [Lr] = calculateWaveLength(glob,g,WD,yOut,xOut,Ldeep,Li);
            fetch = fetch + fetchCell;
                
            elseif rowDone == false && rayDone == true
                xi = glob.windDir(2);
                yi = glob.windDir(1);
                [iAngle,yi,xi] = calculateIncidenceAngle(gy,gx,yOut,xOut,yi,xi);
                rayDone = false;
                waveBreak = false;
                Li = Ldeep; %wave length of the incidence wave (outside model boundary)
                % calculate wavelength of the first cell
                [Lr] = calculateWaveLength(glob,g,WD,yOut,xOut,Ldeep,Li);
                fetch = fetchCell;
                waveEnergy = 0;

            
            else % if rowDone == true
                break
            end
            
     else
            
        % Check next cell

        step = 1;
        xi = glob.windDir(2);
        yi = glob.windDir(1);
        [iAngle,yi,xi] = calculateIncidenceAngle(gy,gx,yOut,xOut,yi,xi);
        dir = [yi,xi];
        
        yOut = yOut + dir(1);
        xOut = xOut + dir(2);
        
        %check if we are at the model boundaries
        if yOut > ySize || yOut == 0 || xOut > xSize...
        || xOut == 0  
        rowDone = true; 
        
        else
        rayDone = false;
        Li = Ldeep; %wave length of the incidence wave (outside model boundary)
        % calculate wavelength of the first cell
        [Lr] = calculateWaveLength(glob,g,WD,yOut,xOut,Ldeep,Li);
        fetch = fetchCell;
        waveEnergy = 0;

        end
     end
     
    
   end % end current row

end % end main for loop



%% Calculate waveEnergy distribution at the sea bottom
% 1- sum the contribution of all rays
% glob.waveEnergy = sum(glob.waveEnergy,3);

% 2- average the contribution of all rays
for i = 1:ySize
    for j = 1: xSize
        
        meanWaveEnergy(i,j) = mean(nonzeros(glob.waveEnergy(i,j,:)));
        if isnan( meanWaveEnergy(i,j))
             meanWaveEnergy(i,j) = 0;
        end

    end
end

glob.waveEnergy =  meanWaveEnergy;

% wave energy that reach the sea bottom
for i = 1:ySize
    for j = 1: xSize
        if WD(i,j) <= glob.waveBase
            glob.waveEnergy(i,j) = glob.waveEnergy(i,j) * tanh(exp(-dump*WD(i,j)));
        else
            glob.waveEnergy(i,j) = 0;
        end

    end
end

% figure(15)
% aa = surface(-WD);
% aa.CData = glob.waveEnergy;

% %% Uniform smoothing of the wave Energy
% N = 4; % smoothing factor
% for i = 1:N
%     smoothedWaveEnergy = smooth2a(glob.waveEnergy,2,2);
%     glob.waveEnergy = smoothedWaveEnergy ;
% end


% figure(16)
% aa = surface(-WD);
% aa.CData = glob.waveEnergy;



% % % %% Uniformly smooth wave Energy
% % % N = 4; % smoothing factor
% % % a = glob.waveEnergy;
% % % for i = 1:N
% % % smoothedWaveEnergy = smooth2a(a,2,2);
% % % a = smoothedWaveEnergy ;
% % % end
% % % glob.waveEnergy = smoothedWaveEnergy;
% % % 

% %% Uniform normalization of wave energy over the whole model grid
% maxWave = max(max(glob.waveEnergy(:,:)));
% for i = 1:ySize
%     for j = 1:xSize
%         if glob.waveEnergy(i,j) > 0
%             glob.waveEnergy(i,j) = glob.waveEnergy(i,j)/maxWave;
%             
%         end
%     end
% end

% % % %% Differential smoothing and normalization of wave energy over the FW high
% % % dummyFWLocation = zeros(ySize,xSize);
% % % dummySub = subs.subsidence(:,:,iteration);
% % % refVal = dummySub(40,40); % Z VALUE WHERE THE SURFACE IS UNDEFORMED-------------------NB!!!!!!!!!!!!!!!!!!
% % % 
% % % dummyFWLocation(dummySub > refVal) = 1;
% % % 
% % % %% Differential smoothing of the wave Energy (FW isolated)
% % % N = 4; % smoothing factor
% % % FWdummy = glob.waveEnergy;
% % % FWdummy(dummyFWLocation==0) = NaN;
% % % HWdummy = glob.waveEnergy;
% % % HWdummy(dummyFWLocation==1) = NaN;
% % % 
% % % for i = 1:N
% % %     FWsmoothed = smooth2a(FWdummy,2,2);
% % %     FWdummy = FWsmoothed;
% % % end
% % % for i = 1:N
% % %     HWsmoothed = smooth2a(HWdummy,2,2);
% % %     HWdummy = HWsmoothed;
% % % end
% % % FWsmoothed(isnan(FWdummy)) = 0; 
% % % HWsmoothed(isnan(HWdummy)) = 0; 
% % % 
% % % smoothedWaveEnergy = FWsmoothed + HWsmoothed;
% % % glob.waveEnergy = smoothedWaveEnergy ;
% % % 
% % % %% Different normalization
% % % maxWave = max(max(glob.waveEnergy(dummyFWLocation == 0)));
% % % maxWaveFW = max(max(glob.waveEnergy(dummyFWLocation == 1)));
% % % 
% % % for i = 1:ySize
% % %     for j = 1:xSize
% % %         if glob.waveEnergy(i,j) > 0
% % %             if dummyFWLocation(i,j) == 0
% % %                 glob.waveEnergy(i,j) = glob.waveEnergy(i,j)/maxWave;
% % %             else
% % %                 glob.waveEnergy(i,j) = glob.waveEnergy(i,j)/maxWaveFW;
% % %             end
% % %         end
% % %     end
% % % end
% % % 
% % % 
% % % 
% % % 


% 
% figure(17)
% aa = surface(-WD);
% aa.CData = glob.waveEnergy;


%% Store results
glob.wave(:,:,iteration) = glob.waveEnergy;


% % % figure(14)
% % % for i = 1:ySize
% % %     for j = 1:xSize
% % %         if size(glob.rayComponent{i,j,10},2) > 1
% % %          quiver(i,j,glob.rayComponent{i,j,10}(1) ,glob.rayComponent{i,j,10}(2) )    
% % %          hold on   
% % %         end
% % % 
% % %     end
% % % end

% 
% figure(15)
% a = sum(glob.waveEnergy,3);
% aa = surf(bathymetry);
% aa = pcolor(a);  
% 
% % smooth wave Energy
% N = 4; % smoothing factor
% for i = 1:N
% smoothedWaveEnergy = smooth2a(a,2,2);
% a = smoothedWaveEnergy ;
% end
% 
% 
% figure(16)
% a = sum(glob.waveEnergy,3);
% surface(smoothedWaveEnergy)



end


