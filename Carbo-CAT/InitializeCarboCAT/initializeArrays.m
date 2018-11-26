function [glob] = initializeArrays(glob)

%% Initialize main arrays

glob.faciesCount = uint16(zeros(glob.maxIts, glob.maxFacies+2)); % two extra, one for change count, one for blob count
glob.facies = num2cell(uint8(zeros(glob.ySize,glob.xSize, glob.maxIts)));
glob.thickness = num2cell(double(zeros(glob.ySize,glob.xSize, glob.maxIts)));
glob.numberOfLayers=zeros(glob.ySize, glob.xSize, glob.maxIts);
glob.wd = zeros(glob.ySize, glob.xSize, glob.maxIts);
glob.strata = zeros(glob.ySize, glob.xSize, glob.maxIts);

glob.transpDist = num2cell(double(zeros(glob.ySize,glob.xSize, glob.maxIts)));
glob.transVolMap = zeros(glob.ySize, glob.xSize);

%% Load the initial facies map file using the file name specified in the paramter file
oneFaciesMap = load(glob.initFaciesFName, '-ASCII');

checkMaxFacies = max(max(oneFaciesMap));
if checkMaxFacies > glob.maxProdFacies
    fprintf('WARNING: %d producing facies in the initial facies map from %s versus %d maximum facies in from the parameter file\n',checkMaxFacies, glob.initFaciesFName, glob.maxProdFacies);
end
for y=1:glob.ySize
    for x=1:glob.xSize
        glob.facies{y,x,1}(1)=oneFaciesMap(y,x);
        if glob.facies{y,x,1}(1)>0
            glob.numberOfLayers(y,x,1)=1;
        else
            glob.numberOfLayers(y,x,1)=0;    
        end
    end
end

%% Load the initial bathymetry map using the file name specified in the parameter file
oneBathymetryMap = (load(glob.initBathymetryFName, '-ASCII'));
glob.wd(:,:,1) = oneBathymetryMap;

% Set the elevation of all the stratal surfaces to initial water depth
% Note that zero is the model datum so initial surface elevation is zero - initial
% water depth
glob.strata(:,:,:) = -glob.wd; 
glob.strataOriginalPosition = glob.strata;

% %Load a subsidence map from an external file.
% %Comment out lines 19-20 and activate line 14 in the calculateSubsidence.m  
% oneSubsidenceMap = load('C:\George\NewCarboCAT\Subsidence\faultparams\DiffSub.txt'); % The path to the file with the subsidence map
% glob.subRateMap = oneSubsidenceMap;
% glob.subRateMap = glob.subRateMap * glob.deltaT;% Adjust production rates for timestep

    a=strcmp(glob.seaLevelRoutine,'file');
    if a==0
        % initialize sea-level curve here
        for i=1:glob.maxIts
            %add a flat line initially
            if i<1
                emt = double(80) * glob.deltaT;
                glob.SL(i)= ((sin(pi*((emt/glob.SLPeriod{1,1}(1))*2)))* glob.SLAmp{1,1}(1))+ (sin(pi*((emt/glob.SLPeriod{1,1}(2))*2)))* glob.SLAmp{1,1}(2)-2;
            elseif i <= glob.shiftIteration 
                emt = double(i) * glob.deltaT;
                glob.SL(i)= ((sin(pi*((emt/glob.SLPeriod{1,1}(1))*2)))* glob.SLAmp{1,1}(1))+ (sin(pi*((emt/glob.SLPeriod{1,1}(2))*2)))* glob.SLAmp{1,1}(2)-2;
            elseif i > glob.shiftIteration 
                emt = double(i) * glob.deltaT;
                glob.SL(i) = ((sin(pi*((emt/glob.SLPeriod{2,1}(1))*2)))* glob.SLAmp{2,1}(1))+ (sin(pi*((emt/glob.SLPeriod{2,1}(2))*2)))* glob.SLAmp{2,1}(2)-2;
                
            end
        end
    else
        %re-create the sea-level curve using the file
        glob.SL=glob.curveImported;
    end

    
%% Set up the CA iteration counting arrays
glob.CADtCount=zeros(glob.ySize, glob.xSize); % Set Dt counter to zero
glob.CADtPerIteration = ones(glob.ySize, glob.xSize) * glob.CADtMax; % Set the timesteps required per iteration to the input parameter value

%% Initialize the carbonate concentration array
%Read the concentration data
fileInConcentration = fopen(glob.concFName);
glob.inputRateCarbonate=fscanf(fileInConcentration,'%f', 1);
dummyLabel = fgetl(fileInConcentration);
glob.yInitConcentration=fscanf(fileInConcentration,'%f', 1);
dummyLabel = fgetl(fileInConcentration);
glob.xInitConcentration=fscanf(fileInConcentration,'%f', 1);
dummyLabel = fgetl(fileInConcentration);
glob.diffYplus=fscanf(fileInConcentration,'%f', 1);
dummyLabel = fgetl(fileInConcentration);
glob.diffYminus=fscanf(fileInConcentration,'%f', 1);
dummyLabel = fgetl(fileInConcentration);
glob.diffXplus=fscanf(fileInConcentration,'%f', 1);
dummyLabel = fgetl(fileInConcentration);
glob.diffXminus=fscanf(fileInConcentration,'%f', 1);
dummyLabel = fgetl(fileInConcentration);
glob.initialVolumeValue=fscanf(fileInConcentration,'%f', 1);
dummyLabel = fgetl(fileInConcentration);

glob.carbonateVolMap=zeros(glob.ySize,glob.xSize);
%set an homogeneus initial concentration value (sea water is typical
%0.15kg/m3)
glob.carbonateVolMap(:,:)=glob.initialVolumeValue;

%% Load a colour map for the CA facies and hiatuses
glob.faciesColours =load('colorMaps/faciesColourMap_4facies.txt');

%% Set producing facies controls that depend on number of neighbour parameters
oneFacies = 1:glob.maxProdFacies;
glob.prodScaleMin(oneFacies) = glob.CARules(oneFacies,2);
glob.prodScaleMax(oneFacies) =  glob.CARules(oneFacies,3);
glob.prodScaleOptimum(oneFacies) = ((glob.prodScaleMax(oneFacies) - glob.prodScaleMin(oneFacies)) / 2)+glob.prodScaleMin(oneFacies);

if size(glob.faciesColours,1) < glob.maxFacies % So if too few rows in the colour map, give a warning...
    fprintf('Only %d colours in colour map colorMaps/faciesColourMap.txt but %d facies in model\n', size(1), glob.maxFacies);
    fprintf('This could get MESSY!\n\n\n\n');
end

end






