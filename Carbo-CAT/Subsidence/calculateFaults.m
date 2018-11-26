function [subs] = calculateFaults(subs)

% pre-allocate variables
subs.surfaceFinal=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.indexFault=zeros(subs.ySize,subs.xSize,subs.maxT,subs.maxF);
subs.surface3D=zeros(subs.ySize,subs.xSize,subs.maxT,subs.maxF);





subs.finalSurface=zeros(subs.ySize,subs.xSize,subs.maxT);
% loop throught all the faults


for f=1:subs.maxF
    subs.surfaceDepthGridfinalHW=zeros(subs.ySize,subs.xSize,subs.maxT);
    subs.distParallelToFaultToMidPoint=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.indexSize=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.distSurfacePointIndex=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.extenFaultGrid=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.surfaceDepthGrid=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.faultDepthGridcropped=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.subsidence=zeros(subs.ySize,subs.xSize,subs.maxT);

    subs.tanF=tand(subs.fDip(f));
    subs.sinF=sind(subs.fDip(f));
    subs.cosF=cosd(subs.fDip(f));
    
    if subs.fHeight(f)>0
    subs.HWCode=1;
    
    %run for the hangingwall
    [subs]=calculateGridValues(subs,f);
    
    [subs]=generateFaultPlane(subs,f);
    
    [subs]=generateSurface(subs,f);
    
    [subs]=cropTheSurface(subs);
    
    [subs]=addTheFault(subs);
    
   
     for t=subs.startingTime(f):subs.endingTime(f) 
  subs.surfaceDepthGridfinalHW(:,:,t)=subs.surfaceDepthGrid(:,:,t);
    
     end
    if subs.endingTime(f)<subs.maxT %added on 13/oct/16 by Estani to correct faults that are not active the whole time
        for t=subs.endingTime(f)+1:subs.maxT
       subs.surfaceDepthGridfinalHW(:,:,t)=subs.surfaceDepthGrid(:,:,subs.endingTime(f));     
        end
    end
    end
   
   %run for the footwall
   %calculate footwall by changing a few parameters
 subs.surfaceDepthGridfinalFW=zeros(subs.ySize,subs.xSize,subs.maxT);  
subs.distParallelToFaultToMidPoint=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.indexSize=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.distSurfacePointIndex=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.extenFaultGrid=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.surfaceDepthGrid=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.faultDepthGridcropped=zeros(subs.ySize,subs.xSize,subs.maxT);
subs.subsidence=zeros(subs.ySize,subs.xSize,subs.maxT);

   if subs.fwHeight(f)>0
   subs.HWCode=0;
   
   if subs.fDir(f)<180
   subs.fDir(f)=subs.fDir(f)+180;
   else
   subs.fDir(f)=subs.fDir(f)-180;
   end
   
   subs.fHeight(f) = subs.fwHeight(f);
   subs.fDef(f) = subs.fwDef(f);
   
   subs.AFIndex(f) = -1*subs.AFIndex(f);
   
    [subs]=calculateGridValues(subs,f);
    
    [subs]=generateFaultPlane(subs,f);
    
    [subs]=generateSurface(subs,f);
    
    [subs]=cropTheSurface(subs);
    
    [subs]=addTheFault(subs);
   
   
   
   
    for t=subs.startingTime(f):subs.endingTime(f)
    subs.surfaceDepthGridfinalFW(:,:,t)=subs.surfaceDepthGrid(:,:,t);
    
    end  

    
        if subs.endingTime(f)<subs.maxT %added on 13/oct/16 by Estani to correct faults that are not active the whole time
        for t=subs.endingTime(f)+1:subs.maxT
       subs.surfaceDepthGridfinalFW(:,:,t)=subs.surfaceDepthGrid(:,:,subs.endingTime(f));     
        end
    end
   
    
   
    
   end
   
   
   
    subs.finalSurface=  (subs.surfaceDepthGridfinalHW+subs.surfaceDepthGridfinalFW+subs.finalSurface);

 
    
    
end

subs.finalSurface=subs.finalSurface.*1000;


%     figure (6)
%     for t=1:subs.maxT
% subplot (1,subs.maxT,t)
% surf(subs.finalSurface(:,:,t),'EdgeColor','none');
% hold on
% 
% axis square
% view(0,90)
%     end

%% ------------------------------------------------------------------------

    function [subs]=calculateGridValues(subs,f)
        
        [subs,m]=calculateDistanceToFault(subs,f);
        
        [subs]=calculateIndexFault(subs,f);
        
        [subs]= calculateDefPlaneView(subs,f,m);
        
    end


    function [subs,m]=calculateDistanceToFault(subs,f)
        
        
        if subs.fDir(f)==0 || subs.fDir(f)==180; % this does not work for N-S faults
            subs.distanceToFault= subs.xI(f)-subs.xArray2D; %distance is the distance between each point of the grid to the fault
            
            m=0;
        else
            
            %find the equation of the fault using two points
            m=(subs.y1F(subs.startingTime(f),f)-subs.y2F(subs.startingTime(f),f))/(subs.x1F(subs.startingTime(f),f)-subs.x2F(subs.startingTime(f),f));
            b=(subs.y1F(subs.startingTime(f),f))-(m*subs.x1F(subs.startingTime(f),f));
            subs.distanceToFault= ( subs.yArray2D - (m.*subs.xArray2D) - b ) ./ (sqrt((m.^2)+1));
            
        end
        if subs.fDir(f)<180
            subs.distanceToFault=subs.distanceToFault*(-1);
        end
        
        
    end



function [subs]=calculateIndexFault(subs,f)
        %------------decide if the point should be affected by the fault----------%
        
        %preallocate
        newMidPointX=zeros(subs.maxT,1);
        newMidPointY=zeros(subs.maxT,1);
        
        for t=subs.startingTime(f):subs.endingTime(f)
            
            %recalculate mid point
            minP=min(subs.x1F(t,f),subs.x2F(t,f));
            maxP=max(subs.x1F(t,f),subs.x2F(t,f));
            newMidPointX(t)=((maxP-minP)/2)+minP;
            minP=min(subs.y1F(t,f),subs.y2F(t,f));
            maxP=max(subs.y1F(t,f),subs.y2F(t,f));
            newMidPointY(t)=((maxP-minP)/2)+minP;
            
            
            
            if subs.fDir(f)==0 || subs.fDir(f)==180
                
                subs.distParallelToFaultToMidPoint(:,:,t)= (newMidPointY(t)-subs.yArray2D);
                
            else
                if subs.fDir(f)==90 || subs.fDir(f)==270
                    
                    
                    subs.distParallelToFaultToMidPoint(:,:,t)= (newMidPointX(t)-subs.xArray2D);
                    
                    
                else
                    %this is the distance between each point of the grid to the mid
                    %Point
                    
                    %distance between each point of the surface and the mid point of the fault
                    distPointOfSurfaceToFaultMidPoint= (((newMidPointX(t)-subs.xArray2D).^2)+((newMidPointY(t)-subs.yArray2D).^2)).^(1/2); 
                     %distance between the extrapolation of each point over the fault and the mid point of the fault
                    subs.distParallelToFaultToMidPoint(:,:,t)= (((distPointOfSurfaceToFaultMidPoint.^2)-(subs.distanceToFault.^2))).^(1/2);
                    
                    %using Pythagoras we get the distance parallel to the fault
                    %hyp ^2 = side1 ^2 + side2 ^2
                end
                
                
                
            end
            
            %compare distances(length of the fault vs distance of each point projected in the
            %fault)
            
            
            dist=abs(subs.distParallelToFaultToMidPoint(:,:,t));
            
            
            
            check1=zeros(subs.ySize,subs.xSize);
            check1(dist<subs.dLength(t,f)/2)=1;
            %subs.indexSize contains a logic array controlling the lateral
            %extent of deformation
            subs.indexSize(:,:,t)=check1;
            
        end
        
    end



    function  [subs]=calculateDefPlaneView(subs,f,m)
        %calculate how deformation should vary according to fault plane
        %view
        
        
        distSurfacePointIndex=zeros(subs.ySize,subs.xSize,subs.maxT);
        
        if subs.fDir(f)==0 || subs.fDir(f)==180
            distParallelToFaultToMaxDefPoint= (subs.yArray2D-subs.yMaxDefNear(f));
            
        else
            if subs.fDir(f)==90 || subs.fDir(f)==270
                distParallelToFaultToMaxDefPoint= (subs.xArray2D-subs.xMaxDefNear(f));
                
            else
                
                %find the equation of the line perp to the fault that crosses max
                %def point
                n=-1/m;
                b=subs.yMaxDefNear(f)-(n*subs.xMaxDefNear(f));
                %calculate distance to that line
                distParallelToFaultToMaxDefPoint= (subs.yArray2D-(n.*subs.xArray2D)-b)./(((n^2)+1)^(1/2));
                %so when distance is positive, i'm on the highest point side
                
            end
        end
        
        
        subs.distParallelToFaultToMaxDefPoint=distParallelToFaultToMaxDefPoint;
              
        
        %Calculate the distance between the max def and the edges of the
        %fault, sign depends on the direction and the asymmetry index
        if subs.AFIndex(f)>=0;
             
            if (subs.fDir(f)<=90) || (subs.fDir(f)>270)
            distMaxDefEdge2=((subs.x1F(:,f)-subs.xMaxDefNear(f)).^2+ (subs.y1F(:,f)-subs.yMaxDefNear(f)).^2).^(1/2);
            distMaxDefEdge1=((subs.x2F(:,f)-subs.xMaxDefNear(f)).^2+ (subs.y2F(:,f)-subs.yMaxDefNear(f)).^2).^(1/2);
            else
            distMaxDefEdge1=((subs.x1F(:,f)-subs.xMaxDefNear(f)).^2+ (subs.y1F(:,f)-subs.yMaxDefNear(f)).^2).^(1/2);
            distMaxDefEdge2=((subs.x2F(:,f)-subs.xMaxDefNear(f)).^2+ (subs.y2F(:,f)-subs.yMaxDefNear(f)).^2).^(1/2);
            end
            

        else
            if (subs.fDir(f)<=90) || (subs.fDir(f)>270)
            distMaxDefEdge1=((subs.x1F(:,f)-subs.xMaxDefNear(f)).^2+ (subs.y1F(:,f)-subs.yMaxDefNear(f)).^2).^(1/2);
            distMaxDefEdge2=((subs.x2F(:,f)-subs.xMaxDefNear(f)).^2+ (subs.y2F(:,f)-subs.yMaxDefNear(f)).^2).^(1/2);
            else
            distMaxDefEdge2=((subs.x1F(:,f)-subs.xMaxDefNear(f)).^2+ (subs.y1F(:,f)-subs.yMaxDefNear(f)).^2).^(1/2);
            distMaxDefEdge1=((subs.x2F(:,f)-subs.xMaxDefNear(f)).^2+ (subs.y2F(:,f)-subs.yMaxDefNear(f)).^2).^(1/2);
            end

        end
        
        
        
        %loop through all the timesteps and calculate an index grid
        %controling the deformation
        
        if subs.planeViewIndex(f)==0 %triangle
            for iteration=subs.startingTime(f):subs.endingTime(f)
                
                oneTimeDistMaxDefEdge1=distMaxDefEdge1(iteration);
                oneTimeDistMaxDefEdge2=distMaxDefEdge2(iteration);
                checkDistParallelToFaultToMaxDefPointCentre=zeros(subs.ySize,subs.xSize);
                checkDistParallelToFaultToMaxDefPointPositive=checkDistParallelToFaultToMaxDefPointCentre;

                checkDistParallelToFaultToMaxDefPointNegative=checkDistParallelToFaultToMaxDefPointPositive;

                
                %I'm in front of the max def point, def is max (index=1)
                checkDistParallelToFaultToMaxDefPointCentre(distParallelToFaultToMaxDefPoint==0)=1;
                
                
                
                 %I'm on the positive (shorter) side of the fault
                checkDistParallelToFaultToMaxDefPointPositive(distParallelToFaultToMaxDefPoint>0)=1;

                                
                if oneTimeDistMaxDefEdge1==0
                    distanceSurfacePointIndex2=zeros(subs.ySize,subs.xSize);
                else
                    distanceSurfacePointIndex2=checkDistParallelToFaultToMaxDefPointPositive.* (  (  ((-1)/oneTimeDistMaxDefEdge1)  .*  (distParallelToFaultToMaxDefPoint))  +1 );
                    
                end
                
                %I'm on the negative (larger) side of the fault
                checkDistParallelToFaultToMaxDefPointNegative(distParallelToFaultToMaxDefPoint<0)=1;
           
                                
                if oneTimeDistMaxDefEdge2==0
                    distanceSurfacePointIndex3=zeros(subs.ySize,subs.xSize);
                else
                distanceSurfacePointIndex3=checkDistParallelToFaultToMaxDefPointNegative.*(  (  ((1)/oneTimeDistMaxDefEdge2)  .*distParallelToFaultToMaxDefPoint) +1 );
                
                end
                
                distSurfacePointIndex(:,:,iteration)=(checkDistParallelToFaultToMaxDefPointCentre+distanceSurfacePointIndex2+distanceSurfacePointIndex3).*subs.indexSize(:,:,iteration);
                              
            end
            
            
        else
            if subs.planeViewIndex(f)==1 %square
                for iteration=subs.startingTime(f):subs.endingTime(f)
                    distSurfacePointIndex(:,:,iteration)=1.*subs.indexSize(:,:,iteration);
                end
                
                
            else %shape curved, use a quadratic function
                for iteration=subs.startingTime(f):subs.endingTime(f)
                    
                    checkDistParallelToFaultToMaxDefPointPositive=zeros(size(distParallelToFaultToMaxDefPoint));
                    checkDistParallelToFaultToMaxDefPointNegative=zeros(size(distParallelToFaultToMaxDefPoint));
                    checkDistParallelToFaultToMaxDefPointCentre=zeros(size(distParallelToFaultToMaxDefPoint));
                    checkDistParallelToFaultToMaxDefPointPositive(distParallelToFaultToMaxDefPoint>0)=1;
                    checkDistParallelToFaultToMaxDefPointNegative(distParallelToFaultToMaxDefPoint<0)=1;
                    checkDistParallelToFaultToMaxDefPointCentre(distParallelToFaultToMaxDefPoint==0)=1;
                    
                    
                    
                    distanceSurfacePointIndex2=checkDistParallelToFaultToMaxDefPointPositive.*((( (0-1)./((distMaxDefEdge1(iteration))-0).^2).*((distParallelToFaultToMaxDefPoint-0).^2)+1).*subs.indexSize(:,:,iteration));
                    distanceSurfacePointIndex2(isnan(distanceSurfacePointIndex2))=0;
                    
                    distanceSurfacePointIndex3=checkDistParallelToFaultToMaxDefPointNegative.*((( (0-1)./((distMaxDefEdge2(iteration))-0).^2).*((distParallelToFaultToMaxDefPoint-0).^2)+1).*subs.indexSize(:,:,iteration));
                    distanceSurfacePointIndex3(isnan(distanceSurfacePointIndex3))=0;
                    distSurfacePointIndex(:,:,iteration)=(distanceSurfacePointIndex2+distanceSurfacePointIndex3+checkDistParallelToFaultToMaxDefPointCentre).*subs.indexSize(:,:,iteration);
                    
                    
                end
            end
        end
        
        subs.distSurfacePointIndex=distSurfacePointIndex;
    end








%--------------------------------------------------------------------------


    function [subs]=generateFaultPlane(subs,f)
        
        %calculate the max length of the fault
        horizontal=( subs.fHeight(f)./subs.tanF) ./subs.cellSize;
            if subs.tanF==Inf; 
                horizontal=0; 
            end
        vertical=subs.fHeight(f);
        
        horizontalDef=subs.rateArray(:,f).*horizontal; %horizontal length of the fault at each time step
        verticalDef=subs.rateArray(:,f).*vertical; %vertical Depth of the fault at each time step
        
        subs.extenFaultArray=horizontalDef;
        subs.depthFaultArrayHW=verticalDef;
        
        %calculate the fault Plane in the grid
        subs.faultDepthGrid=(subs.distanceToFault).*(-subs.tanF).*subs.cellSize;
        
        %populate the grid with values
        %perpendicular to the fault, calculate for each time step the
        %distance to max depth of fault
        for t=subs.startingTime(f):subs.endingTime(f)
        subs.extenFaultGrid(:,:,t)=subs.extenFaultArray(t).*subs.distSurfacePointIndex(:,:,t);
        end
        
    end


%--------------------------------------------------------------------------

    function [subs]=generateSurface(subs,f)
        horizontal=subs.fDef(f);
        vertical=subs.fHeight(f);
        
        [horizontalDef,verticalDef]=maxValues(subs,f,horizontal,vertical);
        subs.extentOfDefHW=horizontalDef; 
        [subs,r,s,x1,y1,h,k]=line(subs,f,horizontalDef,verticalDef);
        
        
        %build the surface for each time step
        
        if subs.curveIndex(f)==0
            for t=subs.startingTime(f):subs.endingTime(f)
                subs.surfaceDepthGrid(:,:,t)=(subs.distanceToFault.*r(t))+s(t);

                
            end
        else
            %if subs.HWCode==1
            for t=subs.startingTime(f):subs.endingTime(f)
                
                subs.surfaceDepthGrid(:,:,t)=(((y1(t)-k)./((x1(t)-h(t)).^2)).*(((subs.distanceToFault)-h(t)).^2)+k);
                
                
            end
            %else
             %           for t=1:subs.maxT
                
              %  subs.surfaceDepthGrid(:,:,t)=(((y1-k(t))./((x1(t)-h(t)).^2)).*(((subs.distanceToFault)-h(t)).^2)+k(t));
                
                
               %         end
            %end
        end
        
        %scale the depth according to fault shape (square,triangular or curved)
        subs.surfaceDepthGrid=subs.surfaceDepthGrid.*subs.distSurfacePointIndex;        
        
    end
    




    function [horizontalDef,verticalDef]=maxValues(subs,f,horizontal,vertical)
        
        %calculate the max def point for each time step
        if subs.rotIndex==0
            
            horizontalDef=subs.rateArray(:,f).*horizontal;
            
        else
            horizontalDef=subs.activeTimeIndex(:,f).*horizontal;
            
        end
        
        %calculate the max depth for each time step
        verticalDef=subs.rateArray(:,f).*vertical;
    end

    function [subs,r,s,x1,y1,h,k]=line(subs,f,horizontalDef,verticalDef)
        
        r=[];
        s=[];
        x1=[];
        y1=[];
        h=[];
        k=[];
        if subs.curveIndex(f)==1 %convex surface
            %if subs.HWCode==1
            x1=subs.extenFaultArray;
            y1=(-1).*(verticalDef);
            h=horizontalDef;
            k=0;
            %else
            %h=subs.extenFaultArray;
            %k=(-1).*(verticalDef);
            %x1=horizontalDef;
            %y1=0;
            %end
            
        else %plane surface
            
            %build a plane surface
            %     y=a.x+b
            
            %calculate
            r= ((-1) .* (verticalDef-0)./(subs.extenFaultArray-horizontalDef));
            s= ((-1) .* r .* horizontalDef);
            
            
        end
        
        
    end



%--------------------------------------------------------------------------

    function [subs]=cropTheSurface(subs)
        
        %crop by the fault length
               
        subs.surfaceDepthGrid=subs.surfaceDepthGrid.*subs.indexSize;
        
        subs.faultDepthGridcropped=zeros(subs.ySize,subs.xSize,subs.maxT);        
        
        for t=1:subs.maxT
            
            
        %crop behind the fault plane
        
        %subs.faultDepthGridcropped(:,:,t)=subs.faultDepthGrid.*subs.distSurfacePointIndex(:,:,t);
        
        subs.faultDepthGridcropped(:,:,t)=subs.faultDepthGrid.*subs.indexSize(:,:,t);
        
        check=zeros(subs.ySize,subs.xSize);
        
        %check(subs.distanceToFault>=subs.extenFaultGrid(:,:,t))=1;
        
        
        
        check(subs.faultDepthGridcropped(:,:,t)<=subs.surfaceDepthGrid(:,:,t))=1;
        
        subs.surfaceDepthGrid(:,:,t)=subs.surfaceDepthGrid(:,:,t).*check;
        
        
        %crop behind the extent of deformation
        
        
        check=zeros(subs.ySize,subs.xSize); 
        check(subs.distanceToFault<=subs.extentOfDefHW(t))=1;
        subs.surfaceDepthGrid(:,:,t)=subs.surfaceDepthGrid(:,:,t).*check;
        end
        
        

        
    end




%--------------------------------------------------------------------------    


    function [subs]=addTheFault(subs)
        
        for t=1:subs.maxT
          
             check=zeros(subs.ySize,subs.xSize);
        
                         
             check(subs.surfaceDepthGrid(:,:,t)==0)=1;
             
             check=check.*subs.faultDepthGrid.*subs.indexSize(:,:,t);
             
             %crop behind the fault
             
             check(subs.distanceToFault<0)=0;
             
             check2=zeros(subs.ySize,subs.xSize);
             check2(subs.distanceToFault<subs.extentOfDefHW(t))=1;
                        
            subs.surfaceDepthGrid(:,:,t)=(subs.surfaceDepthGrid(:,:,t)+check).*check2;
            
        end
        
        if subs.HWCode==0
            subs.surfaceDepthGrid=subs.surfaceDepthGrid.*-1;
        end
        
    end






% figure (2)
% subplot (1,2,1)
% surf(subs.indexSize(:,:,1));
% axis square
% view(0,90)
% subplot (1,2,2)
% surf(subs.indexSize(:,:,subs.maxT));
% axis square
% view(0,90)
% 
% figure (3)
% subplot (1,2,1)
% surf(subs.surfaceDepthGrid(:,:,1));
% hold on
% plot([subs.x1F(1,f),subs.x2F(1,f)],[subs.y1F(1,f),subs.y2F(1,f)],'xr')
% axis square
% view(0,90)
% subplot (1,2,2)
% surf(subs.surfaceDepthGrid(:,:,subs.maxT));
% hold on
% plot([subs.x1F(subs.maxT,f),subs.x2F(subs.maxT,f)],[subs.y1F(subs.maxT,f),subs.y2F(subs.maxT,f)],'x-b')
% axis square
% view(0,90)










end

