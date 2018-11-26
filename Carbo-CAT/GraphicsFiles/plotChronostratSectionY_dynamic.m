function plotChronostratSectionY_dynamic(glob, yPos, iteration,kk)
% ff = glob.figureNum;
% chronoPlot=figure(ff);
chronoPlot=figure('Visible','off');


      thicknessPerX=sum(glob.numberOfLayers(yPos,:,2:end),3);
    longA=find(thicknessPerX>0, 1, 'last' );  


    for i=0:10
        patch(0,0,i); % use a dummy patch to force colour map to range 0-10
    end

    for k=1:iteration-1

        for x = 1:longA
            % xco is a vector containing x-axis coords for the corner points of
            % each strat section grid cell. Yco is the equivalent y-axis vector
            xco = [x,x,x+1,x+1];
            
            
            faciesList = glob.facies{yPos,x,k+1};
            if max(faciesList) > 0
                cellHeight = glob.deltaT / (glob.numberOfLayers(yPos,x,k+1));
            else
                cellHeight = glob.deltaT;
            end
            cellBase = k*glob.deltaT;

            % Now draw the facies, however many there are...
            %cellBase = cellBase+cellHeight; % to account for in-situ facies cell
            for fLoop = 1:glob.numberOfLayers(yPos,x,k+1)

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
%     set(chronoPlot,'YTick',[0 (glob.deltaT * iteration)]);
%     set(chronoPlot,'XTick',[1:10: longA]);
    axis([1 longA+1 0 glob.deltaT*iteration]);
ylabel('E.M.T. (My)','FontSize',24,'FontWeight','bold');
xlabel('x(km)','FontSize',24,'FontWeight','bold');
    axis tight

    ax = gca;
    ax.LineWidth = 0.6;
    ax.FontSize = 20;
    ax.FontWeight = 'bold';
    axis tight
    
    
    
xticks([1 25 50 75 100 125 150]);
xticklabels (0:5:30);
    
   %% General
% set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(chronoPlot, 'Position', [0.5 0.5 width*20, height*10]); %<- Set size


%% Save image using save_fig

set(chronoPlot,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('yChronoPlot %dx%dx%d',iteration,yPos,kk),...
   '-png', '-transparent', '-m12', '-q101');   
    
    
  
 
    
end