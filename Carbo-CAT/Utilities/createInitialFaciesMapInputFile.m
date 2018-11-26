function createInitialFaciesMapInputFile

    xSize = 110;
    ySize = 75;
    faciesMap = zeros(ySize, xSize);
    faciesNum = 3;

    % Define the initial condition for the carbonate facies as one blob for
    % each facies on the left-right diagonal
    %centrePoint = [xSize / 3,xSize / 2, xSize / 1.5]; % these are the centre point x AND y coords for initial facies blobs

    % so loop through the three sets of x&y coords
    %for j=1:3
      % x=centrePoint(j);
     %  y=centrePoint(j);

       % now for each point define a 3 cell wide blob around the specified xy
       % coord
    %   for k=x-2:x+2
    %       for l=y-2:y+2
    %        oneFaciesMap(l,k)=j;
    %       end
    %   end
    %end

    % Create a random facies map with equiprobable facies occurrence in each cell
    faciesMap = round(rand(ySize, xSize) * faciesNum);
    
    save('C:\Users\isabel16\Dropbox\gits2s\carbocatS2S\Carbo-CAT\params\initialFaciesMapSubSection.txt', 'faciesMap', '-ascii');
end
