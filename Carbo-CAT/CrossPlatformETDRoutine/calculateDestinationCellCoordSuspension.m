function [destY, destX,  flowDone, sedLost] = calculateDestinationCellCoordSuspension(glob, pltf, x, y)
%% transport direction is driven by current direction only

sedLost = false;
flowDone = false;
alpha = (pltf.tauCurrentAspect(y,x)*180)/pi;
yOut = y;
xOut = x;
     
% Calculate destination cell direction
if alpha > -22.5 && alpha <= 22.5 
    dir = [0 1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
 
elseif alpha > 22.5 && alpha <= 67.5
    dir = [1 1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
 
elseif alpha > 67.5 && alpha <= 112.5 
    dir = [1 0];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
    
elseif alpha > 112.5 && alpha <= 157.5 
    dir = [1 -1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
  
elseif alpha > 157.5 && alpha <= 180
    dir = [0 -1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
   
elseif alpha <= -157.5 && alpha >= -180
    dir = [0 -1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
   
elseif alpha <= -22.5 && alpha > -67.5 
    dir = [-1 1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 

elseif alpha <= -67.5 && alpha > -112.5 
    dir = [-1 0];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 
   
elseif alpha <= -112.5 && alpha > -157.5 
    dir = [-1 -1];
    % Destination cell cordinates
    destY = yOut + dir(1);
    destX = xOut + dir(2); 

end

    if destY > glob.ySize || destY <= 0 || destX > glob.xSize || destX <= 0
        flowDone = true; 
        sedLost = true;  
    end

 end

    