%creates a random facies map
clear all
xSize=10;
ySize=10;
totalFacies=3;
for x=1:xSize
    for y = 1:ySize
        
        %map(y,x)=2;
        %creates a random facies map
        map(y,x)=unidrnd(totalFacies)-1;
    end
end

 save('newRandomFaciesMap25.txt','map','-ascii');
%save('newTopoMap.txt','map','-ascii');