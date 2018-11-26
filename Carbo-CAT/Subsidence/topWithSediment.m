function [subs]=topWithSediment(subs)
subs.strataThick=zeros(subs.ySize, subs.xSize, subs.maxT);

subs.strata=zeros(subs.ySize, subs.xSize, subs.maxT);
% 
% %calculate the thickness to add at each time step
% for t=2:subs.maxT
%     for y=1:subs.ySize
%         for x=1:subs.xSize
%             if subs.subsidence(y,x,t)>=0;
%                 subs.strataThick(y,x,t)=subs.subsidence(y,x,t);
%                 
%             end
%         end
%     end
%     
%                 
% end

% for t=2:subs.maxT
% subs.thickness(:,:,t)=subs.finalSurface(:,:,t)-subs.finalSurface(:,:,t-1);
% 
% end

for t=2:subs.maxT
    
%now move the strata according to the subsidence
     strataprev = subs.strata(:,:,t-1);
     stratanow = subs.strata(:,:,t);
     stratanow(stratanow<strataprev)=strataprev(stratanow<strataprev);
     subs.strata(:,:,t)=stratanow;
    for layer=1:t %subside all layers
         
         
         subs.strata(:,:,layer)=subs.strata(:,:,layer)-subs.subsidence(:,:,t);

    end
    
%         strata=-subs.subsidence(:,:,t);
%     strata(strata<0)=0;
%     jaja=subs.strata(:,:,t)+strata;
%     subs.strata(:,:,t)=subs.strata(:,:,t)+strata;
    
    %grow the upper most layer
%      for y=1:subs.ySize
%          for x=1:subs.xSize
%       if subs.strata(y,x,t)>0;  
%      subs.strata(y,x,t)=subs.strata(y,x,t-1);
%       else
%           subs.strata(y,x,t)=0;
%       end
%          end
%      end
end



%subs.stratas(:,:,2)=-subs.subsidence(:,:,1)-subs.subsidence(:,:,2);
%subs.stratas(:,:,3)=-subs.subsidence(:,:,1)-subs.subsidence(:,:,2)-subs.subsidence(:,:,3);

%add sediment to all layers

end