%% Factories production rate analysis (NB MODIFY FOR SILICICLASTIC?)
close all;
% clear all;
% clc;

cd 'C:\Users\isabel16\Dropbox\CarboCAT2018\ModelOutput\1_Model'
% cd '/Users/Isabella/Dropbox/CarboCAT2018/ModelOutput/1_Model'

%% load data from file
glob=load('globalArrays.mat','strata','totalIterations','deltaT','thickness','faciesColours');
% subs=load('subsArrays.mat');
% initialBathymetry = zeros(subs.ySize,subs.xSize);
% initialBathymetry(:,:) = -2;
MaxIt = glob.totalIterations;
dt = glob.deltaT;


% ffOne = figure(51);
% ffOne = figure('Visible','off');

%% Coordinates of the points to plot
xco = [75 75 75 75 75];
yco = [18 20 25 30 35];
colonizationNum = 0;
for i = 1:size(xco,2)
    y = yco(i);
    x = xco(i);
    colonizationNum = 0;
      for j = 1:MaxIt
        % Get the facies currently present at y x for previous iteration
        pos = find(glob.facies{y,x,j}(:)<4);
        if pos > 0
        oneFacies = glob.facies{y,x,j}(pos);
        fCode = oneFacies;
        oneThick = glob.thickness{y,x,j}(pos);
        if fCode > 0
            faciesCol = [glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)];

            oneProdRate = oneThick/dt; % current cell prod rates in m/My

            if oneThick > 0
               colonizationNum = colonizationNum +1;
            end

            prodRates(j,i) = oneProdRate;
            faciesNum(j,i) = oneFacies;
            colors{j,i} = faciesCol;
        else
        prodRates(j,i) = 0;
        colors{j,i} = 0;
        faciesNum(j,i) = 0;
        end
            
         colNum(i) = colonizationNum;
       else
        prodRates(j,i) = 0;
        colors{j,i} = 0;
        faciesNum(j,i) = 0;
       end
      
      end
end



maxProd = 6000;
minProd = 0;

plotStyle = {'b','k','r','y','m'};
for i = 1:size(xco,2)  
    
ffOne = figure(i);

plot((1:MaxIt).*dt, prodRates(1:MaxIt,i)  ,'linewidth',3, 'Color', plotStyle{i});
title(['y =' num2str(yco(i)),' - Colonisation Events =  ' num2str(colNum(i))]);


axis([0 dt*MaxIt minProd maxProd]);
grid on;
set(gca,'FontSize',35)
ylabel('Prod rate (m/My)','FontSize',35);
xlabel('Time (My)','FontSize',35);
axis tight
% set figure position and dimension
width = 80;     % Width in inches
height = 80;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*15, height*10]); %<- Set size

 
%  legendLabel{i} = ['y = ' num2str(yco(i))];
     
end
% set(gca,'FontSize',35)
% % legend(legendLabel)
% 
% ylabel('Prod rate (m/My)','FontSize',35);
% xlabel('Time (My)','FontSize',35);
% axis tight

% % set figure position and dimension
% width = 80;     % Width in inches
% height = 80;    % Height in inches
% set(ffOne, 'Position', [0.5 0.5 width*15, height*10]); %<- Set size

%% Save image using save_fig

% set(ffOne,'Color','none'); % set transparent background
% set(gca,'Color','none');

% export_fig( sprintf('prodRateAnalysis %d',iteration),...
%    '-png', '-transparent', '-m12', '-q101');




