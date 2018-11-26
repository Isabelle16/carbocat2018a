function calculateSyntheticSeismicGA3(glob, iteration, xPos)
%calculates synthetic seismics along the platform at the given x position
%It uses the models from runCAModelGUI, a zero phase Ricker wavelet, facies density and velocity.

%All the accommodation space is filled with shale, so the topography is flatend.  The pack of carbonates
%and shale is buried under a 100m  thick layer of shale. All the shale is
%perfectly homogeneous

%Below the carbonates a perfectly homogeneous layer of basement rocks are
%assumed. 

% Reflectors are limited at the boundary shale/carbonates, between the carbonates and at the boundary carbonates/basement

% It calculates synthetics from 1D convolution of the wavelet with the impedance of the facies

lu=1500; %length unit;

%zero-phase Ricker wavelet
freq=200;            %central frequency
n=100;                %number of points
t_sampling=10^-3;    %sampling time
t0=2/freq;           %peak location

wavelet=ricker(freq,n,t_sampling,t0);

%Calculate depth, Vp, Vs and density for each layer along the platform

geo = zeros(glob.ySize,lu,5);
for y = 1:glob.ySize
    wlog = createVerticalSuccession(glob, iteration, xPos, y,lu);
    
    geo(y,:,:)=wlog;
   
end

%Calculate AI and trave time along the platform for the whole
%shale-carbonate-basement unit
[travelTime,refl] = log2reflectivity(geo);


%Calculate the synthetic seismic trace
seis =zeros(size(geo,1),(size(geo,2)+length(wavelet))-1);
seis2 =zeros(size(geo,1),(size(geo,2)+length(wavelet))-1);
for i=1:size(geo,1)% 1:glob.ySize
    seis(i,:) = conv(wavelet,refl(i,:));
end

%Clip the lower values
for i=1:size(seis,1)% 1:glob.ySize
    for j=1:size(seis,2)
        if abs(seis(i,j)) <10^-4
            seis2(i,j)=0;
        else
            seis2(i,j) = seis(i,j);
        end
    end
end

[row,~]=find(seis2>0);
long=max(row);

[~,col]=find(seis2>0);
deep=max(col);


%Plot the synthetic seismic
minAmpl=min(seis2(:));
maxAmpl=max(seis2(:));

figure,
for o=1:long%size(seis2,1)% %along y axis
    for z=1:deep%size(seis2,2)% %depth
        if seis2(o,z)==0
            color=[1,1,1];
        elseif seis2(o,z)>0
            ra=seis2(o,z)/maxAmpl;
            color=[1,1-ra,1-ra];
        else
            ra=seis2(o,z)/minAmpl;
            color=[1-ra,1-ra,1-ra];
        end
        
       yco=[travelTime(o,z),travelTime(o,z),travelTime(o,z+1),travelTime(o,z+1)];
       xco=[o,o+1,o+1,o];
       patch(xco,yco,color,'EdgeColor','none');
    end
end

xtk=get(gca,'YTick');
xtknew=xtk*1000;
set(gca,'YTick',xtk,'YTickLabel',xtknew);
set (gca,'Ydir','reverse');
xlabel('Distance (km)');
ylabel('TWT (ms)');


%---functions---------------------------------------------------------------------------------------------
%Zero phase Ricker wavelet
    function [s,t] = ricker(f,n,dt,t0)

T = dt*(n-1);
t = 0:dt:T;
tau = t-t0;

    s = (1-tau.*tau*f^2*pi^2).*exp(-tau.^2*pi^2*f^2);
end  

%Calculate depth, Vp, Vs and density for each layer along the platform
function wlog = createVerticalSuccession(glob, iteration, x ,y,lu)

   
     faciesDT = [172.4 165.6 160.7 155.3 170.0 163.0 157.0 152.0 150.0]; %Internal transit time values for in-situ facies (1-4), transported facies (5-8) and exposed facies (9).
     %Max dt7=800 for the Vs to come out positive
     
     faciesPor = [0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0]; %Porosity values for each facies (0-no porosity, 1-100% porosity)
     matrixDensity = [2800 2700 2600 2500 2750 2650 2550 2450 5000]; %Matrix density (kg/m^3)
     fluidDensity = [0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0]; % Fluid density (kg/m^3)
     
     faciesDensity = ((1-faciesPor) .* matrixDensity) + (faciesPor .* fluidDensity); %The density of each carbonate facies

        
    j=1; % Index for the arrays to go into the log curve
    
    % Create some synthetic overburden - just a layer of shale on top of the carbonate platform 
    overburdenThick = 100 + abs(floor(glob.strata(y,x,glob.totalIterations))); 
    

    % Depth array contains the depth to the top of the unit
    for j=1:overburdenThick
        depth(j) = j-1; %The depth from the top of the unit
        dt(j) = 333.3;  % A dt interval transit time for the overburden in microseconds per meter (smaller dt, higher vp)
        vp(j) = 1.0e6./dt(j);  % Vp is just 1.000.000 microseconds divided by dt.
        rho(j) = 2400; %Density of shale (kg/m^3)
    end
    
    j=j+1;

% Starting from the top of the carbonate strata, going downwards with increasing depth
   
    for k = iteration:-1:2 
        
        cell=glob.numberOfLayers(y,x,k); %number of layers on the cell
 
         while cell > 0 
             
            fCode = glob.facies{y,x,k}(cell); %read the facies 
            oneThickness = sum(glob.thickness{y,x,k}(cell)); %the thickness of the deposited facies
            depth(j) = depth(j-1)+oneThickness; 
            dt(j) = faciesDT(fCode);  % The interval transit time in microseconds per meter
            vp(j) = 1.0e6./dt(j);  % Vp is just 1.000.000 microseconds divided by dt, assuming dt is in microseconds per meter
            rho(j) = faciesDensity(fCode); % The density of the carbonate facies (kg/m^3)

            j = j + 1;
            cell = cell-1;
        end;

  
    end
       
%The basement below the carbonates
    baseCarbonates = depth(j-1);

    topBasementIndex = j;
    k = 1;
    
    % Create some synthetic basement - generic hard fast rock
    for j=topBasementIndex:lu
        depth(j) = baseCarbonates + k;
        dt(j) = 128.2 ;  % Assumes a dt interval transit time of 50 microseconds per meter
        vp(j) = 1.0e6./dt(j);  % Vp is just 1.000.000 microseconds divided by dt, assuming dt is in microseconds per meter
        rho(j)= 3000; %Density of basement (kg/m^3)
        
        k = k + 1;
    end
  
    %	Create log curves
    curves=zeros(ceil(j),5); 
    curves(:,1)=depth; %depth
    curves(:,2)=dt; %Transit time 
    curves(:,3)=vp; %P-wave velocity
    curves(:,4) = 0.8620*curves(:,3)-1072; %S-wave velocity CastangaEtAl,1985

    curves(:,5)= rho; %Density
            
%     curves(:,5)=0.23*curves(:,3).^0.25 ; % Density. Gardners eq. Vp in ft/s. The term + 0.02 is a modification from the writer
%     curves(:,5)=0.31*curves(:,3).^0.25 ; % Density. Gardners eq. Vp in m/sec. The term + 0.02 is a modification from the writer


wlog = curves;

end



%calculate AI and two way travel time from the depth, velocity and density
%of each facies 
function [travelTime,refl] = log2reflectivity (geo)

refl=zeros(size(geo,1),size(geo,2)); 
oneWay =zeros(size(geo,1),size(geo,2)); 
travelTime =zeros(size(geo,1),size(geo,2));
travelTime(:,1)=2*geo(1,2,1)/geo(1,1,3);
    

    for y=1:size(geo,1)
       for l=2:size(geo,2)%the whole shale-carbonate-basement package
            
          oneWay(y,l) = (geo(y,l,1)-geo(y,l-1,1))/geo(y,l,3); %one way travel time
          travelTime(y,l) =  travelTime(y,l-1)+2*oneWay(y,l);%two ways travel time 
          refl(y,l) = ((geo(y,l,3).*geo(y,l,5))-(geo(y,l-1,3).*geo(y,l-1,5)))/((geo(y,l,3).*geo(y,l,5))+(geo(y,l-1,3).*geo(y,l-1,5))); %AI
         
       end
    end
        
end

 
end 

