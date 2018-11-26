function [glob] = Lobyte(glob, iteration)
% Gravity flow algorithm

%% Initialize parameters/array according to the sediment transported type
checkProcess=strcmp(glob.inputSedType,'siliciclastic');

if checkProcess==1 % siliciclastic
    glob.sedType = 2;
    topog = glob.siliTopog;
else % carbonate
    glob.sedType = 1;
    transFacies = 10;
    topog = glob.strata(:,:,iteration);
end

glob.dy = glob.dx;


%% Main model loop
% find the coordinates of sediments available to be transported:        
[row, col] = find(glob.gravityTransportThickness);  

deposThickWhole = zeros(glob.ySize, glob.xSize, size(row,1)); %matrix recording every deposition events

% use random indices to avoid trend
kk = 1:size(row,1);
krand = kk(randperm(length(kk)));


for i = 1 : size(row,1)
    
    k = krand(i);

    glob.yIn = row(k);
    glob.xIn = col(k);   
    glob.flowDepth = glob.gravityTransportThickness(glob.yIn,glob.xIn);  


    deposThick = zeros(glob.ySize, glob.xSize); 
    flowThick = zeros(glob.ySize, glob.xSize);

    
    %% Calculate sediment channel-type transport route from the point of erosion    
    [glob, sedLost] = steepestDescentTransport(topog, glob, iteration);
    
    if sedLost == false

    %% Deposit transported sediment       
    glob.yDep = glob.yIn;
    glob.xDep = glob.xIn;

    %% Calculate fan-lobe deposition           
    [flowThick, deposThick] = fanLobeDeposition(glob, topog);
          
    end

    % When the flow stops all the sediments are deposited
    deposThick = deposThick+flowThick; 

    % Record deposits and update matrices
    deposThickWhole(:,:,k) = deposThick;
    
       % Update topography: the next flow will interact with the current
    % deposition
    topog = topog + deposThick; 
        
end


    %% Update variables and matrices
    % elevation of the strata layers
    deposThickWhole = sum(deposThickWhole,3); % deposited sediments
    
    %% Record deposition (carbonate) and update array (siliciclastic)
    
    if glob.sedType == 2 %% For the siliciclastic routine
        
    glob.totalSiliciclasticDepos = glob.totalSiliciclasticDepos + deposThickWhole; % record total deposition of siliciclatic in the current iteration   
    glob.siliTopog = glob.siliTopog + deposThickWhole;  % record topography for the next gravity flow (same iteration)
      
    else  % Record deposition for current derived gravity flow

        dummyDeposit = deposThickWhole;  
        dummyDeposit(dummyDeposit~=0) = 1; % 0 = no deposition, 1 = deposition occurred

        glob.numberOfLayers(:,:,iteration)=glob.numberOfLayers(:,:,iteration)+ dummyDeposit;


         for y=1:glob.ySize
            for x=1:glob.xSize

              if dummyDeposit(y,x) > 0  

                    glob.strata(y,x,iteration) = glob.strata(y,x,iteration) + deposThickWhole(y,x);

                    glob.facies{y,x,iteration}(glob.numberOfLayers(y,x,iteration)) = transFacies;
                    glob.thickness{y,x,iteration}(glob.numberOfLayers(y,x,iteration)) = deposThickWhole(y,x);

                    glob.wd(y,x,iteration) = glob.wd(y,x,iteration) - deposThickWhole(y,x);
                   

               end
            end
        end 
    end

    
    
    
end



    






