function [faciesUpscaled]=upscaleModelFacies(upscaleN,strata,input1,input2,i)
[ySize,xSize,iterations]=size(strata);

if upscaleN>1
    faciesUpscaled=zeros(ySize,xSize,(iterations/upscaleN)+1);
    LevelsUpscaled=upscaleN:upscaleN:iterations;
else
    if i == 2
    faciesUpscaled=zeros(ySize,xSize,(iterations/upscaleN));
    LevelsUpscaled=1:upscaleN:iterations; 
    else
    faciesUpscaled=zeros(ySize,xSize,(iterations/upscaleN));
    LevelsUpscaled=2:upscaleN:iterations;
    end
end





facies=input1;
thickness=input2;

%loop through all the layers on all the iterations

storedThick=[0 0 0 0 0 0 0 0 0 0 0 0]; % stores the layers thickness, the position
                                   % in the vector corresponds to the facies id 

                                   
if i == 1
    nn = 2;
else
    nn = 1;
end

for y=1:ySize
    for x=1:xSize
        countLevel=1;
        if i == 2
        countStrata=1;    
        else
        countStrata=2;
        end
        
        for t=nn:iterations
            nOfLayers=size(facies{y,x,t},2);
            for layer=1:nOfLayers
                oneThick=thickness{y,x,t}(layer);
                if oneThick>0 
                    storedThick(facies{y,x,t}(layer))=thickness{y,x,t}(layer)+storedThick(facies{y,x,t}(layer));
                end
            end
            if t==LevelsUpscaled(countLevel)
                faciesMost=find(storedThick==max(storedThick)); %get the position of the maximum thickness, 
                                                                % which coincide with the facies number
                
                
                if sum(storedThick(:))==0
                    faciesUpscaled(y,x,countStrata)=-9999; %undefined
                else
                    faciesUpscaled(y,x,countStrata)=faciesMost(1); %if there are more than one facies with the same max thickness, pick the first one
                end
                storedThick=[0 0 0 0 0 0 0 0 0 0 0 0]; %empty array
                countStrata=countStrata+1;
                countLevel=countLevel+1;
            end
            
        end
    end
end

if i == 1
faciesUpscaled(:,:,1)=0;%assign this value to the basement
end
%basement remains at 0











end