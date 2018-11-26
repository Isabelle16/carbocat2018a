function plotSubsidenceHistory(glob,subs,iteration)

% %% Plot basin subsidence hiystory
% close all;
% clear all;
% clc;

% cd 'C:\Users\isabel16\Dropbox\CarboCAT2018\ModelOutput'
% cd '/Users/Isabella/Dropbox/CarboCAT2018/ModelOutput/09.04.2nd'
% %% load data from file
% % glob=load('globalArrays.mat');
% subs=load('subsArrays.mat');
initialBathymetry = zeros(subs.ySize,subs.xSize);
initialBathymetry(:,:) = -2;
MaxIteration = subs.maxT;
dt = subs.timeStep;


ffOne = figure(50);
% ffOne = figure('Visible','off');

%% Coordinates of the points to plot
% xco = [65 65 65];
% yco = [16 30 36];
% xco = [1];
% yco = [1];
xco = [55 55];
yco = [60 20];
subsCurve = zeros(MaxIteration,size(xco,2));



for i = 1:size(xco,2)
    y = yco(i);
    x = xco(i);
    bathymetry = initialBathymetry(y,x);
 for j = 1:MaxIteration
     
%     subsCurve(j,i) = subs.subsidence(y,x,j)/dt;
    subsCurve(j,i) = ((subs.subsidence(y,x,j) - subs.subsidence(1,1,j)) /dt)*10^-3;
%     bathymetry = subsCurve(j,i);

%     subsCurve(j,i) =(bathymetry - subs.subsidence(y,x,j));
%     bathymetry = subsCurve(j,i);
    
 end
end


subsCurve(end) = subsCurve(end-1);
% subsCurve(:,:) = -1*subsCurve(:,:);


ylabel('Slip Rate (mm/y)','FontSize',35);
xlabel('Time (My)','FontSize',35);
axis tight 

% maxUplift = min(min(sum(subs.subsidence,3)));
% maxSubs = max(max(sum(subs.subsidence,3)));

maxUplift = 0;
maxSubs = 2;

% axis([0 dt*MaxIteration -maxSubs maxUplift]);
axis([0 dt*MaxIteration maxUplift maxSubs]);
grid on;
set(gca,'FontSize',35)

hold on

% plotStyle = {'k','g','k','r','m'}; %,'y','m'};
plotStyle = {'r','k','g','m'}; %,'y','m'};
for i = 1:size(xco,2)  
     
 plot((1:MaxIteration).*dt, subsCurve(1:MaxIteration,i)  ,'linewidth',6, 'Color', plotStyle{i});
 
 legendLabel{i} = ['y = ' num2str(yco(i)*subs.cellSize)];
 
 hold on
    
end


set(gca,'FontSize',35)
legend(legendLabel)

% axis ij
% ylabel('Subsidence (m)','FontSize',35);
% xlabel('Time (My)','FontSize',35);
% axis tight 
% 
% maxUplift = min(min(sum(subs.subsidence,3)));
% maxSubs = max(max(sum(subs.subsidence,3)));
% 
% axis([0 dt*MaxIteration  maxUplift maxSubs]);
% grid on;
% set(gca,'FontSize',35)


% set figure position and dimension
width = 80;     % Width in inches
height = 80;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*15, height*10]); %<- Set size

%% Save image using save_fig

set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('SlipRateconst %d',iteration),...
   '-png', '-transparent', '-m12', '-q101');
    
