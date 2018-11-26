function [glob,pltf] = calculateSedimentRedistribution(glob, iteration)

%% Calculate platform shear stress
[pltf] = calculatePlatformShearStress (glob, iteration);

%% Calculate cross platform removal, transport and deposition

%% Initialize arrays and parameters
flowRoute = zeros(glob.ySize, glob.xSize);
topog = glob.strata(:,:,iteration);    
glob.gravityTransportThickness = zeros(glob.ySize, glob.xSize);  % sediment available for Lobyte gravity transport

glob.availableForTransport = zeros(glob.ySize, glob.xSize);

pltf.oneTransThickMap = num2cell(zeros(glob.ySize, glob.xSize)); % Records thickness of deposited sediment for current iteration
pltf.oneTransFaciesMap = num2cell(uint16(zeros(glob.ySize, glob.xSize))); % Records facies of deposited sediments for current iteration
pltf.oneTransTotalLayers = zeros(glob.ySize, glob.xSize); % Records number of layers

yArray=1:glob.ySize;
xArray=1:glob.xSize;
yArrayRand = yArray(randperm(length(yArray)));
xArrayRand = xArray(randperm(length(xArray)));

glob.bedloadTransportThickMap(glob.bedloadTransportThickMap < glob.minEntrainThick ) = 0; 
% glob.bedloadTransportThickMap(glob.wd(:,:,iteration)<= 0) = 0; % if the wd is zero, do not entrain the sediment
glob.bedloadTransportThickMap(pltf.tauFlow(:,:) < glob.tauCriticalBedload ) = 0; % if total shear stress is low do not entrain sediment
glob.suspendedTransportThickMap(glob.suspendedTransportThickMap < glob.minEntrainThick ) = 0; 
glob.suspendedTransportThickMap(glob.wd(:,:,iteration)<= 0) = 0; % if the wd is zero, do not entrain the sediment
glob.suspendedTransportThickMap(pltf.tauFlow(:,:) < glob.tauCriticalSuspension ) = 0; % if total shear stress is low do not entrain sediment

glob.availableForTransport(glob.bedloadTransportThickMap > 0.00) = 1;% bedload
glob.availableForTransport(glob.suspendedTransportThickMap > 0.00) = 2;% suspension

for i=1:glob.ySize
    for j=1:glob.xSize
        y=yArrayRand(i);
        x=xArrayRand(j);
        
        if glob.availableForTransport(y,x) == 1 % bedload

            %% Calculate bedload entrainment transport and deposition
            [glob,pltf,topog] = bedload_ETD(glob, pltf, iteration,flowRoute,topog, y, x); 

        elseif  glob.availableForTransport(y,x) == 2 % suspension
            
            %% Calculate suspended entrainment transport and deposition
             [glob,pltf,topog] = suspended_ETD(glob, pltf, iteration,flowRoute,topog, y, x); 

        end
    end
end


%% If subsequent layers have the same facies, merge them in one layer
for y=1:glob.ySize
    for x=1:glob.xSize 

        
        dummyLayers = pltf.oneTransTotalLayers(y,x);
        dummyThick = pltf.oneTransThickMap{y,x};
        dummyFacies = pltf.oneTransFaciesMap{y,x};
        
        ii = dummyLayers;
        
        if dummyLayers > 1
            
            for j = 1:ii
                i = ii-j;
                if dummyLayers > 1 && i > 0
                    if dummyFacies(i) == dummyFacies(i+1)
                        dummyFacies(i) = [];
                        dummyLayers =  dummyLayers - 1;
                        dummyThick(i+1) = dummyThick(i+1) + dummyThick(i);
                        dummyThick(i) = [];
                    end
                end
            end            
        end  
        
        pltf.oneTransTotalLayers(y,x) = dummyLayers;
        pltf.oneTransThickMap{y,x} = dummyThick;
        pltf.oneTransFaciesMap{y,x} = dummyFacies;
   
    end
end

%% Update arrays with the sediment deposited by current flow 
for y=1:glob.ySize
    for x=1:glob.xSize
        
        if pltf.oneTransTotalLayers(y,x) > 0
            

            oneThickness = sum(pltf.oneTransThickMap{y,x});
            
            glob.strata(y,x,iteration) = glob.strata(y,x,iteration) + oneThickness;
            
            for k = 1: pltf.oneTransTotalLayers(y,x)

             glob.numberOfLayers(y,x,iteration) = glob.numberOfLayers(y,x,iteration) + k;           
             glob.facies{y,x,iteration}(glob.numberOfLayers(y,x,iteration)) = pltf.oneTransFaciesMap{y,x}(k);            
             glob.thickness{y,x,iteration}(glob.numberOfLayers(y,x,iteration)) = pltf.oneTransThickMap{y,x}(k);

            end

            glob.wd(y,x,iteration) = glob.wd(y,x,iteration) - oneThickness;
            
        end
    end
end


%% Gravity-driven sediment transport and deposition routine: Lobyte
if ~isempty(find(glob.gravityTransportThickness, 1))
    glob.inputSedType = 'carbonate';
 [glob] = Lobyte(glob, iteration);
end 
    
end