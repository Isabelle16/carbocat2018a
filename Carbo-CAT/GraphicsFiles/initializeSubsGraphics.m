function initializeSubsGraphics(subs, iteration)
%% plot the subsidence map

ffOne = figure(1);

% subsidence map only 
testX = 1:subs.ySize;
testY = 1:subs.xSize;
plotLastSurface=sum(subs.subsidence(:,:,:),3).*-1;
p = surf(testY, testX, plotLastSurface);


view([155 74]);
set(p,'LineStyle','none');
xlabel('X Distance (km)');
ylabel('Y Distance (km)');
zlabel('Z (m)')


ZLimits = [min(min(plotLastSurface)) max(max(plotLastSurface))];
demcmap(ZLimits)
c = colorbar;
c.Label.String = 'Z (m)';
hold on
contour3(plotLastSurface)

set(gca,'FontSize',20)
axis tight
grid off
    
% Set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*15, height*10]); % <- Set size

% Save image using save_fig
set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

% export_fig( sprintf('SubsidenceMap %d',iteration),...
%    '-png', '-transparent', '-m12', '-q101');







end

