function [subs]=initializeFaults(subs)

[subs]=initializeArrays(subs);

    function [subs]=initializeArrays(subs)
        %Generate initial arrays used in calculations
        subs.surfaceFinal=zeros(subs.ySize,subs.xSize,subs.maxT);
        subs.tArray=(1:subs.maxT); %an array used for calculating time dependent variables
        subs.xArray=1:subs.xSize;  %an array used for calculating space dependent variables
        subs.yArray=1:subs.ySize;  %an array used for calculating space dependent variables
        
        subs.xArray2D=repmat(subs.xArray,subs.ySize,1); %could be done with a loop
        subs.yArray2D=transpose(repmat(subs.yArray,subs.xSize,1));
        
        
        
        %pre-allocate
        subs.activeTime=zeros(subs.maxF,1);
        subs.activeTimeArray=transpose(zeros(subs.maxF,subs.maxT));
        subs.activeTimeIndex=zeros(subs.maxT,subs.maxF);
        
        subs.dLength=zeros(subs.maxT,subs.maxF);
        
        subs.x1F=zeros(subs.maxT,subs.maxF);%x position at each time step
        subs.x2F=zeros(subs.maxT,subs.maxF);%x position at each time step
        subs.y1F=zeros(subs.maxT,subs.maxF); %y position at each time step
        subs.y2F=zeros(subs.maxT,subs.maxF);%y position at each time step
        
    end

%loop throught all the faults
for f=1:subs.maxF
    
    faultDir=subs.fDir(f);
    
    [subs]=calculateTimeArrays(subs,f);
    
    [subs]=calculateFaultsLengths(subs,f);
    
    [subs]=calculateEdges(subs,f,faultDir);
    
    [subs]=calculateMaxDeformationPointsOverTheFault(subs,f);
    
    [subs]=calculateMaxDeformationPointsHW(subs,f,faultDir);
    
    [subs]=calculateMaxDeformationPointsFW(subs,f,faultDir);
end

    function [subs]=calculateTimeArrays(subs,f)
        subs.activeTime(f)=subs.endingTime(f)-subs.startingTime(f);
        subs.activeTimeArray(subs.startingTime(f):subs.endingTime(f),f)=(1:(subs.activeTime(f)+1));
        subs.activeTimeIndex(:,f)=(subs.activeTimeArray(:,f)>=1);
    end

    function [subs]=calculateFaultsLengths(subs,f)
        %calculate the length of the fault in plane view(time dependent)
        %re-write lengths in term of grid size
        subs.fLengthF(f)=subs.fLengthF(f)./subs.cellSize;
        subs.fLengthI(f)=subs.fLengthI(f)./subs.cellSize;
        varLength=(subs.fLengthF(f)-subs.fLengthI(f));
        
        if subs.rateIndex(f)==0 %constant rate
            deltaL = (varLength)/(subs.activeTime(f)); %variation of extend of deformation considering rate remains constant
            bLength = (deltaL*(-1)); %theoretical extend of deformation at t=0 (b of the line)
            subs.dLength(:,f) = (deltaL .* subs.activeTimeArray(:,f) + bLength +subs.fLengthI(f)) .* subs.activeTimeIndex(:,f); %extend of deformation (fault length) at each time step
            if subs.activeTime(f)==0;
                subs.dLength(1,f)=subs.fLengthI(f);
            end
        elseif subs.rateIndex(f)==1 %increasing rate
            %variation has the shape of a quadratic equation. y(x)=((y1-k)/((x1-h)^2))*((x)-h)^2+k;
            x1=subs.activeTime(f)+1;
            y1=varLength;
            h=1;
            k=0;
            subs.dLength(:,f)=(( ((y1-k)/((x1-h)^2)) .* ((subs.activeTimeArray(:,f)-h).^2) + k) + subs.fLengthI(f)).*subs.activeTimeIndex(:,f);
                if subs.activeTime(f)==0;
                subs.dLength(1,f)=subs.fLengthI(f);
            end
        else %decreasing rate
            %variation has the shape of a quadratic equation. y(x)=((y1-k)/(x1-h)^2)*((x)-h)^2+k;
            x1=1;
            y1=0;
            h=subs.activeTime(f)+1;
            k=varLength;
            subs.dLength(:,f)=(( ((y1-k)/((x1-h)^2)) .* ((subs.activeTimeArray(:,f)-h).^2) + k) + subs.fLengthI(f)).*subs.activeTimeIndex(:,f);
                        if subs.activeTime(f)==0;
                subs.dLength(1,f)=subs.fLengthI(f);
            end
        end
    end

    function[subs]=calculateEdges(subs,f,faultDir)  %calculate the fault's edge coordinates
        
        %pre-allocate
        timeAI=subs.activeTimeIndex(:,f);
        
        
        if subs. AFIndex(f)==0 %this means that the faults spreads to both sides
            deltaLength=abs(subs.dLength(:,f)./2);
        else %this means the fault spreads to one side
            deltaLength=subs.dLength(:,f).*subs.AFIndex(f);
        end
        
        xF=sind(faultDir).*(deltaLength);
        yF=cosd(faultDir).*(deltaLength);
        
        
        if subs. AFIndex(f)==0 %this means that the faults spreads to both sides
            subs.x1F(:,f)=(xF+subs.xI(f)).*timeAI; %x position in each time step
            subs.x2F(:,f)=(-xF+subs.xI(f)).*timeAI; %x position in each time step
            subs.y1F(:,f)=(yF+subs.yI(f)).*timeAI; %y position in each time step
            subs.y2F(:,f)=(-yF+subs.yI(f)).*timeAI; %y position in each time step
        else
            subs.x1F(:,f)=(subs.xI(f)).*timeAI; %x position at each time step
            subs.x2F(:,f)=(xF+subs.xI(f)).*timeAI; %x position at each time step
            subs.y1F(:,f)=(subs.yI(f)).*timeAI; %y position at each time step
            subs.y2F(:,f)=(yF+subs.yI(f)).*timeAI; %y position at each time step
        end
    end




    function [subs]=calculateMaxDeformationPointsOverTheFault(subs,f)
        
        %calculate the point's coordinates where max def

            subs.xMaxDefNear(f)=subs.xI(f);
            subs.yMaxDefNear(f)=subs.yI(f);
        

        
        
    end



    function [subs]=calculateMaxDeformationPointsHW(subs,f,faultDir)
        %adjust max def to grid size
        subs.fDef(f)=subs.fDef(f)./subs.cellSize;
        
        %calculate the max extension point
        deltaY=sind(faultDir+180).*subs.fDef(f);
        deltaX=cosd(faultDir).*subs.fDef(f);
        subs.xMaxDefFarHw(f)=subs.xMaxDefNear(f)+deltaX;
        subs.yMaxDefFarHw(f)=subs.yMaxDefNear(f)+deltaY;
        
        
    end

    function [subs]=calculateMaxDeformationPointsFW(subs,f,faultDir)
        %adjust max def to grid size
        subs.fwDef(f)=subs.fwDef(f)./subs.cellSize;
        
        %calculate the max extension point
        deltaY=sind(faultDir+180).*subs.fwDef(f);
        deltaX=cosd(faultDir).*subs.fwDef(f);
        subs.xMaxDefFarFw(f)=subs.xMaxDefNear(f)-deltaX;
        subs.yMaxDefFarFw(f)=subs.yMaxDefNear(f)-deltaY;
        
    end
end




