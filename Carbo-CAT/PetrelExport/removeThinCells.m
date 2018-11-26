function [strataUpscaled]=removeThinCells(strataUpscaled,removeThin)


[ySize,xSize,iterations]=size(strataUpscaled);

for t=1:iterations-1;
    
    thickness=strataUpscaled(:,:,t+1)-strataUpscaled(:,:,t);
    thicknessCheck=thickness;
    thicknessCheck(thickness>=removeThin)=0;
    for l=t:iterations-1
        strataUpscaled(:,:,l+1)=strataUpscaled(:,:,l+1)-thicknessCheck;
    end
    
end

end