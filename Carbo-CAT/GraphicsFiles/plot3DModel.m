function plot3DModel(glob,subs,iteration,yPosition,xPosition)
% 3D PLOT of the visible stratigraphy as thickness colour coded by facies
% % % 
% % % 
% % % %% If printing from file, reverse the effect of subsidence
% % % % glob.plotFromFile = false; % =true if you are printing from a mat file
% % % 
% % % if glob.plotFromFile == true
% % %     glob.strata = glob.strata(:,:,1:iteration);
% % %    for l = 1:iteration
% % %        glob.strata(:,:,l)     = glob.strata(:,:,l) + sum(subs.subsidence(:,:,iteration+1:glob.totalIterations),3); 
% % %    end
% % %    subs.subsidence =  subs.subsidence(:,:,1:iteration); 
% % % end


ff = glob.figureNum;
ffOne = figure(ff);

% ffOne = figure('Visible','off');


patchCounter = 0;

k = iteration-1;

% basement boundary
surfaces=-glob.wd(:,:,1);   
% surfaces2=-glob.wd(:,:,1);
for t=1:iteration
    surfaces=surfaces-subs.subsidence(:,:,t);
end
maxDepth= min(min(surfaces));
maxDepth = maxDepth - 50; 




%% Set azimuth 
azimuth=-26; %was 75 - HG -
elevation=63; % was 50 -HG-
% % if iteration >= 900
% %     elevation = 50;
% % end

view([azimuth elevation]);

draw3DSurface; 

if elevation ~=90 && azimuth < 90
     drawWestFace 
     drawNorthFace
end    

if elevation ~= 90 && azimuth < 180 && azimuth > 90  
    drawWestFace 
    drawSouthFace    
end

if elevation ~= 90 && azimuth > 180 && azimuth <270    
    drawEastFace
    drawSouthFace
end

if elevation ~= 90 && azimuth >270  
    drawEastFace
    drawNorthFace 
end

if elevation ~= 90 && azimuth == -26  
    drawEastFace
    drawNorthFace 
end
%% Draw sea level
z = glob.SL(iteration); 
x = 1:glob.xSize;
y = 1:glob.ySize;
zco = [z z z z];
xco = [-0.5 x(end)+0.5 x(end)+0.5 -0.5];
yco = [-0.5 -0.5 y(end)+0.5 y(end)+0.5];
patch(xco,yco,zco,[0  1  1],'FaceAlpha',0.15,'EdgeColor','none');

%% Draw top surface
function draw3DSurface
    
% draw the top patch of each cell       
    for x=1:glob.xSize
        for y=1:glob.ySize 
            y=double(y);
            x=double(x);
            yco = [y-0.5,y-0.5,y+0.5,y+0.5];
            xco = [x-0.5,x+0.5,x+0.5,x-0.5];
            zco = [glob.strata(y,x,k) glob.strata(y,x,k) glob.strata(y,x,k) glob.strata(y,x,k)];         
            % define the color of each patch
            topLayer=glob.numberOfLayers(y,x,k);
            if topLayer==0
                fCode=0;
            else
                fCode=glob.facies{y,x,k}(topLayer);
                
                
            end                
            if fCode > 0
                faciesCol = [glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)];
            else
                faciesCol = [ 1 1 1 ]; % Set patch to white if no deposition at the last iteration
            end                
            patch(xco, yco, zco, faciesCol);     
            patchCounter = patchCounter+1;
        end
    end       
end

%% Draw west face (x-positive direction)
function drawWestFace

for y = 1 : glob.ySize % Loop through all the map grid cells
    for x = 1 : glob.xSize 
        y=double(y);
        x=double(x);

      % find the height of the Nbr cell in x-positive direction (y,x+1)
      if x == glob.xSize % if we are at the model boundaries, plot everything  
         hNbr = - 1000000;
      else
          hNbr = max(glob.strata(y,x+1,1:k));
      end
      
      % draw the x+ face just if the next cell is lower and the current
      % cell visible 
      if find(glob.strata(y,x,k) > hNbr) > 0 % if the next  cell is lower
        yco=[y-0.5 y-0.5 y+0.5 y+0.5];
        xco=[x+0.5 x+0.5 x+0.5 x+0.5];
        
        % find the lower boundary iteration
        it = k;
        while it >= 2 && glob.strata(y,x,it) > hNbr            
            it = it-1;
            minIt = it; % lower iteration boundary.                  
        end

        % calculate the total number of layers in the interval [k minIt],
        % their facies and thickness
        dummyTotalFacies = {[glob.facies{y,x,minIt:k}]};
        dummyTotalFacies = cell2mat(dummyTotalFacies); 
        dummyTotalFacies = fliplr(dummyTotalFacies);
        dummyTotalThickness = {[glob.thickness{y,x,minIt:k}]};
        dummyTotalThickness = cell2mat(dummyTotalThickness); 
        dummyTotalThickness = fliplr(dummyTotalThickness);
      
        dummyThickness = 0;
        dummyFacies = 0;
        
        j = 1;
        
        for i = 1:length(dummyTotalFacies)
            if  dummyTotalFacies(i) > 0 && dummyTotalFacies(i) ~= 9

                dummyFacies(j) = dummyTotalFacies(i);
                dummyThickness(j) = dummyTotalThickness(i);
            
                
                j = j+1;
            end
        end

        totalThickness = sum(dummyThickness);
        totalLayers = length(dummyThickness);
        
        if dummyFacies > 0
        
        if all(dummyFacies == dummyFacies(1))
            top = glob.strata(y,x,k);
            bottom = glob.strata(y,x,minIt);
            zco = [top bottom bottom top];
            fCode = dummyFacies(1);
            faciesCol = [glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)];
            patch(xco, yco, zco, faciesCol,'EdgeColor','none');
            patchCounter = patchCounter+1;
            line([x+0.5 x+0.5],[y-0.5 y-0.5],[top, bottom],'color',[0 0 0]);
            line([x+0.5 x+0.5],[y+0.5 y+0.5],[top, bottom],'color',[0 0 0]);
        else 
                        
          topLayerIndex = 1;  
          top = glob.strata(y,x,k);  
      
          while totalLayers > 0
              
            [bottomLayerIndex, equalLayersNum, fCode] = findEqualFacies(dummyFacies, topLayerIndex,totalLayers);
             
             bottom = glob.strata(y,x,k) - sum(dummyThickness(1:bottomLayerIndex-1));

            faciesCol = [glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)];
            zco = [top bottom bottom top];
            patch(xco, yco, zco, faciesCol,'EdgeColor','none');
            patchCounter = patchCounter+1;
            
            line([x+0.5 x+0.5],[y-0.5 y-0.5],[top, bottom],'color',[0 0 0]);
            line([x+0.5 x+0.5],[y+0.5 y+0.5],[top, bottom],'color',[0 0 0]);
            top = bottom;
            topLayerIndex = bottomLayerIndex;
            totalLayers = totalLayers - equalLayersNum;  

          end   
        end

        end
        
        %Draw basement
        zco = [glob.strata(y,x,1) maxDepth maxDepth glob.strata(y,x,1)];
        faciesCol = [0.6 0.6 0.6];
        patch(xco, yco, zco, faciesCol,'EdgeColor','none');      
      
      end

        clear dummyFacies;
        clear dummyThickness;
        clear dummyTotalFacies;
        clear dummyTotalThickness;

    end
 end
end


%% Draw south face (Y-positive direction)
function drawSouthFace

for y = 1 : glob.ySize % Loop through all the map grid cells
    for x = 1 : glob.xSize 
        y=double(y);
        x=double(x);

      % find the height of the Nbr cell in x-positive direction (y,x+1)
      if y == glob.ySize % if we are at the model boundaries, plot everything  
         hNbr = - 1000000;
      else
          hNbr = max(glob.strata(y+1,x,1:k));
      end
      
      % draw the y+ face just if the next cell is lower and the current
      % cell visible 
      if find(glob.strata(y,x,k) > hNbr) > 0 % if the next  cell is lower
        yco=[y+0.5 y+0.5 y+0.5 y+0.5];
        xco=[x-0.5 x-0.5 x+0.5 x+0.5];
        
        % find the lower boundary iteration
        it = k;
        while it >= 2 && glob.strata(y,x,it) > hNbr            
            it = it-1;
            minIt = it; % lower iteration boundary.                  
        end


        % calculate the total number of layers in the interval [k minIt],
        % their facies and thickness
        dummyTotalFacies = {[glob.facies{y,x,minIt:k}]};
        dummyTotalFacies = cell2mat(dummyTotalFacies); 
        dummyTotalFacies = fliplr(dummyTotalFacies);
        dummyTotalThickness = {[glob.thickness{y,x,minIt:k}]};
        dummyTotalThickness = cell2mat(dummyTotalThickness); 
        dummyTotalThickness = fliplr(dummyTotalThickness);
        
        dummyThickness = 0;
        dummyFacies = 0;
        
        j = 1;
        
        for i = 1:length(dummyTotalFacies)
            
            if  dummyTotalFacies(i) > 0 && dummyTotalFacies(i) ~= 9
                
                dummyFacies(j) = dummyTotalFacies(i);
                dummyThickness(j) = dummyTotalThickness(i);
                
                j = j+1;

            end
        end

        totalThickness = sum(dummyThickness);
        totalLayers = length(dummyThickness);
        
        if dummyFacies > 0
        
        
        if all(dummyFacies == dummyFacies(1))
            top = glob.strata(y,x,k);
            bottom = glob.strata(y,x,minIt);
            zco = [top bottom bottom top];
            fCode = dummyFacies(1);
            faciesCol = [glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)];
            patch(xco, yco, zco, faciesCol,'EdgeColor','none');
            patchCounter = patchCounter+1;
            line([x+0.5 x+0.5],[y+0.5 y+0.5],[top, bottom],'color',[0 0 0]);
            line([x-0.5 x-0.5],[y+0.5 y+0.5],[top, bottom],'color',[0 0 0]);
        else 
            
            
          topLayerIndex = 1;  
          top = glob.strata(y,x,k);  
      
          while totalLayers > 0
              
            [bottomLayerIndex, equalLayersNum, fCode] = findEqualFacies(dummyFacies, topLayerIndex,totalLayers);
             
             bottom = glob.strata(y,x,k) - sum(dummyThickness(1:bottomLayerIndex-1));

            faciesCol = [glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)];
            zco = [top bottom bottom top];
            patch(xco, yco, zco, faciesCol,'EdgeColor','none');
            patchCounter = patchCounter+1;
            
            line([x+0.5 x+0.5],[y+0.5 y+0.5],[top, bottom],'color',[0 0 0]);
            line([x-0.5 x-0.5],[y+0.5 y+0.5],[top, bottom],'color',[0 0 0]);
            top = bottom;
            topLayerIndex = bottomLayerIndex;
            totalLayers = totalLayers - equalLayersNum;  

          end   
        end
        end
        
        zco = [glob.strata(y,x,1) maxDepth maxDepth glob.strata(y,x,1)];
        faciesCol = [0.6 0.6 0.6];
        patch(xco, yco, zco, faciesCol,'EdgeColor','none');        
        
      end
      
        clear dummyFacies;
        clear dummyThickness;
        clear dummyTotalFacies;
        clear dummyTotalThickness;

    end
end
end       
        
        
        
%% Draw east face (X-negative direction)
function drawEastFace

for y = 1 : glob.ySize % Loop through all the map grid cells
    for x = 1 : glob.xSize 
        y=double(y);
        x=double(x);
        
      % find the height of the Nbr cell in x-positive direction (y,x+1)
      if x == 1 % if we are at the model boundaries, plot everything  
         hNbr = - 1000000;
      else
          hNbr = max(glob.strata(y,x-1,1:k));
      end
      
      % draw the x- face just if the next cell is lower and the current
      % cell visible 
      if find(glob.strata(y,x,k) > hNbr) > 0 % if the next  cell is lower
            yco=[y-0.5 y-0.5 y+0.5 y+0.5];
            xco=[x-0.5 x-0.5 x-0.5 x-0.5];
        
        % find the lower boundary iteration
        it = k;
        while it >= 2 && glob.strata(y,x,it) > hNbr            
            it = it-1;
            minIt = it; % lower iteration boundary.                  
        end

        % calculate the total number of layers in the interval [k minIt],
        % their facies and thickness
        dummyTotalFacies = {[glob.facies{y,x,minIt:k}]};
        dummyTotalFacies = cell2mat(dummyTotalFacies); 
        dummyTotalFacies = fliplr(dummyTotalFacies);
        dummyTotalThickness = {[glob.thickness{y,x,minIt:k}]};
        dummyTotalThickness = cell2mat(dummyTotalThickness); 
        dummyTotalThickness = fliplr(dummyTotalThickness);
        

        dummyThickness = 0;
        dummyFacies = 0;
        
        j = 1;
        
        for i = 1:length(dummyTotalFacies)
            
            if  dummyTotalFacies(i) > 0 && dummyTotalFacies(i) ~= 9
                
                dummyFacies(j) = dummyTotalFacies(i);
                dummyThickness(j) = dummyTotalThickness(i);
                
                j = j+1;

            end
        end

        totalThickness = sum(dummyThickness);
        totalLayers = length(dummyThickness);
        
        if dummyFacies > 0
        
        if all(dummyFacies == dummyFacies(1))
            top = glob.strata(y,x,k);
            bottom = glob.strata(y,x,minIt);
            zco = [top bottom bottom top];
            fCode = dummyFacies(1);
            faciesCol = [glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)];
            patch(xco, yco, zco, faciesCol,'EdgeColor','none');
            patchCounter = patchCounter+1;
            line([x-0.5 x-0.5],[y-0.5 y-0.5],[top, bottom],'color',[0 0 0]);
            line([x-0.5 x-0.5],[y+0.5 y+0.5],[top, bottom],'color',[0 0 0]);
        else 
            
            
          topLayerIndex = 1;  
          top = glob.strata(y,x,k);  
      
          while totalLayers > 0
              
            [bottomLayerIndex, equalLayersNum, fCode] = findEqualFacies(dummyFacies, topLayerIndex,totalLayers);
             
             bottom = glob.strata(y,x,k) - sum(dummyThickness(1:bottomLayerIndex-1));

            faciesCol = [glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)];
            zco = [top bottom bottom top];
            patch(xco, yco, zco, faciesCol,'EdgeColor','none');
            patchCounter = patchCounter+1;
            
            line([x-0.5 x-0.5],[y-0.5 y-0.5],[top, bottom],'color',[0 0 0]);
            line([x-0.5 x-0.5],[y+0.5 y+0.5],[top, bottom],'color',[0 0 0]);
            top = bottom;
            topLayerIndex = bottomLayerIndex;
            totalLayers = totalLayers - equalLayersNum;  

          end   
        end
        end
        %Draw basement
        zco = [glob.strata(y,x,1) maxDepth maxDepth glob.strata(y,x,1)];
        faciesCol = [0.6 0.6 0.6];
        patch(xco, yco, zco, faciesCol,'EdgeColor','none'); 
        
      end
        clear dummyFacies;
        clear dummyThickness;
        clear dummyTotalFacies;
        clear dummyTotalThickness;

    
    end
end
end          
        
%% Draw north face (Y-negative direction)
function drawNorthFace

for y = 1 : glob.ySize % Loop through all the map grid cells
    for x = 1 : glob.xSize 
        y=double(y);
        x=double(x);

      % find the height of the Nbr cell in x-positive direction (y,x+1)
      if y == 1 % if we are at the model boundaries, plot everything  
         hNbr = - 1000000;
      else
          hNbr = max(glob.strata(y-1,x,1:k));
      end
      
      
      % draw the y+ face just if the next cell is lower and the current
      % cell visible 
      if find(glob.strata(y,x,k) > hNbr) > 0 % if the next  cell is lower
        yco=[y-0.5 y-0.5 y-0.5 y-0.5];
        xco=[x-0.5 x-0.5 x+0.5 x+0.5];
        
        % find the lower boundary iteration
        it = k;
        while it >= 2 && glob.strata(y,x,it) > hNbr            
            it = it-1;
            minIt = it; % lower iteration boundary.                  
        end


        % calculate the total number of layers in the interval [k minIt],
        % their facies and thickness
        dummyTotalFacies = {[glob.facies{y,x,minIt:k}]};
        dummyTotalFacies = cell2mat(dummyTotalFacies); 
        dummyTotalFacies = fliplr(dummyTotalFacies);
        dummyTotalThickness = {[glob.thickness{y,x,minIt:k}]};
        dummyTotalThickness = cell2mat(dummyTotalThickness); 
        dummyTotalThickness = fliplr(dummyTotalThickness);
        
        dummyThickness = 0;
        dummyFacies = 0;
        
        j = 1;
        
        for i = 1:length(dummyTotalFacies)
            
            if  dummyTotalFacies(i) > 0 && dummyTotalFacies(i) ~= 9
                
                dummyFacies(j) = dummyTotalFacies(i);
                dummyThickness(j) = dummyTotalThickness(i);
                
                j = j+1;

            end
        end

        totalThickness = sum(dummyThickness);
        totalLayers = length(dummyThickness);
        
        if dummyFacies > 0
        
        if all(dummyFacies == dummyFacies(1))
            top = glob.strata(y,x,k);
            bottom = glob.strata(y,x,minIt);
            zco = [top bottom bottom top];
            fCode = dummyFacies(1);
            faciesCol = [glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)];
            patch(xco, yco, zco, faciesCol,'EdgeColor','none');
            patchCounter = patchCounter+1;
            line([x+0.5 x+0.5],[y-0.5 y-0.5],[top, bottom],'color',[0 0 0]);
            line([x-0.5 x-0.5],[y-0.5 y-0.5],[top, bottom],'color',[0 0 0]);
        else 
            
            
          topLayerIndex = 1;  
          top = glob.strata(y,x,k);  
      
          while totalLayers > 0
              
            [bottomLayerIndex, equalLayersNum, fCode] = findEqualFacies(dummyFacies, topLayerIndex,totalLayers);
             
             bottom = glob.strata(y,x,k) - sum(dummyThickness(1:bottomLayerIndex-1));

            faciesCol = [glob.faciesColours(fCode,2) glob.faciesColours(fCode,3) glob.faciesColours(fCode,4)];
            zco = [top bottom bottom top];
            patch(xco, yco, zco, faciesCol,'EdgeColor','none');
            patchCounter = patchCounter+1;
            
            line([x+0.5 x+0.5],[y-0.5 y-0.5],[top, bottom],'color',[0 0 0]);
            line([x-0.5 x-0.5],[y-0.5 y-0.5],[top, bottom],'color',[0 0 0]);
            top = bottom;
            topLayerIndex = bottomLayerIndex;
            totalLayers = totalLayers - equalLayersNum;  

          end   
        end
        end
                %Draw basement
        zco = [glob.strata(y,x,1) maxDepth maxDepth glob.strata(y,x,1)];
        faciesCol = [0.6 0.6 0.6];
        patch(xco, yco, zco, faciesCol,'EdgeColor','none'); 
       end
      
        clear dummyFacies;
        clear dummyThickness;
        clear dummyTotalFacies;
        clear dummyTotalThickness;

    end
end
end    
       
  
% %% Plot cross section position using patch
% % y Cross section
% for i = 1:length(yPosition)
% zco = [600 maxDepth maxDepth 600];
% % yco = [yPosition yPosition yPosition yPosition]; 
% yco = [yPosition(i) yPosition(i) yPosition(i) yPosition(i)]; 
% xco = [0 0 glob.xSize+1 glob.xSize+1];
% faciesCol = [1 0.921 0.843];
% patch(xco, yco, zco, faciesCol,'FaceAlpha',0.35,'LineWidth',1 ); 
% end
% 
% %x cross section
% for i = 1:length(xPosition)
% zco = [600 maxDepth maxDepth 600];
% % xco = [xPosition xPosition xPosition xPosition]; 
% xco = [xPosition(i) xPosition(i) xPosition(i) xPosition(i)]; 
% yco = [0 0 glob.ySize+1 glob.ySize+1];
% faciesCol = [1 0.921 0.843];
% patch(xco, yco, zco, faciesCol,'FaceAlpha',0.35,'LineWidth',1 ); 
% end

%% General-----------------------------------------------------------
% set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*15, height*10]); %<- Set size WAS 10-15

% axes properties
ax = gca;
ax.LineWidth = 0.6;
ax.FontSize = 16;
ax.FontWeight = 'bold';

xticks([1 25 50 75 100 125 150]);
xticklabels (0:5:30);
yticks([1 10 20 30 40 50 60 70 80 90 100]);
yticklabels (0:2:20);

xlabel('x(km)','FontSize',18,'FontWeight','bold');
ylabel('y(km)','FontSize',18,'FontWeight','bold');
zlabel('z(m)','FontSize',18,'FontWeight','bold');


axis tight
% daspect([1.25 1.25 1.0000]);
% pbaspect([3.2 3 1]);

%%  Axis off option
% axis off 



%% Save image using save_fig

set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig(sprintf('view3D %d',iteration),...
   '-png', '-transparent', '-m8', '-q101');

% 
% export_fig( sprintf('C:\Users\isabel16\iCloudDrive\CarboCAT_inuse\modelOutput\%d',k),...
%    '-png', '-transparent', '-m8', '-q101');

end


function [bottomLayerIndex, equalLayersNum, fCode] = findEqualFacies(dummyFacies, topLayerIndex, totalLayers)
%find layers with the same facies

    it = topLayerIndex;
    equalLayersNum = 1; 
    fCode = dummyFacies(topLayerIndex);
    bottomLayerIndex =topLayerIndex + 1;

 while it <= totalLayers && dummyFacies(it) == dummyFacies(it+1) 
%     fCode = dummyFacies(it);
    bottomLayerIndex = bottomLayerIndex+1;
    it = it+1;
    equalLayersNum = equalLayersNum +1;      
 end
 
 
end

