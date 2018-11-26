function glob = calculateSubTimeStepParams(glob, iteration)
% For every model cell, calculate the convenient number of sub-iterations
% (subIts) and the corresponding water depth interval (dWD). 
% subIts is equal to zero if: 
% - WD(y,x,it) <= WD(y,x,it-1); 
% - WD(y,x,it-1) >= DepthCutOff(facies)
% - no facies colonization (facies(y,x,it) = 0)

%% Initialize arrays
dWD = 10; %water depth interval
glob.subIts = zeros(glob.ySize, glob.xSize); % number of sub-iteration for every cell
glob.dWD = zeros(glob.ySize, glob.xSize); %re-calculated water depth intervals value accordingly to the number of sub-iterations

for y = 1: glob.ySize
    for x = 1:glob.xSize
        
        oneFacies =  glob.facies{y,x,iteration}(1);
        % calculate the water depth difference between the current and the former iteration    
        WDincrease = glob.wd(y,x,iteration) - glob.wd(y,x,iteration-1);
        
        if glob.wd(y,x,iteration) > glob.wd(y,x,iteration-1) &&...
                oneFacies > 0 && oneFacies < 5 &&...
                glob.wd(y,x,iteration-1) < glob.prodRateWDCutOff(oneFacies)
        

        % calculate the number of sub-iterations
        glob.subIts(y,x) = uint8(WDincrease/dWD);
        % if subIts == 0 (happens when WDincrease/dWD < 0.5) ==> subIts == 1;
        if glob.subIts(y,x) == 0
            glob.subIts(y,x) = 1;
        end        
        % re-calculate the WD interval accordingly to the total number of
        % sub-iterations
        glob.dWD(y,x) = WDincrease/glob.subIts(y,x);
        
        else
        glob.subIts(y,x) = 1;
        glob.dWD(y,x) = WDincrease ;
            
        end
    end
   

end



end


