function [glob,pltf,topog] = bedload_ETD(glob, pltf, iteration, flowRoute,topog, y, x) 

        
pltf.y = y;
pltf.x = x;

initialFlowThick = glob.bedloadTransportThickMap(y,x);  %transportable sediment thickness calculated in the production routine(derived from the glob.erosionPerc value)

    prodFacies =  glob.facies{y,x,iteration}(1); % Get the in-situ produced facies for this cell           
    transFacies = glob.transportProductFacies(prodFacies); % get the transport facies produced from the in-situ facies

    if pltf.tauCurrent(y,x) > pltf.tauSlope(y,x) && glob.wd(y,x,iteration) > 0.00   

        % check if there is an available destination cell   
        [~, ~, flowDone, sedTrap, ~] = calculateDestinationCellCoordBedload(glob,iteration, pltf, x, y, flowRoute, initialFlowThick,topog);


        if flowDone == false % sediments are entrained, remove them from the current cell and move them to the destination cell

%             %%
%             glob.entrainArea(y,x) = glob.entrainArea(y,x) + 1; % source-to-sink analysis
%             glob.entrainVol(y,x) = glob.entrainVol(y,x) + initialFlowThick; % source-to-sink analysis
%             %%

          % Remove sediment from the current cell  
            glob.strata(y,x,iteration) = glob.strata(y,x,iteration) - initialFlowThick;
            glob.thickness{y,x,iteration}(1) = glob.thickness{y,x,iteration}(1) - initialFlowThick;

            [glob, topog, pltf] = ETDBedloadEvent(glob, iteration, topog, initialFlowThick, pltf, y, x, prodFacies, transFacies);


        end

    elseif pltf.tauCurrent(y,x) <= pltf.tauSlope(y,x) %% Lobyte 
        % remove the transportable thickness from the arrays
        % record
        glob.strata(y,x,iteration) = glob.strata(y,x,iteration) - initialFlowThick;
        glob.thickness{y,x,iteration}(1) = glob.thickness{y,x,iteration}(1) - initialFlowThick;

        % store the sediment thickness in the orpheus
        % matrix
        glob.gravityTransportThickness(y,x) = glob.gravityTransportThickness(y,x) + initialFlowThick; 

    end    

end








