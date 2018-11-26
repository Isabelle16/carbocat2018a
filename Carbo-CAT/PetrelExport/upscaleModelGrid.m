function [strataUpscaled]=upscaleModelGrid(glob,upscaleN,strata,i)
%upscales the model grid
% upscaleN: number of timesteps representing each new layer
% strata: elevations data for each position and each iteration, in format
% (y,x,t)

[ySize,xSize,iterations]=size(strata);
if upscaleN>1
strataUpscaled=zeros(ySize,xSize,(iterations/upscaleN)+2);
LevelsUpscaled=upscaleN:upscaleN:iterations;
else   
    if i == 2
        strataUpscaled=zeros(ySize,xSize,(iterations/upscaleN));
        LevelsUpscaled=1:upscaleN:iterations;  
    else
        strataUpscaled=zeros(ySize,xSize,(iterations/upscaleN)+1);
        LevelsUpscaled=2:upscaleN:iterations;
    end
end


if i == 1
basement=min(strata(:))*1.1;
strataUpscaled(:,:,1)=basement;
strataUpscaled(:,:,2)=strata(:,:,1);
t=3;
else
    strataUpscaled(:,:,1) = glob.strata(:,:,glob.totalIterations);
    t = 2;
end


for l=LevelsUpscaled
    strataUpscaled(:,:,t)=strata(:,:,l);
    t=t+1;
end

end