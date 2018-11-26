function [glob] = initializeCrossPltfTransParams(glob)


fileIn = fopen(glob.currentRoutineFName);

glob.transThreshold = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.minEntrainThick = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.currentMaxShearStress = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.currentDepthCutOff = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.currentDump = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.tauCurrentY = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.tauCurrentX = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.depositFractionFromSuspension = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);



glob.deltaRho = glob.rhoSolid(1) - glob.rhoAmbient; %sediment mass density excess(kg/m3)
angleReposeCoarse = 20;
angleReposeFine = 5;
tetaCoarse = sind(angleReposeCoarse); %dimensionless Shields variable
tetaFine = sind(angleReposeFine); %dimensionless Shields variable
glob.tauCriticalBedload = glob.deltaRho*glob.gravity*0.0001*tetaCoarse;
glob.tauCriticalSuspension = glob.deltaRho*glob.gravity*0.00001*tetaFine;


% glob.tauCriticalBedload = 0.2; 
% glob.tauCriticalSuspension = 0.02; %0.05
end