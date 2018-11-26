function [glob] = runCAModel(glob, subs)
%% Rotates the order of facies neighbour checking in calculateFaciesCA to avoid bias for any one facies
order = 1;
iteration = 2;
iter = 1; % for the graphic output

%% Main model loop
while iteration <= glob.totalIterations
    
fprintf('It:%d EMT %4.3f ', iteration, glob.deltaT * iteration);

%% Calculate subsidence
glob = calculateSubsidence(glob, subs, iteration);
    
%% Calculate water depth    
glob = calculateWaterDepth(glob, iteration);

%% Calculate wave energy    
checkProcess=strcmp(glob.waveRoutine,'on');
if checkProcess==1
    glob = waveRoutine(glob, subs, iteration);
end
        
%% Carbonate concentration routine
checkProcess=strcmp(glob.concentrationRoutine,'on');
if checkProcess == 1 
    glob = diffuseConcentration(glob,iteration);
end
        
%% Choose between the CA routines
    checkProcess=strcmp(glob.CARoutine,'ordered');
    if checkProcess==1
        glob = calculateFaciesCARandom(glob, iteration,order);
    else
        glob = calculateFaciesCAProduction(glob, iteration);
    end
    
%% Siliciclastic routine 
    checkProcess=strcmp(glob.siliciclasticsRoutine,'on');
    if checkProcess==1 && iteration >= glob.siliStartTime
        glob = siliciclastic (glob,iteration);
    end
   
%% Carbonate production
    glob = calculateProduction(glob, iteration);
        
%% Sediment redistribution
   [glob,pltf] = calculateSedimentRedistribution(glob, iteration);
  
%% Pelagic deposition 
        checkProcess=strcmp(glob.pelagicRoutine,'on');
    if checkProcess==1 
        glob = calculatePelagicDeposition(glob, pltf, iteration);
    end
    
%% Soil deposition routine 
    checkProcess=strcmp(glob.soilRoutine,'on');
    if checkProcess==1
        glob = calculateSoilDeposition (glob,iteration);
    end
    
%% Print figures
[iter] = printResult(glob, subs, iteration, iter);

%% Control cycle through facies for neighbour checking
order = order + 1;
if order > glob.maxProdFacies 
    order = 1; 
end
iteration = iteration + 1;
fprintf('\n');
    
end  %% End main model loop

%% Reverse the effect of the final increment to avoid problems with array overflows in graphics etc
if iteration > glob.totalIterations
    iteration = iteration - 1;
end

%% Calculate sediment compaction
% glob = compaction(glob,iteration);

end
