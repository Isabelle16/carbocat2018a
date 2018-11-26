function [pltf, topog ]  = crossPlatformDeposition (glob, iteration, pltf, topog, initialFlowThick,  y, x, transFacies)
% deposit part of the sediment in the current cell and distribute the rest in the nbr cells.

% flowThickCost = initialFlowThick;
depos = zeros(3,3);
availableSpace = glob.SL(iteration) - topog(y,x);


%deposit an amount of sediment in the current cell
%     deposVol = initialFlowThick*0.3;
      deposVol = initialFlowThick;
    
    if availableSpace >= deposVol
         depos(2,2) = deposVol;   
    else
%          depos(2,2) = availableSpace;   
         nbrDepos =  deposVol - availableSpace; %amount of sediment to be distributed between nbrs 
         depos(2,2) = nbrDepos;

        xPlus = x+1;
        xMinus = x-1;
        yPlus = y+1;
        yMinus = y-1;
        
        if xPlus > glob.xSize
            xPlus = x;
        end
        if xMinus < 1
            xMinus = x;
        end
        if yPlus > glob.ySize
            yPlus = y;
        end
        if yMinus < 1
            yMinus = y;
        end
      
         nbrBatymetry = [glob.wd(y,xPlus, iteration); glob.wd(yPlus,xPlus, iteration); glob.wd(yPlus,x, iteration); glob.wd(yPlus,xMinus, iteration);...
                glob.wd(y,xMinus, iteration); glob.wd(yMinus,xMinus, iteration); glob.wd(yMinus,x, iteration); glob.wd(yMinus,xPlus, iteration)]; %from E-cell clockwise
         
         nbrBatymetry(nbrBatymetry < 0.00) = 0.00;
     
    %% Calculate the sediment fraction received by each cell from the current cell(y,x)
%         nbrBatymetry = nbrBatymetry.^10; 
        nbrBatymetry = nbrBatymetry/sum(nbrBatymetry);
       
        if isempty(nbrBatymetry) %distribute the same sediment fraction in each nrb cell (the sea level is zero in the nbr cells)
            partialDepos(:,:) = initialFlowThick/8; %% e sbagliato
        else
         % use circshift to distribute the exceeding sediment in the suitable  
         % neighbouring cells 
            depos = circshift(depos,[0 1]).*(nbrBatymetry(1))...
                + circshift(depos,[1 1]).*(nbrBatymetry(2))...
                + circshift(depos,[1 0]).*(nbrBatymetry(3))...
                + circshift(depos,[1 -1]).*(nbrBatymetry(4))...
                + circshift(depos,[0 -1]).*(nbrBatymetry(5))...
                + circshift(depos,[-1 -1]).*(nbrBatymetry(6))...
                + circshift(depos,[-1 0]).*(nbrBatymetry(7))...
                + circshift(depos,[-1 1]).*(nbrBatymetry(8));
        end
        
        depos(2,2) = availableSpace ; % fill the current cell with sediment

    end
    
    
     %Update matrices
        yInd = [y-1, y, y+1, y-1, y, y+1, y-1, y, y+1];  
        xInd = [x-1, x-1, x-1, x, x, x, x+1, x+1, x+1]; 
        dummyVector = depos(:)';
        
        for k = 1:1:9
            i = yInd(k);
            j = xInd(k);
            oneDepos = dummyVector(k);
            if oneDepos > 0 && i >= 1 && i <= glob.ySize && j >= 1 && j <= glob.xSize   
                
              pltf.oneTransTotalLayers(i,j) = pltf.oneTransTotalLayers(i,j) + 1;  
                
              pltf.oneTransThickMap{i,j}(pltf.oneTransTotalLayers(i,j)) = oneDepos; % Map of thickness of deposited transported sediment for current iteration
          
              
              pltf.oneTransFaciesMap{i,j}(pltf.oneTransTotalLayers(i,j)) = transFacies; % Map of facies deposited by transport for current iteration   
              
              topog(i,j) = topog(i,j) + oneDepos; 

              if topog(i,j) > 0.5
               m = topog(i,j);
              end
              
            end

        end
        

        
       
 
end


