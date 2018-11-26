
% close all
% clear all
% clc
subs.dummy=0;
subs.paramsSubsFName='Subsidence/faultparams/SADominoRelay2.txt';
fileIn = fopen(subs.paramsSubsFName);

subs=readFaultsExternal(subs,fileIn);

subs=initializeFaults(subs);

% figure(1)
% hold on
% for f=1:subs.maxF
%     start=subs.startingTime(f);
%     ends=subs.endingTime(f);
%     
% plot([subs.x1F(start,f),subs.x2F(start,f)],[subs.y1F(start,f),subs.y2F(start,f)],'xr')
% plot([subs.x1F(ends,f),subs.x2F(ends,f)],[subs.y1F(ends,f),subs.y2F(ends,f)],'x-b')
% plot(subs.xI(f),subs.yI(f),'or','markersize',10)
% plot(subs.xMaxDefNear(f),subs.yMaxDefNear(f),'+c')
% plot([subs.xMaxDefNear(f),subs.xMaxDefFarHw(f)],[subs.yMaxDefNear(f),subs.yMaxDefFarHw(f)],'-ok')
% plot([subs.xMaxDefNear(f),subs.xMaxDefFarFw(f)],[subs.yMaxDefNear(f),subs.yMaxDefFarFw(f)],'-og')
% % plot(subs.xMaxDefFarFw(f),subs.yMaxDefFarFw(f),'xg')
% % plot(subs.xMaxDefFarHw(f),subs.yMaxDefFarHw(f),'xk')
% axis([0 subs.xSize 0 subs.ySize])
% xlabel('xDistance (km)')
% ylabel('yDistance (km)')
% axis square
% 
% end

subs=generateRateArray(subs);


 subs=calculateFaults(subs);
 subs=generateSubsidenceMaps(subs);
 subs=topWithSediment(subs);
 subs=generateGraphics(subs);
%subs=generateMovie(subs);

