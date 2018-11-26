%% Add post carbonate succession
% close all;
% clear all;
% clc;
% 
% % cd 'C:\Users\isabel16\Dropbox\SponsorMeetingMay2018\sensitivityAnalysis\13_Model' 
cd 'C:\Users\isabel16\Dropbox\CarboCAT2018\ModelOutput\Model1_HG-LR-GH' 

kk = 1;
% for kk = 9
% load data from file
% glob=load(sprintf('globalArrays%d.mat',kk) ,'strata','thickness','facies', ...
%     'ySize', 'xSize','totalIterations','deltaT');

glob=load(sprintf('globalArrays.mat') ,'strata','thickness','facies', ...
    'ySize', 'xSize','totalIterations','deltaT');

[glob] = addSiliciclastic(glob);



% Generate petrel file
generatePetrelFiles(glob, kk);


% clear variables
% clearvars -except kk
% end
