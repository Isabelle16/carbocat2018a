function [glob] = initializeLobyteParameters(glob)


fileIn = fopen(glob.lobyteFName);


glob.gravity = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.rhoAmbient = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.gravityD50 = fscanf(fileIn,'%f', 2);
dummyLabel = fgetl(fileIn);
glob.rhoSolid = fscanf(fileIn,'%f', 2);   %glob.rhoSolid = [carbonate siliciclastic]
dummyLabel = fgetl(fileIn);
glob.flowVolumConcentration = fscanf(fileIn,'%f', 2);
dummyLabel = fgetl(fileIn);
glob.concentrationThreshold= fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.deposVelocity = fscanf(fileIn,'%f', 2);
dummyLabel = fgetl(fileIn);
glob.minFlowThick = fscanf(fileIn,'%f', 1);
dummyLabel = fgetl(fileIn);
glob.fracDepos = fscanf(fileIn,'%f', 2);
dummyLabel = fgetl(fileIn);
glob.flowRadiationFactor = fscanf(fileIn,'%f', 2);
dummyLabel = fgetl(fileIn);
glob.depositSlopeFactor = fscanf(fileIn,'%f', 2);




glob.gammaAmbient = glob.rhoAmbient.* glob.gravity;% specific weight of ambient fluid (water) kg/m2.*s2 
glob.gammaSolid = glob.rhoSolid.* glob.gravity; % specific weight of the grains kg/m2.*s2 
glob.rhoFlow = glob.rhoSolid.* glob.flowVolumConcentration; % 1.70;  % flow mass density (kg/m^3) (specific mass)
glob.reducedGravity = abs(glob.gravity.*((glob.rhoFlow - glob.rhoAmbient)./glob.rhoAmbient)); % gravity reduced by the buoyancy force when the flow is underwater 
a = glob.gammaSolid .* glob.flowVolumConcentration;
b = glob.gammaAmbient .* (1 - glob.flowVolumConcentration);
glob.gammaFlow = a + b;    % specific weight of a mixture kg/m2.*s2  

end