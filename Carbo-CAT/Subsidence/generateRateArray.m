function [subs]=generateRateArray(subs)

 subs.rateArray=zeros(subs.maxT,subs.maxF);

for f=1:subs.maxF;
    
%get the rate information for the fault


        activeTA=subs.activeTimeArray(:,f);
        activeTI=subs.activeTimeIndex(:,f); 
        
if subs.rateIndex(f)==0 %constant rate
rateArray=1/(subs.activeTime(f)+1):(1/(subs.activeTime(f)+1)):1;
subs.rateArray(subs.startingTime(f):subs.endingTime(f),f)=rateArray;

else
    if subs.rateIndex(f)==-1 %decreasing rate
        
        x1=0;
        y1=0;
            
        h=subs.activeTime(f)+1;
        k=1;
            

        
        subs.rateArray(:,f)=( ((y1-k)/((x1-h)^2)) .* ((activeTA-h).^2) + k).*activeTI;
            %variation has the shape of a quadratic equation. y(x)=((y1-k)/(x1-h)^2)*((x)-h)^2+k;
    else %increasing rate
                
        x1=subs.activeTime(f)+1;
        y1=1;
            
        h=0;
        k=0;
        
subs.rateArray(:,f)=( ((y1-k)/((x1-h)^2)) .* ((activeTA-h).^2) + k).*activeTI;
    end

    
end

end