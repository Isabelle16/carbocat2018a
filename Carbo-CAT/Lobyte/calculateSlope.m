function [slope] = calculateSlope(glob, topog, y1, x1, y2, x2, cellIndex)

% Calculate slope and azimuth between two point in the 3D space
dy = glob.dy;
dx = glob.dx;
dz = topog(y2,x2) - topog(y1,x1); % the slope is negative for outflow

if mod(cellIndex,2) == 0
    slope = dz/(sqrt(dy^2+dx^2));    
else
    slope = dz/dx; 
end  


end