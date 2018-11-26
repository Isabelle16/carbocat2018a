function [glob, sedLost] = steepestDescentTransport(topog, glob, iteration) 
% Calculate sediment channel-type transport route from the point of 
% erosion using steepest gradient descent method.

% create a new topography (to deal with model boundaries). 
dummyTopog = zeros(glob.ySize+2, glob.xSize+2);
dummyTopog(2:glob.ySize+1,2:glob.xSize+1) = topog;
dummyTopog(2:glob.ySize+1,1) = topog(:,1);
dummyTopog(1,2:glob.xSize+1) = topog(1,:);
dummyTopog(2:glob.ySize+1,glob.xSize+2) = topog(:,glob.xSize);
dummyTopog(glob.ySize+2,2:glob.xSize+1) = topog(glob.ySize,:);
dummyTopog(1,1) = dummyTopog(1,2);
dummyTopog(1,end) = dummyTopog(2,end);
dummyTopog(end,end) = dummyTopog(end-1,end);
dummyTopog(end,1) = dummyTopog(end,2);

    if glob.sedType == 2    % avoid siliciclastic loss outside model boundaries
        if any(glob.xInitSili == 1)
                dummyTopog(:,1) = max(max(topog)) + 2000;
                
        elseif any(glob.xInitSili == glob.xSize)
                dummyTopog(:,end) = max(max(topog)) + 2000;
            
        elseif any(glob.yInitSili == 1)
                dummyTopog(1,:) = max(max(topog)) + 2000;
            
        elseif any(glob.yInitSili == glob.ySize)
                dummyTopog(end,:) = max(max(topog)) + 2000;
            
        end
    end

% set initial conditions      
runUpHeight = 0; % initial value of the run up eight when the flow velocity is equal to  0
       
flowDone = false;
sedLost = false;
sedTrap = false;

% keep coordinates constant in the extended topography (update coord in agreement with the new topography)
glob.yIn = glob.yIn+1;
glob.xIn = glob.xIn+1;
deepX = glob.xIn;
deepY = glob.yIn;
it = 1;

% initialize matrices
transRoute = zeros(glob.ySize+2, glob.xSize+2);
transLength = 1;
transRoute(glob.yIn, glob.xIn) = transLength;


while flowDone == false
      
        % update topography with the flow depth and the run up
        % height
        dummyTopog(glob.yIn,glob.xIn) = dummyTopog(glob.yIn,glob.xIn) + glob.flowDepth + runUpHeight;
        
        % find deepest cell           
        [deepY, deepX, sedLost, sedTrap, cellIndex] = findDeepestCellNew(dummyTopog, glob.yIn, glob.xIn, it, glob);
        
        if sedLost == true
            
            sedLost = true;
            flowDone = true;
            
        elseif sedLost == false && sedTrap == true
                
            glob.yIn = deepY; 
            glob.xIn = deepX;
            
            flowDone = true;
        

        elseif sedLost == false && sedTrap == false

            % calculate velocity  
            [slope] = calculateSlope(glob, dummyTopog, glob.yIn, glob.xIn, deepY, deepX, cellIndex);
            [velocity, ~] = calculateVelocity(slope, dummyTopog, glob, deepY, deepX, iteration);
            % calculate velocity-dependent run up eight
            [runUpHeight] = calculateRunUpHeight(dummyTopog, velocity, glob, deepY, deepX, iteration);   

            if velocity > glob.deposVelocity(glob.sedType)

                flowDone = false;

                glob.yIn = deepY; 
                glob.xIn = deepX;  

                transLength = transLength+1;
                transRoute(glob.yIn, glob.xIn) = transLength;

            else
                flowDone = true;
            end
            
         end
    
%     % dilute the flow when it is under sea level  
%     glob.wateringFactor = 0.02;
%     if topog(glob.y, glob.x) < glob.seaLevel(glob.event) && glob.flowConcentration > glob.concentrationThreshold;
%         glob.concentration = glob.concentration - glob.wateringFactor;
%         end

it = it+1;

end

% coordinates in agreement with topog
glob.yIn = glob.yIn - 1;
glob.xIn = glob.xIn - 1;


end

