function [glob, topog,  pltf] = ETDBedloadEvent(glob, iteration, topog, initialFlowThick, pltf, y, x, prodFacies, transFacies)

%% Initialize variables
flowDone = false;
% sedTrap = false;
% sedLost = false;
pltf.stepCount = 1;
flowRoute = zeros(glob.ySize, glob.xSize);
flowLength = 1; %length of flow in number of grid cells
flowRoute(y,x) = flowLength; %start from zero (1 = cell from which sediment has been removed by current)


%% Main loop
 while flowDone == false    
     
   if pltf.tauFlow(y,x) >= glob.tauCriticalBedload && initialFlowThick >= glob.minEntrainThick 
       
       if pltf.tauCurrent(y,x) > pltf.tauSlope(y,x)   % current entrainment
           
           [destY, destX,  flowDone, sedTrap, sedLost] = calculateDestinationCellCoordBedload(glob,iteration, pltf, x, y, flowRoute, initialFlowThick, topog);

            if flowDone == false % move to the next cell

            % pure flow phase
            flowLength = flowLength+1;
            flowRoute(destY, destX) = flowLength;
         
             

            y = destY;
            x = destX;

            flowDone = false;
            pltf.stepCount = pltf.stepCount + 1;

            elseif flowDone == true && sedTrap == true
                % local topographic low where sediment are trapped, deposit all the sediments and quit while loop   
                          
                [pltf, topog]  = crossPlatformDeposition (glob, iteration, pltf, topog, initialFlowThick,  y, x, transFacies); 
                
            elseif flowDone == true && sedLost == true
             sedLost = true;
             
             
            end
            
       else % store sediment for Orpheus
        glob.gravityTransportThickness(y,x) = glob.gravityTransportThickness(y,x) + initialFlowThick;        
        flowDone = true;     
       end

   else % deposit all the sediment, the total shear stress is low   
            [pltf, topog]  = crossPlatformDeposition (glob, iteration, pltf, topog, initialFlowThick,  y, x, transFacies);
            flowDone = true;
            
   end  
 end
  

end
 
     


