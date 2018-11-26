function [glob] = calculateWaterDepth(glob, iteration)
% Calculate water depth from sealevel and elevation of the most recently deposited layer
% in iteration - 1

for y = 1:glob.ySize
    for x=1:glob.xSize
        
        glob.wd(y,x,iteration) = glob.SL(iteration) - glob.strata(y,x,iteration-1);
       
    end
end