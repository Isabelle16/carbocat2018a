function [glob, topog,  pltf] = ETDSuspensionEvent(glob, iteration, topog, initialFlowThick, pltf, y, x, prodFacies, transFacies)

%% Initialize variables
flowDone = false;
pltf.stepCount = 1;
flowRoute = zeros(glob.ySize, glob.xSize);
flowLength = 1; %length of flow in number of grid cells
flowRoute(y,x) = flowLength; %start from zero (1 = cell from which sediment has been removed by current)
flowThick = initialFlowThick;

%% Main loop
 while flowDone == false    
     
   
   if pltf.tauCurrent(y,x) > 0.000 && flowThick >= glob.minFlowThick || (glob.SL(iteration) - topog(y,x)) <= 0 
       
       [destY, destX,  flowDone, sedLost] = calculateDestinationCellCoordSuspension(glob, pltf, x, y);

       
            if flowDone == false % move to the next cell

                % pure flow phase
                flowLength = flowLength+1;
                flowRoute(destY, destX) = flowLength;

                y = destY;
                x = destX;

                flowDone = false;
                pltf.stepCount = pltf.stepCount + 1;
                
            elseif flowDone == true && sedLost == true  
               
             
            end


   elseif pltf.tauCurrent(y,x) <= 0.000 && (glob.SL(iteration) - topog(y,x)) > 0 || flowThick < glob.minFlowThick
       % deposit sediment, the current shear stress is zero
           
            [pltf, topog, suspension]  = periplatformOozeDeposition (glob, iteration, pltf, topog, flowThick,  y, x, transFacies);
           
            


              if suspension == 0 
                  flowDone = true;
              else
                [destY, destX,  flowDone, sedLost] = calculateDestinationCellCoordSuspension(glob, pltf, x, y);

                flowThick = suspension;
                y = destY;
                x = destX;
              end
      
   end  
 end
  

end
 
     


