function [glob]= siliciclastic(glob,iteration)

% Initialize arrays and params 
glob.inputSedType = 'siliciclastic'; % set the type of sediment input for Orpheus
silicSedThickness = glob.inputSili(iteration); % siliciclastic sediment input (m)
eventNum = glob.eventsPerIteration; % number of event per iteration, each event has the same input cell coords and input sediment amount
glob.gravityTransportThickness = zeros(glob.ySize, glob.xSize);  % record the sediment available for Orpheus gravity transport
dummyDeposit = zeros(glob.ySize, glob.xSize);
glob.productionBySiliciclasticMap = zeros(glob.ySize,glob.xSize,glob.maxProdFacies);
glob.totalSiliciclasticDepos = zeros(glob.ySize, glob.xSize); % record the siliciclastic deposition
glob.siliTopog = zeros(glob.ySize, glob.xSize);
glob.siliTopog = glob.strata(:,:,iteration-1);

% Use Lobyte to transport and deposit siliciclastic sediment

% Use random input cell coordinate to avoid trend

if silicSedThickness > 0
    for i = 1:eventNum  

        xrand = glob.xInitSili(randperm(length(glob.xInitSili)));
        yrand = glob.yInitSili(randperm(length(glob.yInitSili)));

        glob.gravityTransportThickness(yrand(1),xrand(1)) = silicSedThickness;

        [glob] = Lobyte(glob, iteration); 
    end
end



%% Record siliciclastic deposition
        transFacies = 12;  
        
        dummyDeposit = glob.totalSiliciclasticDepos;  
        dummyDeposit(dummyDeposit~=0) = 1; % 0 = no deposition, 1 = deposition occurred

        glob.numberOfLayers(:,:,iteration)=glob.numberOfLayers(:,:,iteration)+ dummyDeposit;
        
       checkPos = zeros(glob.ySize,glob.xSize);

         for y=1:glob.ySize
            for x=1:glob.xSize

               if dummyDeposit(y,x) == 1  

                    glob.strata(y,x,iteration) = glob.strata(y,x,iteration-1) + glob.totalSiliciclasticDepos(y,x);

                    glob.facies{y,x,iteration}(glob.numberOfLayers(y,x,iteration)) = transFacies;
                    glob.thickness{y,x,iteration}(glob.numberOfLayers(y,x,iteration)) = glob.totalSiliciclasticDepos(y,x);

                    glob.wd(y,x,iteration) = glob.wd(y,x,iteration) - glob.totalSiliciclasticDepos(y,x);
                    
                    checkPos(y,x) = 1;

               end
            end
         end 
         


%% Calculate carbonate production extinction coefficient
%calculate the effect od siliciclastic to production.
%The effect is calculated as the ratio of the value at each cell over the
%value that kills production completely (kill value)
%Higher kill value =lower effect of the small concentrations, siliciclastic effect is apparent only close to the source
%Lower kill value = higher effect of small concentrations, siliciclastic effect is apparent farther from the source

for i=1:glob.maxProdFacies
    if i==1
        glob.productionBySiliciclasticMap(:,:,i) = 1.-(glob.totalSiliciclasticDepos/ glob.killValue(i));
    elseif i==2
        glob.productionBySiliciclasticMap(:,:,i) = 1.-(glob.totalSiliciclasticDepos / glob.killValue(i));
    elseif i==3
        glob.productionBySiliciclasticMap(:,:,i) = 1.-(glob.totalSiliciclasticDepos / glob.killValue(i));
    else
        glob.productionBySiliciclasticMap(:,:,i) = 1.-(glob.totalSiliciclasticDepos / glob.killValue(i));
    end
glob.productionBySiliciclasticMap(glob.productionBySiliciclasticMap<0)=0;
end


end

