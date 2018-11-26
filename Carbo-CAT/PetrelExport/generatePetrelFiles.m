function generatePetrelFiles(glob, kk)
%% Writes and exports two ECLISPE keywords (grid geometry and porperties)

% [glob] = addSiliciclastic(glob);

for i = 1:2

% cd 'C:\Users\isabel16\Dropbox\CarboCAT2018\ModelOutput\09.04.2nd'
% 
% % load data from file
% glob=load('globalArrays.mat', 'strata','thickness','facies' );

if i == 1
    strata = glob.strata(:,:,1:glob.totalIterations);
    thickness = glob.thickness(:,:,1:glob.totalIterations);
    facies = glob.facies(:,:,1:glob.totalIterations);
    upscaleN=5; %set the number of iteration to group  
else  
    maxIt = find(glob.strata(1,1,:) ~= 0,1,'last');    
    strata = glob.strata(:,:,glob.totalIterations+1:maxIt+10);
    thickness = glob.thickness(:,:,glob.totalIterations+1:maxIt+10);
    facies = glob.facies(:,:,glob.totalIterations+1:maxIt+10);  
    upscaleN=1; %set the number of iteration to group  
end

id = kk;
idstr = num2str(id);
% for id=1

%     fileID = sprintf('strataSaved%d.mat',id);    
%     filename= fullfile('InputFiles',fileID);
%     strata=load(filename, 'strata');
%     strata=strata.strata;
%        
%     fileID = sprintf('thicknessSaved%d.mat',id);    
%     filename= fullfile('InputFiles',fileID);
%     thickness=load(filename, 'thick');
%     thickness=thickness.thick;
%     
%     fileID = sprintf('faciesSaved%d.mat',id);    
%     filename= fullfile('InputFiles',fileID);
%     facies=load(filename, 'facies');
%     facies=facies.facies;
        
    %upscale
%     upscaleN=10; %set the number of iteration to group  
    dx=200; %in m
    limitH=1; %elevation distance to recognise faults
    removeThin=0.0; %remove thin cells minimum thickness
    
    [strataUpscaled]= upscaleModelGrid(glob,upscaleN,strata,i);
    [strataUpscaled]= removeThinCells(strataUpscaled,removeThin);
    [faciesUpscaled] = upscaleModelFacies(upscaleN,strata,facies,thickness,i); %for Carbo-CAT
    
%     %% add siliciclastic strata
%     [strataUpscaled,faciesUpscaled] = addSiliciclastic(strataUpscaled, faciesUpscaled);
    
if i == 1
    strataUp_1 = strataUpscaled;
    faciesUp_1 = faciesUpscaled; 
else
    strataUp_2 = strataUpscaled;
    faciesUp_2 = faciesUpscaled;
end

clear faciesUpscaled 
clear strataUpscaled 
clear strata
clear facies
clear thickness
end  

faciesUpscaled = cat(3,faciesUp_1,faciesUp_2);
strataUpscaled = cat(3,strataUp_1,strataUp_2(:,:,2:end));

%     plotCrossSectionX_UpscaledforSeismic(strataUpscaled)
    
    filenameGrid=['Grid' idstr '.txt'];
    PetrelGrid(strataUpscaled,dx,filenameGrid,limitH);

    filenameFacies=['Facies' idstr '.txt'];
    PetrelFacies(strataUpscaled,faciesUpscaled,filenameFacies);

    
    
    
    
end
