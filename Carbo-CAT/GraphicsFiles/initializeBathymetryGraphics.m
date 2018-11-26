function initializeBathymetryGraphics(glob, subs, iteration)
%% Initial Bathymetry

% ffOne = figure(3);
ffOne = figure('Visible','off');

p=surface(double(-glob.wd(:,:,1)));

view([-135 58]);
set(p,'LineStyle','none');
xlabel('X Distance (km)');
ylabel('Y Distance (km)');
zlabel('Z (m)')
colormap summer
set(gca,'FontSize',30)
axis tight
    
% Set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*10, height*15]); % <- Set size

% Save image using save_fig
set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('InitialBathymetryMap %d',iteration),...
   '-png', '-transparent', '-m12', '-q101');

end