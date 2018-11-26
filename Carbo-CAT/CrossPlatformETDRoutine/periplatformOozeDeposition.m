function [pltf, topog, suspension]  = periplatformOozeDeposition (glob, iteration, pltf, topog, flowThick,  y, x, transFacies) 

% flowThickCost = initialFlowThick;
% depos = zeros(3,3);
availableSpace = glob.SL(iteration) - topog(y,x);
suspension = 0;

% Calculate amount of sediment to be deposited at the current step
    if flowThick < glob.minFlowThick
        deposVol = flowThick; 
    else
        deposVol = flowThick*0.3;
        suspension = flowThick - deposVol;
    end
    
% Check water depth    
    if availableSpace >= deposVol
         depos = deposVol;   
    else
        depos = availableSpace;
        excess = deposVol - availableSpace;
        suspension = suspension + excess;
    end

% Record deposition                
  pltf.oneTransTotalLayers(y,x) = pltf.oneTransTotalLayers(y,x) + 1;  

  pltf.oneTransThickMap{y,x}(pltf.oneTransTotalLayers(y,x)) = depos; % Map of thickness of deposited transported sediment for current iteration


  pltf.oneTransFaciesMap{y,x}(pltf.oneTransTotalLayers(y,x)) = transFacies; % Map of facies deposited by transport for current iteration   

  topog(y,x) = topog(y,x) + depos; 


end