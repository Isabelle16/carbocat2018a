function initializeSubsGraphics_topography(glob, subs, iteration)
%% Display the effect of the subsidence on the current topography

ffOne = figure(2);
% ffOne = figure('Visible','off');

% apply subsidence to the surface
surfaces = -glob.wd(:,:,1);
for t = 1:glob.totalIterations
    surfaces = surfaces - subs.subsidence(:,:,t);
end
p = surf(surfaces,surfaces);

view([-135 58]);
set(p,'LineStyle','none');
xlabel('X Distance (km)');
ylabel('Y Distance (km)');
zlabel('Z (m)')
colormap hsv  %summer
set(gca,'FontSize',30)
axis tight
    
% Set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*10, height*15]); % <- Set size

% Save image using save_fig
set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('InitialSubsidenceMap %d',iteration),...
   '-png', '-transparent', '-m8', '-q101');

end
