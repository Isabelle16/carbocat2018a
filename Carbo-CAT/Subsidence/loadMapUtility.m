%generates subsidence matrix from subsidence maps.
%corrects for time step
%clear all
%clc
% close all

subs.maxT=100;
subs.xSize=50;
subs.ySize=50;
subs.timeStep=0.001;
subs.subsidence=ones(subs.xSize,subs.ySize,subs.maxT);
subs.subsidenceMap1=subs.subsidence(:,:,1)+20;
%subs.subsidenceMap1=load('carbo-CAT/params/subsidenceLong20_100.txt','-ASCII');
%subs.subsidenceMap1=ones(subs.xSize,subs.ySize).*100;
% subs.subsidenceMap2=subs.subsidenceMap1+20;
%subs.subsidenceMap2=ones(subs.xSize,subs.ySize).*100;
subs.subsidence(:,:,1)=subs.subsidence(:,:,1).*subs.subsidenceMap1.*subs.timeStep;
% subs.subsidence(:,:,1)=subs.subsidence(:,:,1).*subs.subsidenceMap1'.*subs.timeStep;
 
for t=2:round(subs.maxT)
subs.subsidence(:,:,t)=subs.subsidence(:,:,t-1);
end
 
% subs.subsidence(:,:,(round(subs.maxT/2)+1))=subs.subsidence(:,:,1).*subs.subsidenceMap2.*subs.timeStep;
%  
% for t=round(subs.maxT/2)+2:subs.maxT
% subs.subsidence(:,:,t)=subs.subsidence(:,:,t-1).*1.0;
% end

%save subsidence maps
save('carbo-CAT/params/subsidence.m','-struct','subs','subsidence')
