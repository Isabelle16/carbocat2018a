function [destY, destX,  flowDone, sedTrap, sedLost] = calculateDestinationCellCoordBedload(glob,iteration, pltf, x, y, flowRoute, initialFlowThick,topog)

sedTrap = false;
sedLost = false;
flowDone = false;

wd = zeros(glob.ySize, glob.xSize);
wd = glob.SL(iteration) - topog;


 % find the potential destination cell                                      
 % direction: 1=E; 2=SE; 3=S and so on, clockwise.    
 
    alpha = (pltf.tauFlowAspect(y,x)*180)/pi;
    yOut = y;
    xOut = x;
    
    
% Calculate destination cell direction
if alpha > -22.5 && alpha <= 22.5 
    dir = [0 1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
    direction = 1;
        % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if mod(x,2) == 0
                dir = [-1 1];
                direction = 8;
            else
                dir = [1 1];
                direction = 2;
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
        % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if   direction == 8
                 dir = [1 1];
            else
                 dir = [-1 1];
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
            
        end
        end
        end
        end

 
elseif alpha > 22.5 && alpha <= 67.5
    dir = [1 1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
      direction = 2;
        % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if mod(x,2) == 0
                dir = [0 1];
                direction = 1;
            else
                dir = [1 0];
                direction = 3;
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
        % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if   direction == 1
                  dir = [1 0];
            else
                    dir = [0 1];
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
            
        end
        end
        end
        end

elseif alpha > 67.5 && alpha <= 112.5 
    dir = [1 0];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
      direction = 3;
      % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if mod(x,2) == 0
                dir = [1 1];
                direction = 2;
            else
                dir = [1 -1];
                direction = 4;
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
        % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if   direction == 2
                 dir = [1 -1];
            else
                     dir = [1 1];
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
            
        end
        end
        end
        end
        
    
elseif alpha > 112.5 && alpha <= 157.5 
    dir = [1 -1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
    direction = 4;
       % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if mod(x,2) == 0
                dir = [1 0];
                direction = 3;
            else
                dir = [0 -1];
                direction = 5;
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
        % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if   direction == 5
                 dir = [1 0];
            else
                     dir = [0 -1];
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
            
        end
        end
        end
        end
        

elseif alpha > 157.5 && alpha <= 180
    dir = [0 -1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
     direction = 5;
      
       % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if mod(x,2) == 0
                dir = [1 -1];
                direction = 4;
            else
                dir = [-1 -1];
                direction = 6;
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
        % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if   direction == 4
                  dir = [-1 -1];
            else
                      dir = [1 -1];
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
            
        end
        end
        end
        end

    
elseif alpha <= -157.5 && alpha >= -180
    dir = [0 -1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
      direction = 5;
       % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if mod(x,2) == 0
                dir = [1 -1];
                direction = 4;
            else
                dir = [-1 -1];
                direction = 6;
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
        % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if   direction == 4
                  dir = [-1 -1];
            else
                      dir = [1 -1];
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
            
        end
        end
        end
        end

    
elseif alpha <= -22.5 && alpha > -67.5 
    dir = [-1 1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
      direction = 8;
      
             % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if mod(x,2) == 0
                dir = [0 1];
                direction = 1;
            else
                dir = [-1 0];
                direction = 7;
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
        % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if   direction == 7
                  dir = [0 1];
            else
                      dir = [-1 0];
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
            
        end
        end
        end
        end


elseif alpha <= -67.5 && alpha > -112.5 
    dir = [-1 0];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
      direction = 7;
                   % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if mod(x,2) == 0
                dir = [-1 1];
                direction = 8;
            else
                dir = [-1 -1];
                direction = 6;
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
        % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX)<= 0 
            if   direction == 8
                 dir = [-1 -1];
            else
                         dir = [-1 1];
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
            
        end
        end
        end
        end
   

elseif alpha <= -112.5 && alpha > -157.5 
    dir = [-1 -1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
      direction = 6;
                         % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0 
            if mod(x,2) == 0
                dir = [0 -1];
                direction = 5;
            else
                dir = [-1 0];
                direction = 7;
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
        % check nbr cell if destination cell is above sea level
        if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX)<= 0 
            if   direction == 5
                dir = [-1 0];
            else
                        dir = [0 -1];
            end
            
            destY = yOut + dir(1);
            destX = xOut + dir(2); 
            
        end
        end
        end
        end
    

end

   
    if destY <= glob.ySize && destY > 0 && destX <= glob.xSize && destX > 0
        if wd(destY,destX) <= 0
            flowDone = true;
            sedTrap = true; % local low along the platform (e.g. small inner platform basin where sediment are trapped)
            
            
        end
    else
        flowDone = true; 
        sedLost = true;  
        

    end
    
    
   if sedLost == false && flowRoute(destY, destX) > 0  % the flow cannot go in cell where it has already been previously
       flowDone = true;
       sedTrap = true;
       

   end
   

    end

    