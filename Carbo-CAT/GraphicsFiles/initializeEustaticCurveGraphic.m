function initializeEustaticCurveGraphic(glob, iteration)
    
% ffOne = figure(5);
ffOne = figure('Visible','off');


p=plot((1:glob.totalIterations).*glob.deltaT, glob.SL(1:glob.totalIterations),'linewidth',6);


ylabel('Eustatic Sea Level (m)','FontSize',35);
xlabel('Time (My)','FontSize',35);
ax.XTick = [0 glob.deltaT * iteration];
set(gca,'FontSize',35)
axis tight
    
% set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*30, height*5]); %<- Set size

%% Save image using save_fig
set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('EustaticCurveZero %d',iteration),...
   '-png', '-transparent', '-m12', '-q101');
      
end