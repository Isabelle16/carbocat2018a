function plotWaveEnergyDistribution(glob,subs, iteration)
%% Plot wave energy distribution


% ff = 100; % glob.figureNum+1;
% ffOne = figure(ff);
% ffOne = figure(22);
ffOne = figure('Visible','off');

%% subsidence map 
plotLastSurface=sum(subs.subsidence(:,:,1:iteration),3).*-1;

ff = surface(plotLastSurface);
ff.CData = (glob.wave(:,:,iteration));
title('Wave energy distribution')
shading flat
xlabel('x (km)')
ylabel('y (km)')
zlabel('z (m)')
axis square
ax = gca;
c = colorbar;
c.Label.String = 'Energy density (norm)';
set(ax,'FontSize',12, 'FontWeight', 'bold')
ax.XDir = 'reverse';
ax.YDir = 'reverse';

%% Set azimuth 
azimuth=220; % / 135
elevation=49;
% % if iteration >= 900
% %     elevation = 50;
% % end

view([azimuth elevation]);

xticks([1 25 50 75 100 125 150]);
xticklabels (0:5:30);
yticks([1 10 20 30 40 50 60 70 80 90 100]);
yticklabels (0:2:20);

% set figure position and dimension
width = 50;     % Width in inches
height = 50;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*20, height*20]); %<- Set size

axis tight
    
% Save image using save_fig
set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');
% 
export_fig( sprintf('WaveEnergyDistribution %d',iteration),...
   '-png', '-transparent', '-m8', '-q101');

end