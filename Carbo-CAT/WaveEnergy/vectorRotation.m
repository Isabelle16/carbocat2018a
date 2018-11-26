function [x2,y2] = vectorRotation(rAngle,iAngle, x1, y1)
% Calculate vector rotation through and angle beta using the rotation
% matrix.
% Input:
%       - x1,y1 = vector components
%       - beta = rotation angle
% Output:
%       - x2,y2 = new vector components, after rotation

beta = rAngle-iAngle; 
beta = double(-beta);

x2 = cosd(beta) * x1 - sind(beta) * y1;
y2 = sind(beta) * x1 + cosd(beta) * y1;


end


