function plotEustaticCurve_vertical( glob, iteration)

iteration = glob.totalIterations;

% ff = glob.figureNum;
% ffOne = figure(ff);
ffOne = figure('Visible','off');


p=plot(glob.SL(1:iteration), (1:iteration).*glob.deltaT,'linewidth',6);

set(gca,'YAxisLocation','right');
% set(gca,'YTick',[0 (glob.deltaT * iteration * 0.25) (glob.deltaT * iteration * 0.5) (glob.deltaT * iteration * 0.75) (glob.deltaT * iteration)]);
 

 
xlabel('Eustatic SL (m)','FontSize',35);
ylabel('Time (My)','FontSize',35);
set(gca,'YTick',[0 glob.deltaT * 700 glob.deltaT * iteration]);
axis tight

    
% set figure position and dimension
width = 85;     % Width in inches
height = 125;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*5, height*10]); %<- Set size

%% Save image using save_fig
set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('EustaticCurveVerticalZero %d',iteration),...
   '-png', '-transparent', '-m12', '-q101');
      
end