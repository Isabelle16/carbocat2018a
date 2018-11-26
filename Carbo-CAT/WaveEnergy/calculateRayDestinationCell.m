function [yDest,xDest,dir] = calculateRayDestinationCell(yOut,xOut,yr,xr)
% calculate the destination cell of the refracted ray
%
%
%

Vr = [yr xr];
alpha = atan2d(Vr(1),Vr(2)); % angle from Vr towards the +x axis (ccw=+; cw=-) 


% % % % calculate the angle between the refracted ray and the -y axis direction
% % % 
% % % dott = dot(Vr,Vy);
% % % det = Vr(2).*Vy(1) - Vr(1).*Vy(2);
% % % 
% % % alpha = atan2d(det, dott); % 

% Calculate destination cell direction
if alpha > -22.5 && alpha <= 22.5 
    dir = [0 1];
 
elseif alpha > 22.5 && alpha <= 67.5
    dir = [1 1];

elseif alpha > 67.5 && alpha <= 112.5 
    dir = [1 0];
    
elseif alpha > 112.5 && alpha <= 157.5 
    dir = [1 -1];

elseif alpha > 157.5 && alpha <= 180
    dir = [0 -1];
    
elseif alpha <= -157.5 && alpha >= -180
    dir = [0 -1];
    
elseif alpha <= -22.5 && alpha > -67.5 
    dir = [-1 1];

elseif alpha <= -67.5 && alpha > -112.5 
    dir = [-1 0];

elseif alpha <= -112.5 && alpha > -157.5 
    dir = [-1 -1];

end

% Destination cell cordinates
yDest = yOut + dir(1);
xDest = xOut + dir(2); 


end
