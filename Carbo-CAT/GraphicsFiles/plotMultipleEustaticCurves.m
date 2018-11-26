function plotMultipleEustaticCurves(glob, iteration)

% Plot eustatic curves with different T/A in the same plot     

ffOne = figure(15);
% ffOne = figure('Visible','off');

glob.SLCurveNum = 3; % number of eustatic curve to plot
glob.eustaticOrderNum = 2; % total number of eustatic oscillation order for the same eustatic curve


SLPeriod = [1.5 0.1; 1.5 0.1 ; 1.5 0.1 ]; 
SLAmp = [1 1; 30 30 ; 60 60];


% initialize sea-level curve here
for k = 1: glob.SLCurveNum 
    glob.SLPeriod = SLPeriod(k,:);
    glob.SLAmp = SLAmp(k,:);
    for i=1:glob.maxIts
        %add a flat line initially
        if i<1
            emt = double(80) * glob.deltaT;
            glob.SL(i,k)= ((sin(pi*((emt/glob.SLPeriod(1))*2)))* glob.SLAmp(1))+ (sin(pi*((emt/glob.SLPeriod(2))*2)))* glob.SLAmp(2)-2;
        else
            emt = double(i) * glob.deltaT;
            glob.SL(i,k)= ((sin(pi*((emt/glob.SLPeriod(1))*2)))* glob.SLAmp(1))+ (sin(pi*((emt/glob.SLPeriod(2))*2)))* glob.SLAmp(2)-2;
        end
    end
end


p=plot((1:glob.totalIterations).*glob.deltaT,glob.SL(1:glob.totalIterations,1),'linewidth',3,'Color',[255 0 0]./255); % Red
hold on;
p=plot((1:glob.totalIterations).*glob.deltaT,glob.SL(1:glob.totalIterations,2),'linewidth',3,'Color',[0 128 255]./255); % Azure
hold on;
p=plot((1:glob.totalIterations).*glob.deltaT,glob.SL(1:glob.totalIterations,3),'linewidth',3,'Color',[63 224 208]./255);
hold off;

legend('Greenhouse','Transitional','Icehouse');

ylabel('Eustatic Sea Level (m)','FontSize',35);
xlabel('Time (My)','FontSize',35);
ax.XTick = [0 glob.deltaT * iteration];
set(gca,'FontSize',35)
axis tight
    
% set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*18, height*12]); %<- Set size

%% Save image using save_fig
set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('EustaticCurve %d',5),...
   '-png', '-transparent', '-m12', '-q101');
      
end