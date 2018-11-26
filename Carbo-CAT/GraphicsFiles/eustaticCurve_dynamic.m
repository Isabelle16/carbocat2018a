function eustaticCurve_dynamic(glob, iteration)

% ff = glob.figureNum;
% ffOne = figure(ff);

ffOne = figure('Visible','off');



p=plot((1:iteration).*glob.deltaT,glob.SL(1:iteration),'linewidth',3);


ylabel('SL (m)','FontSize',35);
xlabel('Time (My)','FontSize',35);
ax.XTick = [0 glob.deltaT * iteration];
set(gca,'FontSize',35)
axis tight

ax.YDir = 'reverse';
    
% set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*10, height*5]); %<- Set size

%% Save image using save_fig
set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('EustaticCurve %d',iteration),...
   '-png', '-transparent', '-m8', '-q101');
      
end