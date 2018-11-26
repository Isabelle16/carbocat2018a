function [subs] = readFaultsExternal(subs,fileIn)






subs.modelName = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); % Read to the end of the line to skip any label text
subs.maxF = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);
subs.maxT = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);
subs.timeStep = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
subs.xSize = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);
subs.ySize = fscanf(fileIn,'%d', 1);
dummyLabel = fgetl(fileIn);
subs.cellSize= fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
subs.regSubsidence = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);

for f=1:subs.maxF
    subs.AFIndex(f) = fscanf(fileIn,'%d', 1);

    dummyLabel = fgetl(fileIn);
    subs.fHeight(f) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);
    subs.fDef(f) = fscanf(fileIn,'%f', 1);

    dummyLabel = fgetl(fileIn);
    subs.fDip(f) = fscanf(fileIn,'%f', 1);

    dummyLabel = fgetl(fileIn);
    subs.curveIndex(f) = fscanf(fileIn,'%d', 1);

    dummyLabel = fgetl(fileIn);
    subs.rateIndex(f) = fscanf(fileIn,'%d', 1);
    dummyLabel = fgetl(fileIn);
    subs.rotIndex(f) = fscanf(fileIn,'%d', 1);

    dummyLabel = fgetl(fileIn);
    subs.xI(f) = fscanf(fileIn,'%d', 1);
    dummyLabel = fgetl(fileIn);
    subs.yI(f) = fscanf(fileIn,'%d', 1);
    dummyLabel = fgetl(fileIn);
    subs.fDir(f) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);
    subs.fLengthI(f) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);
    subs.fLengthF(f) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);
    subs.planeViewIndex(f) = fscanf(fileIn,'%f', 1);

    dummyLabel = fgetl(fileIn);
    subs.fwHeight(f) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);
    subs.fwDef(f) = fscanf(fileIn,'%f', 1);

    dummyLabel = fgetl(fileIn);
    subs.startingTime(f) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);
    subs.endingTime(f) = fscanf(fileIn,'%f', 1);
    dummyLabel = fgetl(fileIn);
end

end