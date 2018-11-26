function  plotCrossSectionX_forSeismic(glob,x,iteration,kk)

crossSectionPlot=figure('Visible','off');

it  = iteration;

thicknessPerY = sum(glob.numberOfLayers(:,x,2:end),3); %SAVED
long = find(thicknessPerY>0, 1, 'last' );
if isempty(long)
long = glob.ySize;
end


maxDepth = min(min(glob.strata(:,:,1))); % Find the lowest (ie deepest) values in strata array
maxDepth = maxDepth - 5;


% Draw basement
for y = 1:long 
    xco = [y,y,y+1,y+1]; 
    zco = [maxDepth, glob.strata(y,x,1), glob.strata(y,x,1), maxDepth];
%     patch(xco, zco, [0.7 0.7 0.7],'EdgeColor','none');
    patch(xco, zco, [0.7 0.7 0.7],'EdgeColor','none','FaceAlpha',.15); %% set trans
end

    
for y = 1:long

   for k=2:it

    cell=glob.numberOfLayers(y,x,k);

    while cell>0
        xco = [y,y,y+1,y+1];

        allThick=sum(glob.thickness{y,x,k}(1:cell));
        oneThick=sum(glob.thickness{y,x,k}(1:cell-1));
        top=glob.strata(y,x,k-1)+allThick;
        bottom=glob.strata(y,x,k-1)+oneThick;
        fCode = glob.facies{y,x,k}(cell); % Note this is zero for no depositon, 9 for subaerial hiatus


        % Draw the insitu production facies first
        if fCode>0
            zco = [bottom, top,top, bottom];
            faciesCol=[glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)]    ;
%             patch(xco, zco, faciesCol,'EdgeColor','none');
            patch(xco, zco, faciesCol,'EdgeColor','none','FaceAlpha',.15); %% set trans
        end

        cell=cell-1;
    end
   end
end

% Loop through iterations and draw timelines

 
% glob.timeLineAge = [100:150:3000];
glob.timeLineAge = [1:250:glob.totalIterations];

glob.timeLineCount= size(glob.timeLineAge,2);  

    for i=1:glob.timeLineCount

        k = glob.timeLineAge(i);

        if k <= it
            for y = 1:long-1%glob.ySize-1
                % draw a marker line across the top and down/up the side of
                % a particular grid cell
                xco = [y,y+1,y+1];
                yco = [glob.strata(y,x,k), glob.strata(y,x,k), glob.strata(y+1,x,k)];
%                 line(xco, yco, 'LineWidth',2, 'color', 'black');    
                line(xco, yco, 'LineWidth',1.5, 'color', 'green');  
            end
%             line([y+1,y+2],[glob.strata(y+1,x,k), glob.strata(y+1,x,k)],'LineWidth',2, 'color', 'black');
            line([y+1,y+2],[glob.strata(y+1,x,k), glob.strata(y+1,x,k)],'LineWidth',1.5, 'color', 'green');
        end
    end

% % Draw the final sea-level
% xco = [1 long+1];
% yco = [glob.SL(it) glob.SL(it)];
% line(xco,yco, 'LineWidth',2, 'color', 'blue');



ylabel('Elevation (m)','FontSize',24,'FontWeight','bold');
xlabel('y(km)','FontSize',24,'FontWeight','bold');
ax = gca;
ax.LineWidth = 0.6;
ax.FontSize = 20;
ax.FontWeight = 'bold';
%     set(crossSectionPlot,'XTickLabel',[]);

xticks([1 10 20 30 40 50 60 70 80 90 100]);
xticklabels (0:2:20);
axis tight

axis off
    
%% General
% set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(crossSectionPlot, 'Position', [0.5 0.5 width*20, height*10]); %<- Set size


%% Save image using save_fig

set(crossSectionPlot,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('xCrossSectionForSeismic %dx%dx%d',iteration,x,kk),...
   '-png', '-transparent', '-m12', '-q101');
    
 
    
end