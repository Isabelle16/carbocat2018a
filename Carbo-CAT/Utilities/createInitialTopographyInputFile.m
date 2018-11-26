function createInitialTopographyInputFile

    xSize = 110;
    ySize = 75;
    wd = zeros(ySize, xSize);

%     Set the initial water depth as flat surface with glob.initWD from the parameter file
    wd(:,:) = 2;
%     wd(1:30,:) = 200;

% %     Set the initial water depth as a ramp surface deepening with increasing y
%     for y = 1:int16(ySize)
%        wd(y,:) = y-1;
%     end
    
    figure(4)
    g1 = surface(-wd); % NB water depths are positive but to plot as elevation convert to negative
    view([-85 25]);
    set(g1,'LineStyle','none');
    grid on;
    xlabel('X Distance (km)');
    ylabel('Y Distance (km)');
    
    save('C:\Users\isabel16\Dropbox\gits2s\carbocatS2S\Carbo-CAT\params\initialTopographySubSection.txt', 'wd', '-ascii');
    
end
