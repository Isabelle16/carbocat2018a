%function [faultLength,faultDir]=faultUtility
%build parameters used in subsidence program
clc

%inputs
x1=4;
y1=4;
x2=-10;
y2=-10;


%calculate fault direction
faultLengthX=x2-x1;
faultLengthY=y2-y1;

faultLength=sqrt(faultLengthX^2+faultLengthY^2);
if faultLengthX>0 && faultLengthY>0
faultDir=atand(abs(faultLengthX/faultLengthY));
elseif faultLengthX>0 && faultLengthY<0
faultDir=atand(abs(faultLengthY/faultLengthX))+90;
elseif faultLengthX<0 && faultLengthY<0
faultDir=atand(abs(faultLengthX/faultLengthY))+180;
elseif faultLengthX<0 && faultLengthY>0
faultDir=atand(abs(faultLengthY/faultLengthX))+270;
end

fprintf('Fault Length is %f and fault direction is %f', faultLength, faultDir);