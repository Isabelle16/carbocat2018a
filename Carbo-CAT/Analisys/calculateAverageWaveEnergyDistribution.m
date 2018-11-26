function [glob] = calculateAverageWaveEnergyDistribution(glob)

glob.averageWaveEnergy = zeros(glob.ySize, glob.xSize); %, glob.totalIterations);

glob.averageWaveEnergy = sum(glob.wave,3)/(glob.totalIterations-1); 

end