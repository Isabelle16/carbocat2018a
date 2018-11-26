function PetrelGrid (strataUpscaled, dx, filenameGrid,limitH)
%writes and exports a model grid for Petrel

if dx<1
    strPrecision=' %0.5E \n  ';
else
    strPrecision=' %0.5E \n  ';
end
% ECLISPE keywords (grid geometry and properties) file

[ySize,xSize,iterations]=size(strataUpscaled);
strataUpscaled=-strataUpscaled;

maxSizeY=ySize*dx;
str1=[num2str(maxSizeY) ' '];
MAPAXES=['0.00 ' '0.00 ' '0.00 ' str1 str1 str1];

fileID=fopen(filenameGrid,'w+');

fprintf(fileID, 'MAPUNITS\n  METRES  /\n');
fprintf(fileID, 'MAPAXES\n  %s /\n',MAPAXES);
fprintf(fileID, 'GRIDUNITS\n  METRES  /\n');


fprintf(fileID, 'SPECGRID\n  %i %i %i 1 F /\n',xSize,ySize,iterations-1);

fprintf(fileID, 'COORDSYS\n  1 2  /\n');

fprintf(fileID, 'COORD');

base=min(strataUpscaled(:));
top=max(strataUpscaled(:));

%loop through all the nodes and store position, top and base
for j=ySize:-1:0
    ypos=(ySize*dx)-(j*dx);
    for i=1:xSize+1
        xpos=(i*dx)-dx;
        fprintf(fileID, '\n  %.3f %.3f %.3f %.3f %.3f %.3f', xpos,ypos,top,xpos,ypos,base);
    end
end
fprintf(fileID, ' /\n');

fprintf(fileID, 'ZCORN\n  ');



%top and base of each cell node, starting from the top max y, min x

for k=1:iterations
    
    topLayer=strataUpscaled(:,:,k);
    topLayerExpanded=zeros(ySize+2,xSize+2);
    topLayerExpanded(2:ySize+1,2:xSize+1)=topLayer;
    topLayerExpanded(1,2:xSize+1)=topLayerExpanded(2,2:xSize+1);
    topLayerExpanded(ySize+2,2:xSize+1)=topLayerExpanded(ySize+1,2:xSize+1);
    topLayerExpanded(2:ySize+1,1)=topLayerExpanded(2:ySize+1,2);
    topLayerExpanded(2:ySize+1,xSize+2)=topLayerExpanded(2:ySize+1,xSize+1);
    
    topLayerExpanded(1,1)= topLayerExpanded(2,2);
    topLayerExpanded(1,xSize+2) = topLayerExpanded(2,xSize+1);
    topLayerExpanded(ySize+2,xSize+2) = topLayerExpanded(ySize+1,xSize+1);
    topLayerExpanded(ySize+2,1) = topLayerExpanded(ySize+1,2);
    
    topLayerExpandedAll(:,:,k)=topLayerExpanded;
    
    if k==1 %create nodes for the bottom flat surface
        zminminExpanded=(topLayerExpanded+circshift(topLayerExpanded,[+1,+1])+circshift(topLayerExpanded,[+1,0])+circshift(topLayerExpanded,[0,+1]))./4; %-y -x
        zminplusExpanded=(topLayerExpanded+circshift(topLayerExpanded,[+1,-1])+circshift(topLayerExpanded,[+1,0])+circshift(topLayerExpanded,[0,-1]))./4; %-y + x
        zplusminExpanded=(topLayerExpanded+circshift(topLayerExpanded,[-1,+1])+circshift(topLayerExpanded,[-1,0])+circshift(topLayerExpanded,[0,+1]))./4; % +y - x
        zplusplusExpanded=(topLayerExpanded+circshift(topLayerExpanded,[-1,-1])+circshift(topLayerExpanded,[-1,0])+circshift(topLayerExpanded,[0,-1]))./4; %+ y + x
        
    else %create nodes for the rest of the surfaces
        
        
        if k==2 %check for basement differences to record faults
            
            %creates eight maps with 1 and zeros to weight the amount points
            %to be averaged looking at the 8 neighbours of each cell (0
            %when the difference in height is above limitH)
            
            zxminbasementDif=abs(topLayerExpanded-circshift(topLayerExpanded,[0 +1])); %0 -x
            xminCheckDiff=ones(ySize+2,xSize+2);
            xminCheckDiff(zxminbasementDif>limitH)=0;
            
            zxplusbasementDif=abs(topLayerExpanded-circshift(topLayerExpanded,[0 -1])); %0 +x
            xplusCheckDiff=ones(ySize+2,xSize+2);
            xplusCheckDiff(zxplusbasementDif>limitH)=0;
            
            zyminbasementDif=abs(topLayerExpanded-circshift(topLayerExpanded,[+1 0])); %-y 0
            yminCheckDiff=ones(ySize+2,xSize+2);
            yminCheckDiff(zyminbasementDif>limitH)=0;
            
            zyplusbasementDif=abs(topLayerExpanded-circshift(topLayerExpanded,[-1 0]));  %+y 0
            yplusCheckDiff=ones(ySize+2,xSize+2);
            yplusCheckDiff(zyplusbasementDif>limitH)=0;
            
            zminminbasementDif=abs(topLayerExpanded-circshift(topLayerExpanded,[+1 +1])); %-y -x
            minminCheckDiff=ones(ySize+2,xSize+2);
            minminCheckDiff(zminminbasementDif>limitH)=0; 
            
            zplusminbasementDif=abs(topLayerExpanded-circshift(topLayerExpanded,[-1 +1])); %+y -x
            plusminCheckDiff=ones(ySize+2,xSize+2);
            plusminCheckDiff(zplusminbasementDif>limitH)=0;
            
            zplusplusbasementDif=abs(topLayerExpanded-circshift(topLayerExpanded,[-1 -1])); %+y +x
            plusplusCheckDiff=ones(ySize+2,xSize+2);
            plusplusCheckDiff(zplusplusbasementDif>limitH)=0;
            
            zminplusbasementDif=abs(topLayerExpanded-circshift(topLayerExpanded,[+1 -1]));  %-y +x
            minplusCheckDiff=ones(ySize+2,xSize+2);
            minplusCheckDiff(zminplusbasementDif>limitH)=0;
        end
        
        %each of this matrices store the elevation of the four nodes of
        %each cell
        %they are calculated as the average of the centre cell plus the
        %three closest neighbour cells
        %when the difference in height of a neighbour cell is above a user
        %defined value, a the node elevation is calculated without consider
        %the elevation of that neighbour cell
        zminminExpanded=(topLayerExpanded+circshift(topLayerExpanded,[+1,+1]).*minminCheckDiff+circshift(topLayerExpanded,[+1,0]).*yminCheckDiff+circshift(topLayerExpanded,[0,+1]).*xminCheckDiff)./(1+minminCheckDiff+yminCheckDiff+xminCheckDiff); %-y -x
        zminplusExpanded=(topLayerExpanded+circshift(topLayerExpanded,[+1,-1]).*minplusCheckDiff+circshift(topLayerExpanded,[+1,0]).*yminCheckDiff+circshift(topLayerExpanded,[0,-1]).*xplusCheckDiff)./(1+minplusCheckDiff+yminCheckDiff+xplusCheckDiff); %-y + x
        zplusminExpanded=(topLayerExpanded+circshift(topLayerExpanded,[-1,+1]).*plusminCheckDiff+circshift(topLayerExpanded,[-1,0]).*yplusCheckDiff+circshift(topLayerExpanded,[0,+1]).*xminCheckDiff)./(1+plusminCheckDiff+yplusCheckDiff+xminCheckDiff); % +y - x
        zplusplusExpanded=(topLayerExpanded+circshift(topLayerExpanded,[-1,-1]).*plusplusCheckDiff+circshift(topLayerExpanded,[-1,0]).*yplusCheckDiff+circshift(topLayerExpanded,[0,-1]).*xplusCheckDiff)./(1+plusplusCheckDiff+yplusCheckDiff+xplusCheckDiff); %+ y + x
    end
    
    
    if k>2
        
        %collapse cells with no thickness
        thick=topLayerExpandedAll(:,:,k)-topLayerExpandedAll(:,:,k-1);
        
        zminminExpandedPrev=zminminExpandedAll(:,:,k-1);
        zminminExpanded(thick>=0)=zminminExpandedPrev(thick>=0);
        
        zminplusExpandedPrev=zminplusExpandedAll(:,:,k-1);
        zminplusExpanded(thick>=0)=zminplusExpandedPrev(thick>=0);
        
        zplusminExpandedPrev=zplusminExpandedAll(:,:,k-1);
        zplusminExpanded(thick>=0)=zplusminExpandedPrev(thick>=0);
        
        zplusplusExpandedPrev=zplusplusExpandedAll(:,:,k-1);
        zplusplusExpanded(thick>=0)=zplusplusExpandedPrev(thick>=0);
        
        %collapse nodes of 8 surrounding cells, visit the 8 surrounding
        %cells
        %only do this if it is not disconnected by faults
        %-y -x
        shiftThick=circshift(thick,[+1 +1]);
        shiftThick(shiftThick>=0)=1; %colapse when one
        shiftThick(shiftThick<0)=0;
        checkFaultAndThick=(minminCheckDiff)+shiftThick; % colapse when 1
        zminminExpanded(checkFaultAndThick==2)=zminminExpandedPrev(checkFaultAndThick==2);
        %-y 0
        shiftThick=circshift(thick,[+1 0]);
                shiftThick(shiftThick>=0)=1; %colapse when one
        shiftThick(shiftThick<0)=0;
        checkFaultAndThick=(yminCheckDiff)+shiftThick; 
        zminminExpanded(checkFaultAndThick==2)=zminminExpandedPrev(checkFaultAndThick==2);
        zminplusExpanded(checkFaultAndThick==2)=zminplusExpandedPrev(checkFaultAndThick==2);
        %-y +x
        shiftThick=circshift(thick,[+1 -1]);
                shiftThick(shiftThick>=0)=1; %colapse when one
        shiftThick(shiftThick<0)=0;
        checkFaultAndThick=(minplusCheckDiff)+shiftThick;
        zminplusExpanded(checkFaultAndThick==2)=zminplusExpandedPrev(checkFaultAndThick==2);
        %0 -x
        shiftThick=circshift(thick,[0 +1]);
                shiftThick(shiftThick>=0)=1; %colapse when one
        shiftThick(shiftThick<0)=0;
        checkFaultAndThick=(xminCheckDiff)+shiftThick;
        zminminExpanded(checkFaultAndThick==2)=zminminExpandedPrev(checkFaultAndThick==2);
        zplusminExpanded(checkFaultAndThick==2)=zplusminExpandedPrev(checkFaultAndThick==2);
        %0 +x
        shiftThick=circshift(thick,[0 -1]);
                shiftThick(shiftThick>=0)=1; %colapse when one
        shiftThick(shiftThick<0)=0;
        checkFaultAndThick=(xplusCheckDiff)+shiftThick;
        zminplusExpanded(checkFaultAndThick==2)=zminplusExpandedPrev(checkFaultAndThick==2);
        zplusplusExpanded(checkFaultAndThick==2)=zplusplusExpandedPrev(checkFaultAndThick==2);
        %+y -x
        shiftThick=circshift(thick,[-1 +1]);
                shiftThick(shiftThick>=0)=1; %colapse when one
        shiftThick(shiftThick<0)=0;
        checkFaultAndThick=(plusminCheckDiff-1)+shiftThick;
        zplusminExpanded(checkFaultAndThick==2)=zplusminExpandedPrev(checkFaultAndThick==2);
        %+y 0
        shiftThick=circshift(thick,[-1 0]);
                shiftThick(shiftThick>=0)=1; %colapse when one
        shiftThick(shiftThick<0)=0;
        checkFaultAndThick=(yplusCheckDiff)+shiftThick;
        zplusminExpanded(checkFaultAndThick==2)=zplusminExpandedPrev(checkFaultAndThick==2);
        zplusplusExpanded(checkFaultAndThick==2)=zplusplusExpandedPrev(checkFaultAndThick==2);
        %-y +x
        shiftThick=circshift(thick,[-1 -1]);
                shiftThick(shiftThick>=0)=1; %colapse when one
        shiftThick(shiftThick<0)=0;
        checkFaultAndThick=(minplusCheckDiff)+shiftThick;
        zplusplusExpanded(checkFaultAndThick==2)=zplusplusExpandedPrev(checkFaultAndThick==2);
    end
    
    
    
    %store
    zminminExpandedAll(:,:,k)=zminminExpanded; %-y -x
    zminplusExpandedAll(:,:,k)=zminplusExpanded; %-y + x
    zplusminExpandedAll(:,:,k)=zplusminExpanded; % +y - x
    zplusplusExpandedAll(:,:,k)=zplusplusExpanded; %+ y + x
    
    
    %make a matrix with the averages
    meanZminminAll(:,:,k)=zminminExpanded(2:ySize+1,2:xSize+1);
    meanZminplusAll(:,:,k)=zminplusExpanded(2:ySize+1,2:xSize+1);
    meanZplusminAll(:,:,k)=zplusminExpanded(2:ySize+1,2:xSize+1);
    meanZplusplusAll(:,:,k)=zplusplusExpanded(2:ySize+1,2:xSize+1);
    
    
    
end



for k=iterations:-1:2
    
    for tb=0:1 %visit eah iteration twice to write the top and the base
        
        
        %now loop through every point following the eclipse format and
        %write
        
        %first write nodes in the x direction (so the loop goes deeper)
        
        for j=1:ySize
            
            
            
            for ynode=1:2 %the two nodes in the y direction
                if ynode==1 %get the minus x
                    
                    
                    for i=1:xSize
                        
                        
                        
                        
                        meanZminmin=meanZminminAll(j,i,k-tb);
                        meanZminplus=meanZminplusAll(j,i,k-tb);
                        
                        
                        fprintf(fileID, strPrecision, meanZminmin );
                        fprintf(fileID, strPrecision, meanZminplus );
                        
                        
                    end
                    
                else %get the plus y
                    
                    
                    for i=1:xSize
                        
                        
                        
                        
                        meanZplusmin=meanZplusminAll(j,i,k-tb);
                        meanZplusplus=meanZplusplusAll(j,i,k-tb);
                        
                        
                        
                        fprintf(fileID, strPrecision,meanZplusmin );
                        fprintf(fileID, strPrecision,meanZplusplus );
                    end
                    
                end
            end
            
        end
    end
    
end



fprintf(fileID, ' /\n');
fprintf(fileID, 'ECHO');
fclose(fileID);

end