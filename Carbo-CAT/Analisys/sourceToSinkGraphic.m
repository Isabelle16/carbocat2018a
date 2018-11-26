function sourceToSinkGraphic(glob,subs,var,varName,k)


%% plot the subsidence map

% ffOne = figure(1);
ffOne = figure('Visible','off');

%% subsidence map 
% plotLastSurface= zeros(subs.ySize,subs.xSize);
% plotLastSurface(:,:) = -2;
plotLastSurface=sum(subs.subsidence(:,:,:),3).*-1;

% plotLastSurfaceSmall = plotLastSurface;
% plotLastSurface=sum(subs.subsidence(:,:,:),3).*-1;
% plotLastSurface=glob.strata(:,:,1);
% WD = plotLastSurface.*-1;

% smallxSize = size(plotLastSurface,2);
% smallySize = size(plotLastSurface,1);



% 
% % % % % plot the initial bathymetry
% plotLastSurface = double(-glob.wd(:,:,1));

% plotLastSurface = interp2(plotLastSurface,3);
subs.ySize = size(plotLastSurface,1);
subs.xSize = size(plotLastSurface,2);
testX = 1:subs.xSize;
testY = 1:subs.ySize;

pp = surf(testX,testY, plotLastSurface, 'EdgeColor', 'none');
% 
%% Draw basement
l = min(min(plotLastSurface)) - 10;  % +10 = subsidence; -10 = initial bathymetry
for x = subs.xSize
    for y = 1:subs.ySize-1
        xc = [x x x x];
        yc = [y y+1 y+1 y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end

for x = 1:subs.xSize-1
    for y = subs.ySize
        xc = [x x+1 x+1 x];
        yc = [y y y y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end

for x = 1
    for y =1:subs.ySize-1
        xc = [x x x x];
        yc = [y y+1 y+1 y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end

for x = 1:subs.xSize-1
    for y = 1
        xc = [x x+1 x+1 x];
        yc = [y y y y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end

% %% Draw top sea level
% z = 0;
% x = 1:subs.xSize;
% y = 1:subs.ySize;
% zc = [z z z z];
% xc = [x(1) x(end) x(end) x(1)];
% yc = [y(1) y(1) y(end) y(end)];
% patch(xc,yc,zc,[0  1  1],'FaceAlpha',0.2,'EdgeColor','none');

% hold on
% %% Draw the sediment deposit using patch 
% maxt = 2;
%  for t = maxt %: maxEvent; %for the first deposit event 
%    for y = 1:glob.ySize-1
%       for x = 1:glob.xSize-1                 
%         if glob.strata(y,x,t) > glob.strata(y,x,t-1)
%              yco = [y y y+1 y+1];  % 4 vertices coordinates clockwise 
%              xco = [x x+1 x+1 x];
%              zco = [glob.strata(y,x,t), glob.strata(y,x,t), glob.strata(y,x,t), glob.strata(y,x,t)];
%              %patch(xco,yco,zco,[1-(t/glob.maxIt) t/glob.maxIt 0]); 
%              faciesCol = [0.855 0.647 0.003];
%              if faciesCol(2) > 1
%                  faciesCol(2) = 1;
%              end
%              if faciesCol(1) > 1
%                  faciesCol(1) = 1;
%              end
% 
%              rr = patch(xco,yco,zco,faciesCol); 
%              set(rr,'FaceAlpha',0.9,'EdgeColor','none');
%         end     
%       end 
%    end
%  end
% hold on




%% General
view([37 75]);
% view([-26 63]);
set(pp,'LineStyle','none');

ax = gca;
xlabel('X(km)', 'FontSize',25,'FontWeight','bold');
ylabel('Y(km)', 'FontSize',25,'FontWeight','bold');
zlabel('Z(m)','FontSize',25,'FontWeight','bold')
% lx = smallxSize*(glob.dx*10^-3); 
% ly = smallySize*(glob.dx*10^-3); 
lx = subs.xSize*(glob.dx*10^-3); 
ly = subs.ySize*(glob.dx*10^-3);
ax.XTick = [1 subs.xSize/2 subs.xSize];
ax.XTickLabel = [lx lx/2 0];
ax.YTick = [1 subs.ySize/2  subs.ySize];
ax.YTickLabel = [0 ly/2 ly];

ax.LineWidth = 0.5;
ax.FontSize = 25;
ax.FontWeight = 'bold';
axis tight
grid off

% shading flat
lightangle(250,30)
pp.FaceLighting = 'gouraud'; % 'flat';
pp.AmbientStrength = 0.9;
pp.DiffuseStrength = 0.8;
pp.SpecularStrength = 0.9;
pp.SpecularExponent = 25;
% pp.BackFaceLighting = 'unlit';
% material metal

% ZLimits = [min(min(plotLastSurface)) max(max(plotLastSurface))];
% demcmap(ZLimits)
% caxis([min(min(plotLastSurface)) max(max(plotLastSurface))])

% c = colorbar;
% c.Label.String = 'Normalized wave energy';
% c.FontSize = 18;
% hold on
% contour3(plotLastSurface)

% iteration = 1;
% glob = waveRoutine(glob, subs, iteration,plotLastSurface);
% 
% hold on
% 
% colorRGB = zeros(subs.ySize,subs.xSize,3);
colorRGB1 = ones(subs.ySize,subs.xSize);
colorRGB2 = ones(subs.ySize,subs.xSize);
colorRGB3 = ones(subs.ySize,subs.xSize);
% % colorRGB(:,:,1) = glob.waveEnergy;
% % colorRGB(colorRGB == 0) = -1;
% % maxrgb = max(max(colorRGB>-1));
% % % minrgb = min(min(colorRGB>-1));
% % colorRGB = colorRGB./maxrgb;
% % colorRGB(colorRGB < 0) = 0;
% % % colorRGB(:,:,3) = 
% % % colorRGB1(glob.waveEnergy < 0.99) = 1;
% % % colorRGB2(glob.waveEnergy >= 0.99)= 0.5;
% % % colorRGB1(glob.totalSiliciclasticDepos>0) = 1;
% % % colorRGB1(WD>25) = 1;
% 
% colorRGB1(glob.waveEnergy > 0.99) = 1;
% colorRGB2(glob.waveEnergy <= 0.99)= 0.5;
% % colorRGB1(glob.totalSiliciclasticDepos>0) = 1;
% % colorRGB2(glob.totalSiliciclasticDepos>0)= 0.5;
% colorRGB1(WD>90) = 1;
% colorRGB2(WD>90) = 0;


maxVal = max(max(var));
colorRGB3 = var.^3./maxVal^3;
% colorRGB1 = var;

colorRGB = cat(3,colorRGB1,colorRGB2,colorRGB3);

% pp.CData = colorRGB;
pp.CData = var;
% pp.CData = glob.waveEnergy;
% caxis([min(min(glob.waveEnergy(glob.waveEnergy > 0))) max(max(glob.waveEnergy))]);
caxis([min(min(var)) max(max(var))]);



%% plot cross section
%% Plot cross section position using patch
% xPosition = [(55*subs.xSize)/glob.xSize]; 
% yPosition = [(68*subs.ySize)/glob.ySize];
% % 
% % xPosition = [(65*subs.xSize)/glob.xSize]; %(65*subs.xSize)/glob.xSize (90*subs.xSize)/glob.xSize]; 
% % yPosition = [(25*subs.ySize)/glob.ySize];
% % % % y Cross section
% for i = 1
% zco = [300 l l 300];
% % yco = [yPosition yPosition yPosition yPosition]; 
% yco = [yPosition(i) yPosition(i) yPosition(i) yPosition(i)]; 
% xco = [0 0 subs.xSize+1 subs.xSize+1];
% faciesCol = [1 0.921 0.843];
% patch(xco, yco, zco, faciesCol,'FaceAlpha',0.35,'LineWidth',1 ); 
% end
% for i = 1
% %x cross section
% zco = [300 l l 300];
% xco = [xPosition(i) xPosition(i) xPosition(i) xPosition(i)]; 
% yco = [0 0 subs.ySize+1 subs.ySize+1];
% faciesCol = [1 0.921 0.843];
% patch(xco, yco, zco, faciesCol,'FaceAlpha',0.35,'LineWidth',1 ); 
% end

    
%% Set figure position and dimension
% width = 125;     % Width in inches
width = 85;     % Width in inches
height = 85;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*15, height*9]); % <- Set size
% pbaspect([1 1.2 0.8]);

%% Save image using save_fig
set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('STS%s%d.mat',varName,k'),...
   '-png', '-transparent', '-m12', '-q101');

% save('C:\Users\isabel16\Dropbox\CarboCAT2018\ModelOutput\source.txt', 'plotLastSurface', '-ascii');
% close(ffOne);

end