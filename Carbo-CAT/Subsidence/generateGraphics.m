function [subs] = generateGraphics (subs)

% figure(1)
% hold on
% for f=1:subs.maxF
%     start=subs.startingTime(f);
%     ends=subs.endingTime(f);
%     
% plot([subs.x1F(start,f),subs.x2F(start,f)],[subs.y1F(start,f),subs.y2F(start,f)],'x-r','linewidth',3)
% plot([subs.x1F(ends,f),subs.x2F(ends,f)],[subs.y1F(ends,f),subs.y2F(ends,f)],'x-b')
% plot(subs.xI(f),subs.yI(f),'+r')
% plot([subs.xMaxDefNear(f),subs.xMaxDefFar(f)],[subs.yMaxDefNear(f),subs.yMaxDefFar(f)],'-ok')
% plot(subs.xMaxDefFar(f),subs.yMaxDefFar(f),'x')
% axis([0 subs.xSize 0 subs.ySize])
% xlabel('xDistance (km)')
% ylabel('yDistance (km)')
% end




figure (20);

 %surf(subs.finalSurface(:,:,2), 'EdgeColor', [0.5 0.5 0.5])
for aaa=1:subs.maxT
 surf(subs.finalSurface(:,:,aaa), 'EdgeColor', [0.5 0.5 0.5])

colormap(gray)
xlabel('xDistance (km)')
ylabel('yDistance (km)')
zlabel('depth (m)')
view(220, 60)
axis tight


end

 figure (21)
 hold on
 %surf(subs.finalSurface(:,:,2), 'EdgeColor', [0.5 0.5 0.5])
surf(subs.finalSurface(:,:,subs.maxT), 'EdgeColor', [0.5 0.5 0.5])
colormap(gray)
xlabel('xDistance (km)')
ylabel('yDistance (km)')
zlabel('depth (m)')
view(220, 60)
axis tight


% nameLogs={'w11-3' 'w11-1' 'w11-2' 'Durslton Head' 'Swanworth Quarry' 'Hells Bottom' 'Worborrow Tout' 'Mupe Bay' 'Poxwell' 'North Portland' 'South Portland' 'Portesham'};
% xpoint=[10 12 13 25 37 46 55 64 81 88 90 103 0];
% ypoint=[26 29 35 41 39 35 36 36 29 49 57 24 0];
% figure (3)
% l=1;
% for x=1:subs.xSize
%     for y=1:subs.ySize
%         xco=[x,x+1,x+1,x];
%         yco=[y,y,y+1,y+1];
%         zco=[subs.finalSurface(y,x,subs.maxT),subs.finalSurface(y,x,subs.maxT),subs.finalSurface(y,x,subs.maxT),subs.finalSurface(y,x,subs.maxT)];
% 
%         if xpoint(l)==x && ypoint(l)==y
%             colorC=[0.5 0.5 0.5];
%             
% %         strng=nameLogs(l);
% %         dim = [0.01 0.5 0.2 0.1];
% %         annotation('textbox',dim,'String',strng,'FitBoxToText','on','LineStyle','none');
%         l=l+1;
%         else
%         colorC=[subs.finalSurface(y,x,subs.maxT),subs.finalSurface(y,x,subs.maxT),subs.finalSurface(y,x,subs.maxT),subs.finalSurface(y,x,subs.maxT)];
%         end 
%         hold on
%         patch(xco,yco,zco,colorC);
% 
% 
%     end
% end
% 
% xlabel('xDistance (km)')
% ylabel('yDistance (km)')
% zlabel('depth (m)')
% view(180, 90)
% axis tight
% fs=-(subs.finalSurface(:,:,subs.maxT));
% save('initialTopoFaulted.txt','fs','-ascii');

%axis square

%axis([0 subs.xSize 0 subs.ySize -100 10])

% 
% figure (3)
% surf(subs.indexSize(:,:,subs.endingTime));

%figure (4)
%surf(subs.distSurfacePointIndex(:,:,subs.maxT));


% subplot(2,2,1)
% surf(subs.distSurfacePointIndex1(:,:,1))
% hold on
% for f=1:subs.maxF
% plot([subs.x1F(1,f),subs.x2F(1,f)],[subs.y1F(1,f),subs.y2F(1,f)],'x-r')
% plot([subs.x1F(subs.maxT,f),subs.x2F(subs.maxT,f)],[subs.y1F(subs.maxT,f),subs.y2F(subs.maxT,f)],'x-b')
% plot(subs.xI(f),subs.yI(f),'+r')
% plot([subs.xMD(f),subs.xMaxDef(f)],[subs.yMD(f),subs.yMaxDef(f)],'-ok')
% plot3(subs.xPP1(1,f),subs.yPP1(1,f),1,'ok')
% plot3(subs.xPP2(1,f),subs.yPP2(1,f),1,'ok')
% plot3(subs.xPP1(subs.maxT,f),subs.yPP1(subs.maxT,f),1,'og')
% plot3(subs.xPP2(subs.maxT,f),subs.yPP2(subs.maxT,f),1,'og')
% end
% surf(subs.faultPlane)
% view([-225 45]);
% 
% subplot(2,2,2)
% surf(subs.distSurfacePointIndex2(:,:,subs.maxT))
% hold on
% for f=1:subs.maxF
% plot([subs.x1F(1,f),subs.x2F(1,f)],[subs.y1F(1,f),subs.y2F(1,f)],'x-r')
% plot([subs.x1F(subs.maxT,f),subs.x2F(subs.maxT,f)],[subs.y1F(subs.maxT,f),subs.y2F(subs.maxT,f)],'x-b')
% plot(subs.xI(f),subs.yI(f),'+r')
% plot([subs.xMD(f),subs.xMaxDef(f)],[subs.yMD(f),subs.yMaxDef(f)],'-ok')
% % plot3(subs.xPP1(1,f),subs.yPP1(1,f),1,'ok')
% % plot3(subs.xPP2(1,f),subs.yPP2(1,f),1,'ok')
% % plot3(subs.xPP1(subs.maxT,f),subs.yPP1(subs.maxT,f),1,'og')
% % plot3(subs.xPP2(subs.maxT,f),subs.yPP2(subs.maxT,f),1,'og')
% end
% %surf(subs.faultPlane)
% view([-225 45]);
% 
% subplot(2,2,3)
% surf(subs.distParallelToFaultToMaxDefPoint(:,:))
% hold on
% for f=1:subs.maxF
% plot([subs.x1F(1,f),subs.x2F(1,f)],[subs.y1F(1,f),subs.y2F(1,f)],'x-r')
% plot([subs.x1F(subs.maxT,f),subs.x2F(subs.maxT,f)],[subs.y1F(subs.maxT,f),subs.y2F(subs.maxT,f)],'x-b')
% plot(subs.xI(f),subs.yI(f),'+r')
% plot([subs.xMD(f),subs.xMaxDef(f)],[subs.yMD(f),subs.yMaxDef(f)],'-ok')
% % plot3(subs.xPP1(1,f),subs.yPP1(1,f),1,'ok')
% % plot3(subs.xPP2(1,f),subs.yPP2(1,f),1,'ok')
% % plot3(subs.xPP1(subs.maxT,f),subs.yPP1(subs.maxT,f),1,'og')
% % plot3(subs.xPP2(subs.maxT,f),subs.yPP2(subs.maxT,f),1,'og')
% end
% %surf(subs.faultPlane)
% view([-225 45]);
% 
% subplot(2,2,4)
% surf(subs.distSurfacePointIndex(:,:,1))
% hold on
% for f=1:subs.maxF
% plot([subs.x1F(1,f),subs.x2F(1,f)],[subs.y1F(1,f),subs.y2F(1,f)],'x-r')
% plot([subs.x1F(subs.maxT,f),subs.x2F(subs.maxT,f)],[subs.y1F(subs.maxT,f),subs.y2F(subs.maxT,f)],'x-b')
% plot(subs.xI(f),subs.yI(f),'+r')
% plot([subs.xMD(f),subs.xMaxDef(f)],[subs.yMD(f),subs.yMaxDef(f)],'-ok')
% % plot3(subs.xPP1(1,f),subs.yPP1(1,f),1,'ok')
% % plot3(subs.xPP2(1,f),subs.yPP2(1,f),1,'ok')
% % plot3(subs.xPP1(subs.maxT,f),subs.yPP1(subs.maxT,f),1,'og')
% % plot3(subs.xPP2(subs.maxT,f),subs.yPP2(subs.maxT,f),1,'og')
% end
% %surf(subs.faultPlane)
% view([-225 45]);

% figure (5)
% subplot(3,1,1)
% for t=1:10:subs.maxT
% %    plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/2)
% %        plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',1)
% %plot(subs.thickness(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/4)
% %   axis([0 subs.ySize -200 50])
%     hold on
%     %plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-r', 'linewidth',1)
%     %plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '-b', 'linewidth',t/4)
%     %plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',1)
%     plot(subs.cellSize.*(1:subs.ySize),subs.strata(:,15,t,1),'Color','k', 'linewidth',1)
%     %plot(subs.subsidence(:,round(subs.xSize/2)+5,t,1), '-g', 'linewidth',t/4)
% 
% line([subs.cellSize.*22 subs.cellSize.*22],[0 min(subs.strata(:))]);
% line([subs.cellSize.*30 subs.cellSize.*30],[0 min(subs.strata(:))]);
%     xlabel('Distance (km)')
%     ylabel('Depth (m)')
% end
% subplot(3,1,2)
% for t=1:10:subs.maxT
% %    plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/2)
% %        plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',1)
% %plot(subs.thickness(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/4)
%  %  axis([0 subs.ySize -200 50])
%     hold on
%     %plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-r', 'linewidth',1)
%     %plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '-b', 'linewidth',t/4)
%     %plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',1)
%     plot(subs.cellSize.*(1:subs.ySize),subs.strata(:,55,t,1),'Color','k', 'linewidth',1)
%     %plot(subs.subsidence(:,round(subs.xSize/2)+5,t,1), '-g', 'linewidth',t/4)
%     
% 
% line([subs.cellSize.*36 subs.cellSize.*36],[0 min(subs.strata(:))]);
% 
% 
%     xlabel('Distance (km)')
%     ylabel('Depth (m)')
% end
% 
% subplot(3,1,3)
% 
% for t=1:10:subs.maxT
% %    plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/2)
% %        plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',1)
% %plot(subs.thickness(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/4)
%    %axis([0 subs.ySize -200 50])
%     hold on
%     %plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-r', 'linewidth',1)
%     %plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '-b', 'linewidth',t/4)
%     %plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',1)
%     plot(subs.cellSize.*(1:subs.ySize),subs.strata(:,88,t,1),'Color','k', 'linewidth',1)
%     %plot(subs.subsidence(:,round(subs.xSize/2)+5,t,1), '-g', 'linewidth',t/4)
%     
% 
% line([subs.cellSize.*28 subs.cellSize.*28],[0 min(subs.strata(:))]);
% line([subs.cellSize.*49 subs.cellSize.*49],[0 min(subs.strata(:))]);
% 
%     xlabel('Distance (km)')
%     ylabel('Depth (m)')
% end



figure (4)
subplot(3,1,1)
for t=5
%    plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/2)
%        plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',1)
%plot(subs.thickness(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/4)
   axis([0 subs.ySize -1000 150])
    hold on
    subs.finalSurface(:,:,t)=subs.finalSurface(:,:,t)-(subs.regSubsidence*subs.timeStep.*t);

    plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '.-k', 'linewidth',1)
    %plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '-b', 'linewidth',t/4)
    %plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',1)
    %plot(subs.cellSize.*(1:subs.ySize), subs.strata(:,10,t,1),'.','Color',[0 0 0], 'linewidth',1)
    %plot(subs.subsidence(:,round(subs.xSize/2)+5,t,1), '-g', 'linewidth',t/4)
    xlabel('Distance (km)')
    ylabel('Depth (m)')
end
subplot(3,1,2)
for t=10
%    plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/2)
%        plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',1)
%plot(subs.thickness(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/4)
   axis([0 subs.ySize -1000 150])
    hold on
    subs.finalSurface(:,:,t)=subs.finalSurface(:,:,t)-(subs.regSubsidence*subs.timeStep.*t);
    plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '.-k', 'linewidth',1)
    %plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '-b', 'linewidth',t/4)
    %plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',1)
    %plot(subs.cellSize.*(1:subs.ySize),subs.strata(:,25,t,1), '.','Color',[0 0 0], 'linewidth',1)
    %plot(subs.subsidence(:,round(subs.xSize/2)+5,t,1), '-g', 'linewidth',t/4)
    xlabel('Distance (km)')
    ylabel('Depth (m)')
end

subplot(3,1,3)

for t=2:2:subs.maxT
%    plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/2)
%        plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',1)
%plot(subs.thickness(:,round(subs.xSize/2)+5,t,1), '-k', 'linewidth',t/4)
   axis([0 subs.ySize -500 150])
    hold on
%     subs.finalSurface(:,:,t)=subs.finalSurface(:,:,t)-(subs.regSubsidence*subs.timeStep.*t);
%     plot(subs.finalSurface(:,round(subs.xSize/2)+5,t,1), '.k', 'linewidth',1)
    %plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '-b', 'linewidth',t/4)
    plot(subs.strata(:,round(subs.xSize/2)+5,t,1), '.-k', 'linewidth',1)
    %plot(subs.cellSize.*(1:subs.ySize),subs.strata(:,40,t,1), '.','Color',[0 0 0], 'linewidth',1)
    %plot(subs.subsidence(:,round(subs.xSize/2)+5,t,1), '-g', 'linewidth',t/4)
    xlabel('Distance (km)')
    ylabel('Depth (m)')
end

%plot faults



% plot(subs.faultPlane(:,round(subs.xSize/2)),'k')
% axis([1 subs.xSize -100 100])
% plot(subs.distance(:,round(subs.xSize/2)),'r')

% 
% 
% % figure (4)
% % surf(subs.dSMDIndex(:,:,1))
% 
% 
% 
% figure (4)
% subplot(1,2,1)
% surf(subs.subsidence(:,:,2))
% subplot(1,2,2)
% surf(subs.subsidence(:,:,subs.maxT))
% % 
% figure (5)
% 
% surf(subs.surfaceFinal(:,:,subs.maxT))
% 
% subplot(2,2,1)
% surf(sedi.surface(:,:,1))
% subplot(2,2,2)
% surf(sedi.surface(:,:,20))
% subplot(2,2,3)
% surf(sedi.surface(:,:,40))
% subplot(2,2,4)
% surf(sedi.surface(:,:,100))
% 
% figure (6)
% 
% for t=1:20:subs.maxT
% plot(sedi.surface(:,25,t))
% hold on
% end