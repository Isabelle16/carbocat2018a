%% Plot data from file

% cd 'C:\Users\isabel16\Dropbox\SponsorMeetingMay2018\sensitivityAnalysis\13_Model' 
cd 'C:\Users\isabel16\Dropbox\CarboCAT2018\ModelOutput' 

kk = 1;
% for kk = 1:2
% load data from file
% glob=load(sprintf('globalArrays%d.mat',kk) ,'strata','thickness','facies', ...
%     'wave','numberOfLayers', 'faciesColours', 'ySize', 'xSize', 'SL','totalIterations','deltaT','subsidenceForPlot');
% glob=load(sprintf('globalArrays.mat') ,'strata','thickness','facies', ...
%    'numberOfLayers', 'faciesColours', 'ySize', 'xSize', 'SL','totalIterations','deltaT','wave2');
glob=load(sprintf('globalArrays.mat'));
% subs=load('C:\Users\isabel16\Dropbox\CarboCAT2018\Carbo-CAT\params\subsidenceMap.mat');


% subs = load(sprintf('subsArrays%d.mat',kk));
% subs.subsidence = glob.subsidenceForPlot;

glob.figureNum = ''; 

glob.plotFromFile = true;


iter = [glob.totalIterations];
% set cross-sections position
xPosition = [40]; 
yPosition = [55];

 
% for i = 1:size(iter,2)
%     
%     iteration = iter(i);
% %     subPrintFromFile(glob, subs, iteration, xPosition, yPosition,kk);
%     subPrintFromFile(glob, iteration, xPosition, yPosition,kk);
% end

%% Generate petrel file
generatePetrelFiles(glob, kk);


%% clear variables
clearvars -except kk

% end


