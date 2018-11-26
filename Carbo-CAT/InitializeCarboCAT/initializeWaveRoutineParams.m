function [glob] = initializeWaveRoutineParams(glob)


fileIn = fopen(glob.waveRoutineFName);

glob.yWind = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.xWind = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.winDir = textscan(fileIn,'%s',1);
dummyLabel = fgetl(fileIn); glob.winDir = cell2mat(glob.winDir{1});
glob.windVelocity = fscanf(fileIn,'%f', 1);   %glob.rhoSolid = [carbonate siliciclastic]
dummyLabel = fgetl(fileIn);
glob.wavePeriod = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.waveBase = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.dump = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.extFetch = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.reefExtent = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
end