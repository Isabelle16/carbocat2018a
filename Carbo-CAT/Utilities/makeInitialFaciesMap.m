function makeInitialFaciesMap(void )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

maxX = 50;
maxY = 50;
totalFacies = 3; % Total number of facies, not including 0 which is a hiatus value
initFaciesMap = zeros(maxY, maxX);

for x=1:maxX
    for y=1:maxY
        initFaciesMap(y,x) = randi(totalFacies+1);
    end
end

initFaciesMap = initFaciesMap - 1; %max is totalFacies +1 so subtract 1 to make range 0 to totalFacies where 0 is hiatus

pcolor(initFaciesMap);

save('carbo-CAT\params\newInitFaciesMap.txt','initFaciesMap','-ASCII');

end

