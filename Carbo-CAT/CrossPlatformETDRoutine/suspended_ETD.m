function [glob,pltf,topog] = suspended_ETD(glob, pltf, iteration,~,topog, y, x) 

pltf.y = y;
pltf.x = x;

initialFlowThick = glob.suspendedTransportThickMap(y,x);  %transportable sediment thickness calculated in the production routine(derived from the glob.erosionPerc value)

if initialFlowThick > 0 

    prodFacies =  glob.facies{y,x,iteration}(1); % Get the in-situ produced facies for this cell           
    transFacies = glob.transportProductFacies(prodFacies); % get the transport facies produced from the in-situ facies

        % check if there is an available destination cell   
        [~, ~,  flowDone, ~] = calculateDestinationCellCoordSuspension(glob, pltf, x, y);

        if flowDone == false % sediments are entrained, remove them from the current cell and move them to the destination cell

          % Remove sediment from the current cell  
            glob.strata(y,x,iteration) = glob.strata(y,x,iteration) - initialFlowThick;
            glob.thickness{y,x,iteration}(1) = glob.thickness{y,x,iteration}(1) - initialFlowThick;

            [glob, topog, pltf] = ETDSuspensionEvent(glob, iteration, topog, initialFlowThick, pltf, y, x, prodFacies, transFacies);


        end
end
        
        
end

       




