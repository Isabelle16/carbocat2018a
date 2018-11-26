function [glob] = initializeModelParams(glob,fName)

%% Read the params file
fileIn = fopen(fName);

glob.modelName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); % Read to the end of the line to skip any label text

% Read parameters from the main parameter file
glob.totalIterations = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);
glob.deltaT = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

glob.eustaticCurveNum = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);
glob.eustaticOrderNum = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);
glob.shiftIteration = fscanf(fileIn,'%d', 1); 
dummyLabel = fgetl(fileIn);

glob.SLPeriod = cell(glob.eustaticCurveNum,1);
glob.SLAmp = cell(glob.eustaticCurveNum,1);

for i = 1:glob.eustaticCurveNum
               
glob.SLPeriod{i,1} = fscanf(fileIn,'%f', glob.eustaticOrderNum);
dummyLabel = fgetl(fileIn);

glob.SLAmp{i,1} = fscanf(fileIn,'%f', glob.eustaticOrderNum);
dummyLabel = fgetl(fileIn);

end

fprintf('%d %d %d %d', glob.SLPeriod1, glob.SLAmp1, glob.SLPeriod2, glob.SLAmp2);

glob.CADtMin = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);
glob.CADtMax = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);

glob.BathiLimit =  fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

glob.maxProdFacies = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);

for j = 1:glob.maxProdFacies
    glob.prodRate(j) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);

    glob.surfaceLight(j) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);
    if glob.surfaceLight(j)>500
    glob.extinctionCoeff(j) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);
    glob.saturatingLight(j) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
    else
    glob.profCentre (j)= glob.surfaceLight(j);
    glob.profWidth (j)= fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);
    glob.profSlope (j)= fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);
    end
    glob.transportProductFacies(j) = fscanf(fileIn,'%d', 1);
    dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
    glob.transportFraction(j) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
    glob.medianGrainDiameter(j) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
    glob.minEnergy(j) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
    glob.maxEnergy(j) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
    glob.killValue(j) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);


    fprintf('Breakdown of facies %d creates facies %d at rate %3.2f of accumulated thickness \n', j, glob.transportProductFacies(j), glob.transportFraction(j));
    
    glob.prodRate(j) = glob.prodRate(j) * glob.deltaT; % Adjust production rates for timestep
    
%% Calculate the water depth cutoff below which production rate is zero
% Factory types will only occur above this water depth cutoff
    wd = 0.0;
    if glob.surfaceLight(j)>500
    while tanh((glob.surfaceLight(j) * exp(-glob.extinctionCoeff(j) * wd))/ glob.saturatingLight(j)) > 0.000001 && wd < 10000
        glob.prodRateWDCutOff(j) = wd;
        wd = wd + 0.1;
    end
    else
         while  (1/ (1+((wd-glob.profCentre(j))./glob.profWidth(j)).^(2.*glob.profSlope(j))) ) > 0.000001 && wd < 10000
        glob.prodRateWDCutOff(j) = wd;
        wd = wd + 0.1;
         end 
    end
    fprintf('Facies %d has production cutoff at %3.2f m water depth\n', j, glob.prodRateWDCutOff(j));

end

glob.pelagicProdRate = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
glob.pelagicMaxWave = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
glob.pelagicMaxCurrent = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);

glob.subRate = glob.subRate * glob.deltaT;% Adjust production rates for timestep

glob.CARulesFName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
fprintf('CA rules filename %s \n', glob.CARulesFName);

glob.initFaciesFName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
fprintf('Initial condition facies map filename %s \n', glob.initFaciesFName);

glob.initBathymetryFName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
fprintf('Initial bathymetry map filename %s \n', glob.initBathymetryFName);

glob.concFName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
fprintf('Carbonate concentration filename %s \n', glob.concFName);

glob.silicFName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
fprintf('Siliciclastic parameters filename %s \n', glob.silicFName);

glob.curveFName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
fprintf('Water level curve filename %s \n', glob.curveFName);

glob.processFName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
fprintf('Processes filename %s \n', glob.processFName);

glob.lobyteFName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
fprintf('Lobyte filename %s \n', glob.lobyteFName);

glob.waveRoutineFName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
fprintf('Wave routine filename %s \n', glob.waveRoutineFName);

glob.currentRoutineFName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); %fscanf(fileIn,'%s', 1);
fprintf('Cross platform transpor routine filename %s \n', glob.currentRoutineFName);


%% Read the cellular automata rules
import = importdata(glob.CARulesFName,' ',1);
glob.CARules = import.data;

%% Read the number and ages of time lines to be plotted on cross sections. Age = iteration number
glob.timeLineCount = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);
glob.timeLineAge = zeros(1,glob.timeLineCount+1);

glob.timeLineAge = fscanf(fileIn,'%d', glob.timeLineCount); % reads glob.timeLineCount values from the file
dummyLabel = fgetl(fileIn);
fprintf('Plotting %d timelines from iteration %d to %d\n', glob.timeLineCount, glob.timeLineAge(1), glob.timeLineAge(glob.timeLineCount));

%% Read the number and ages of maps to be plotted in the relevant figure. Age = iteration number
glob.mapCount = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);
glob.mapAge = zeros(1,glob.mapCount+1);

glob.mapAge = fscanf(fileIn,'%d', glob.mapCount); % reads glob.timeLineCount values from the file
dummyLabel = fgetl(fileIn);
fprintf('Plotting %d maps from iteration %d to %d\n', glob.mapCount, glob.mapAge(1), glob.mapAge(glob.mapCount));

%% Get the data of the water level curve
import = importdata(glob.curveFName);
glob.curveImported = import;

end