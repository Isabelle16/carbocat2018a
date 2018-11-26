function plotChronostratSectionX_dynamic(glob,xPos,iteration,kk)
 
% ff = glob.figureNum;
% chronoPlot=figure(ff);
chronoPlot=figure('Visible','off');

thicknessPerY=sum(glob.numberOfLayers(:,xPos,2:end),3);
longA=find(thicknessPerY>0, 1, 'last' );  

    for i=0:10
        patch(0,0,i); % use a dummy patch to force colour map to range 0-10
    end

    for k=1:iteration-1

        for y = 1:longA
            % xco is a vector containing x-axis coords for the corner points of
            % each strat section grid cell. Yco is the equivalent y-axis vector
            xco = [y,y,y+1,y+1];
            
            
            faciesList = glob.facies{y,xPos,k+1};
            if max(faciesList) > 0
                cellHeight = glob.deltaT / (glob.numberOfLayers(y,xPos,k+1));
            else
                cellHeight = glob.deltaT;
            end
            cellBase = k*glob.deltaT;

            % Now draw the facies, however many there are...
            %cellBase = cellBase+cellHeight; % to account for in-situ facies cell
            for fLoop = 1:glob.numberOfLayers(y,xPos,k+1)

                tco = [cellBase, cellBase+cellHeight, cellBase+cellHeight, cellBase];
                fCode = faciesList(fLoop);
                if fCode > 0
                    faciesCol = [glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)];
                    patch(xco, tco, faciesCol,'EdgeColor','none');
                end
                 cellBase = cellBase + cellHeight;
            end
        end
    end

    % Force 2 ticks on the y axis
%     set(chronoPlot,'YTick',[0 (glob.deltaT * iteration-1)]);
%     set(chronoPlot,'XTick',[1:10: longA]);
%     axis([1 longA+1 0 glob.deltaT * iteration-1]);
    xlabel('y(km)','FontSize',24);
    ylabel('E.M.T. (My)','FontSize',24);
    ax = gca;
    ax.LineWidth = 0.6;
    ax.FontSize = 20;
    ax.FontWeight = 'bold';
    axis tight
    

xticks([1 10 20 30 40 50 60 70 80 90 100]);
xticklabels (0:2:20);
%% General
% set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(chronoPlot, 'Position', [0.5 0.5 width*20, height*10]); %<- Set size



%% Save image using save_fig

set(chronoPlot,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('xChronoPlot %dx%dx%d',iteration,xPos,kk),...
   '-png', '-transparent', '-m12', '-q101');  
      
    
end