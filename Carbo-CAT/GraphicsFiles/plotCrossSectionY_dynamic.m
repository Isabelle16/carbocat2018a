function plotCrossSectionY_dynamic(glob, y, iteration,kk)


% ff = glob.figureNum;
% crossSectionPlot=figure(ff);
crossSectionPlot=figure('Visible','off');

it = iteration;

thicknessPerX=sum(glob.numberOfLayers(y,:,2:end),3);

long=find(thicknessPerX>0, 1, 'last' );

if isempty(long)
    long=glob.xSize;
end

maxDepth = min(min(glob.strata(:,:,1))); % Find the lowest (i.e. deepest) values in strata array
maxDepth = maxDepth - 5;

% Draw basement
    for x = 1:long
        xco = [x,x,x+1,x+1]; 
        zco = [maxDepth, glob.strata(y,x,1), glob.strata(y,x,1), maxDepth];
        patch(xco, zco, [0.7 0.7 0.7],'EdgeColor','none');
    end

    for x = 1:long
       
       for k=2:it
            
        cell=glob.numberOfLayers(y,x,k);
        
        while cell>0
            
            xco = [x,x,x+1,x+1];
           
            allThick=sum(glob.thickness{y,x,k}(1:cell));
            oneThick=sum(glob.thickness{y,x,k}(1:cell-1));
            top=glob.strata(y,x,k-1)+allThick;
            bottom=glob.strata(y,x,k-1)+oneThick;
            fCode = glob.facies{y,x,k}(cell); 

            % Draw the insitu production facies first
            if fCode>0
            zco = [bottom, top,top, bottom];
        
            faciesCol=[glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)]    ;
            patch(xco, zco, faciesCol,'EdgeColor','none');
       
            end
        cell=cell-1;
       end 
       end
    end
    

 
    
    % Loop through iterations and draw timelines
glob.timeLineAge = [100:150:3000];
glob.timeLineCount= size(glob.timeLineAge,2);  

    for i=1:glob.timeLineCount

        k = glob.timeLineAge(i);

        if k <= it
            for x = 1:long-1%glob.ySize-1
                % draw a marker line across the top and down/up the side of
                % a particular grid cell
                xco = [x,x+1,x+1];
                yco = [glob.strata(y,x,k), glob.strata(y,x,k), glob.strata(y,x+1,k)];
                    line(xco, yco, 'LineWidth', 2, 'color', 'black');

            end
            line([x+1,x+2],[glob.strata(y,x+1,k), glob.strata(y,x+1,k)],'LineWidth',2, 'color', 'black');
        end
    end

    % Draw the final sea-level
    xco = [1 long+1];
    yco = [glob.SL(it) glob.SL(it)];
    line(xco,yco, 'LineWidth',2, 'color', 'blue');
    
    
    
% %      if minDepth>glob.SL(it) 
% %          mm=minDepthp; 
% %      else
% %          mm=glob.SL(it);
% %      end
% %      axis([1 long+1 maxDepth mm]);
% %      l=numel(num2str(round(maxDepth)))-1;
% %      
% %      maxD=(10^(l-1))*(ceil(maxDepth/(10^(l-1))));
     
%      set(crossSectionPlot,'YTick',[maxD 0]);
ylabel('Elevation (m)','FontSize',24,'FontWeight','bold');
xlabel('x(km)','FontSize',24,'FontWeight','bold');
    axis tight
%     set(crossSectionPlot,'XTickLabel',[]);
ax = gca;
ax.LineWidth = 0.6;
ax.FontSize = 20;
ax.FontWeight = 'bold';
%     set(crossSectionPlot,'XTickLabel',[]);

xticks([1 25 50 75 100 125 150]);
xticklabels (0:5:30);
axis tight

    %% General
% set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(crossSectionPlot, 'Position', [0.5 0.5 width*20, height*10]); %<- Set size




%% Save image using save_fig

set(crossSectionPlot,'Color','none'); % set transparent background
set(gca,'Color','none');
% 
export_fig( sprintf('yCrossSection %dx%dx%d',iteration,y,kk),...
   '-png', '-transparent', '-m12', '-q101');

%  close(crossSectionPlot);


end