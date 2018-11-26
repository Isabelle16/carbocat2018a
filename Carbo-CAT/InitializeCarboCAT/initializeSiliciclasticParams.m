function [glob] = initializeSiliciclasticParams(glob, silicFName)

%% Initialize siliciclastic routine arrays and parameters 
glob.productionBySiliciclasticMap=ones(glob.ySize,glob.xSize,glob.maxProdFacies); %for the production kill value

fileInSiliciclastic = fopen(silicFName);

glob.inputSiliMax=fscanf(fileInSiliciclastic,'%f', 1);
dummyLabel = fgetl(fileInSiliciclastic);

glob.inputSiliPeriod=fscanf(fileInSiliciclastic,'%f', 1);
dummyLabel = fgetl(fileInSiliciclastic);

glob.sourceLength=fscanf(fileInSiliciclastic,'%f', 1); %number of input cells
dummyLabel = fgetl(fileInSiliciclastic);

glob.yInitSili=fscanf(fileInSiliciclastic,'%f', glob.sourceLength);
dummyLabel = fgetl(fileInSiliciclastic);
glob.xInitSili=fscanf(fileInSiliciclastic,'%f', glob.sourceLength);
dummyLabel = fgetl(fileInSiliciclastic);
glob.eventsPerIteration=fscanf(fileInSiliciclastic,'%f', 1);
dummyLabel = fgetl(fileInSiliciclastic);

glob.siliStartTime=fscanf(fileInSiliciclastic,'%f', 1);
dummyLabel = fgetl(fileInSiliciclastic);

% Initialize siliciclastic input sinusoid
% General equation: y = A sin(Bx + C) + D
% A = amplitude; 2pi/B = period; C = phase shift; D vertical shift

glob.inputSiliAmplitude = glob.inputSiliMax/2;
phaseShift = 0;
verticalShift = glob.inputSiliAmplitude; 
for i=1:glob.maxIts
    emt = double(i) * glob.deltaT;
    
    glob.inputSili(i) = glob.inputSiliAmplitude * sin(((emt/glob.inputSiliPeriod).*2.*pi) + phaseShift) + verticalShift;
    
end

end
