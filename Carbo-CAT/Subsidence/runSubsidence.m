function [subs]=runSubsidence(subs)
%close all
%clear all
%clc
if subs.maxF>0
subs=initializeFaults(subs);
subs=generateRateArray(subs);
subs=calculateFaults(subs);
else
subs.finalSurface=zeros(subs.ySize,subs.xSize,subs.maxT);
end
[subs]=generateSubsidenceMaps(subs);

end


