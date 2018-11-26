function [subs]=generateSubsidenceMaps(subs)

subs.subsidence=zeros(subs.ySize,subs.xSize,subs.maxT);

if subs.regSubsidenceTrend == 1 % decreasing subsidence
  
    for t=2:subs.maxT
        subs.subsidence(:,:,t)=subs.finalSurface(:,:,t-1)-subs.finalSurface(:,:,t);
        regSubsidenceThisTimeStep = (subs.regSubsidence(1) * subs.timeStep) - (subs.timeStep * (((subs.regSubsidence(1) - subs.regSubsidence(2)) / subs.maxT) * t));
        subs.subsidence(:,:,t)=subs.subsidence(:,:,t) + regSubsidenceThisTimeStep;
    end

elseif subs.regSubsidenceTrend == -1 % For increasing subsidence

    for t=subs.maxT:-1:2
        subs.subsidence(:,:,t)=subs.finalSurface(:,:,t-1)-subs.finalSurface(:,:,t);
        regSubsidenceThisTimeStep = (subs.regSubsidence(1) * subs.timeStep) - (subs.timeStep * (((subs.regSubsidence(1) - subs.regSubsidence(2)) / subs.maxT) * t));
        subs.subsidence(:,:,t)=subs.subsidence(:,:,t) + regSubsidenceThisTimeStep;
    end

elseif subs.regSubsidenceTrend == 0  % For constant subsidence

    for t=2:subs.maxT
        subs.subsidence(:,:,t)=subs.finalSurface(:,:,t-1)-subs.finalSurface(:,:,t);   
    end
    
    subs.subsidence=(subs.subsidence)+(subs.regSubsidence(1)*subs.timeStep);
end 


%% To avoid artifacts (with fault azimuth = 90!!!!)
for i = 1:subs.maxF
 subs.subsidence(subs.yI(i),:,:) = subs.subsidence(subs.yI(i)-1,:,:);
end


end