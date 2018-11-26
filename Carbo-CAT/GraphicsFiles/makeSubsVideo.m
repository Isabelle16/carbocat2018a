function makeSubsVideo(glob,subs,iteration)
 %% General

    frameCount = 1;
    
    vid = VideoWriter('faultDevelopment', 'MPEG-4');
    vid.FrameRate = 3;
    vid.Quality = 100;
    open(vid)
    
    movieFrames(frameCount) = getframe;
    
    surfRef = sum(subs.subsidence(:,:,:),3).*-1;
    l = min(min(surfRef)) - 10;  % +10 = subsidence; -10 = initial bathymetry
    minCol =  min(min(surfRef));
    maxCol = max(max(surfRef));
    
    
for t = 2:50:subs.maxT
    
fig = figure('visible','off'); 
% fig = figure(1); 

plotLastSurface=sum(subs.subsidence(:,:,1:t),3).*-1;

plotLastSurface = interp2(plotLastSurface,5);
subs.ySize = size(plotLastSurface,1);
subs.xSize = size(plotLastSurface,2);
testX = 1:subs.xSize;
testY = 1:subs.ySize;

pp = surf(testX,testY, plotLastSurface, 'EdgeColor', 'none');
hold on
%% Draw basement
for x = subs.xSize
    for y = 1:subs.ySize-1
        xc = [x x x x];
        yc = [y y+1 y+1 y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end
hold on
for x = 1:subs.xSize-1
    for y = subs.ySize
        xc = [x x+1 x+1 x];
        yc = [y y y y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end
hold on
for x = 1
    for y =1:subs.ySize-1
        xc = [x x x x];
        yc = [y y+1 y+1 y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end
hold on
for x = 1:subs.xSize-1
    for y = 1
        xc = [x x+1 x+1 x];
        yc = [y y y y];
        zc = [l l plotLastSurface(y,x) plotLastSurface(y,x)];
        patch(xc,yc,zc,[177  179  179]./255,'EdgeColor','none');

    end
end
hold on
%% General
view([30 65]);
set(pp,'LineStyle','none');
% % 
ax = gca;
xlabel('X Distance (km)','FontSize', 24, 'FontWeight','Bold');
ylabel('Y Distance (km)','FontSize', 24, 'FontWeight','Bold');
zlabel('Z (m)','FontSize', 22, 'FontWeight','Bold');
lx = subs.xSize*(200*10^-3); 
ly = subs.ySize*(200*10^-3); 
ax.XTick = [1 subs.xSize/2 subs.xSize];
ax.XTickLabel = [lx lx/2 0];
ax.YTick = [1 subs.ySize/2 subs.ySize];
ax.YTickLabel = [0 ly/2 ly ];
ax.LineWidth = 1;
ax.FontSize = 24;
    
    axis tight
    grid off
    hold on

ZLimits = [minCol  maxCol];
demcmap(ZLimits)

width = 125;     % Width in inches
height = 85;    % Height in inches
set(fig, 'Position', [0.5 0.5 width*15, height*10]); % <- Set size
set(fig,'color','white');



oneFrame = getframe(fig);
writeVideo(vid, oneFrame);
fprintf('Drawn surface %d\n', t);

close(fig)
clear plotLastSurface

end

    close(vid);
    
    
    
    
end

