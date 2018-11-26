function [mod] = calculateProductionWaveEnergyAdjustment(glob, x,y, f, iteration)
%Define the wave energy and/or water depth conditions for each factory
mod = 0;
if f==1
    if glob.wave(y,x,iteration) >= glob.minEnergy(f) && glob.wave(y,x,iteration) <= glob.maxEnergy(f) 
        mod=1;
    else
        mod=0;
    end
    
elseif f==2     
    if glob.wave(y,x,iteration) >= glob.minEnergy(f) && glob.wave(y,x,iteration) <= glob.maxEnergy(f) 
        mod=1;
    else
        mod=0;
    end
    
elseif f==3
     if glob.wave(y,x,iteration) >= glob.minEnergy(f) && glob.wave(y,x,iteration) <= glob.maxEnergy(f) 
         mod=1;
     else
         mod=0;
     end
elseif f == 4
     if glob.wave(y,x,iteration) >= glob.minEnergy(f) && glob.wave(y,x,iteration) <= glob.maxEnergy(f) 
         mod=1;
     else
         mod=0;
     end
end
    
end