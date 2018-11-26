function sourceToSinkAnalysis(glob,subs)
%% Print source-to-sink map
% clear all;
% close all;
% clc;


% 
% cd 'C:\Users\isabel16\Dropbox\CarboCAT2018\ModelOutput\HalfGrabens_referenceModel'
% 
% glob=load(sprintf('globalArrays.mat'));
% %% Load subsidence and select the desired area
% subs=load('C:\Users\isabel16\Dropbox\CarboCAT2018\Carbo-CAT\params\subsidenceMap.mat');
% 
% subs.subsidence = subs.subsidence(210:320,123:203,:);

var1 = glob.totalCarboProdVol;
entrainedVol = sum(sum(glob.entrainVol));

currentDeposVol = sum(sum(glob.currentDeposVol));
gravityDeposVol = sum(sum(glob.gravityDeposVol));
totalDeposVol = currentDeposVol + gravityDeposVol;
lostVol = entrainedVol - totalDeposVol;


entrainPerc = entrainedVol/var1*100;
currentDeposPerc = currentDeposVol/totalDeposVol*100;
gravityDeposPerc = gravityDeposVol/totalDeposVol*100;


for k = 1:3

if k == 1
 var = glob.entrainArea;  
 varName = 'entrainArea';
elseif k == 2
 var = glob.currentDeposArea; 
 varName = 'currentDeposArea';
else
 var = glob.gravityDeposArea; 
 varName = 'gravityDeposArea';
end
   
sourceToSinkGraphic(glob,subs,var,varName,k);

clear var
clear varName
end


end

