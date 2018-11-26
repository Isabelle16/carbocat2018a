function [rAngle] = calculateRefractionAngle(iAngle,Li,Lr)
% Calculate refraction angle, rAngle, accordingly to the snell's law.
% Input: 
%        - iAlpha = incidence angle
%        - V1 = ray velocity of the incidence ray
%        - V2 = ray velocity of the refracted ray
% Output:
%        - rAngle = refraction angle



iAngle = double(iAngle);

sinrAngle = (Lr/Li)*sind(iAngle);  % Snell's Law
rAngle = asind(sinrAngle);

rAngle = real(rAngle);

end