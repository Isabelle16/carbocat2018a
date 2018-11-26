function newSynthetics(glob, iteration, xPos)
%calculates synthetic seismics along the platform at the given x position

%calculate pseudo reflectivity from the thickness of the formations


ex=zeros(iteration,glob.ySize);
psR=zeros(iteration,glob.ySize);

%ex is thickness
for t=2:iteration
    for y=2:glob.ySize
        
       ex(t,y)=ex(t-1,y)+sum(glob.thickness{y,xPos,t});
       psR(t,y)=(ex(t,y)-ex(t,y-1))/(ex(t,y)+ex(t,y-1));if isnan(psR(t,y))==1;psR(t,y)=0;end;
    end
end

insitu=zeros(iteration,glob.ySize);
total=zeros(iteration,glob.ySize);
ex2=zeros(iteration,glob.ySize);
psR2=zeros(iteration,glob.ySize);
% %ex is insitu/total thickness
for t=2:iteration
    for y=2:glob.ySize
        insitu(t,y)=insitu(t-1,y)+sum(glob.thickness{y,xPos,t}(1));
        total(t,y)=total(t-1,y)+sum(glob.thickness{y,xPos,t});
       ex2(t,y)=insitu(t,y)/total(t,y);
       psR2(t,y)=(ex2(t,y)-ex2(t,y-1))/(ex2(t,y)+ex2(t,y-1));if isnan(psR2(t,y))==1;psR2(t,y)=0;end;
    end
end


%chrono-strat?
figure,
for t=1:iteration-1
    for y=2:glob.ySize
        if psR(t,y)==0
            color=[1,1,1];
        elseif psR(t,y)<0
            c=psR(t,y)/min(psR(:));
            color=[1-c,1-c,1];
        else
            c=psR(t,y)/max(psR(:));
            color=[1,1-c,1-c];
        end
        
        xco=[y,y+1,y+1,y];
        yco=[t,t,t+1,t+1];

        patch(xco,yco,color,'EdgeColor','none');axis ij; axis tight;
    end
end

figure,
for t=1:iteration-1
    for y=2:glob.ySize
        if psR2(t,y)==0
            color=[1,1,1];
        elseif psR2(t,y)<0
            c=psR2(t,y)/min(psR2(:));
            color=[1-c,1-c,1];
        else
            c=psR2(t,y)/max(psR2(:));
            color=[1,1-c,1-c];
        end
        
        xco=[y,y+1,y+1,y];
        yco=[t,t,t+1,t+1];

        patch(xco,yco,color,'EdgeColor','none');axis ij; axis tight;
    end
end

end 

