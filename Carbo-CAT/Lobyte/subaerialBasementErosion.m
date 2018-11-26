function [topog, glob] = subaerialBasementErosion(topog, glob)
% calculate the erosion from subaerial fotwall with the development of a
% catchment area.
% [Modified from M. H. Trauth - Matlab recipes for Earth Sciences] 
dummyTopog = topog;

%filter the topography using filter2 
F = 1/9 * ones(3,3);
dummyTopog = filter2(F, dummyTopog); 
dummyTopog = dummyTopog(2:glob.ySize-1, 2:glob.xSize-1);

% % % onshoreTopog = dummyTopog;
% % % onshoreTopog(1,:) = onshoreTopog(2,:);
% % % onshoreTopog(end,:) = onshoreTopog(end-1,:);
% % % onshoreTopog(:,1) = onshoreTopog(:,2);
% % % onshoreTopog(:,end) = onshoreTopog(:,end-1);
% % % onshoreTopog = dummyTopog >= glob.faultYCo+1;% glob.SL(glob.it);
% % % onshoreTopog = onshoreTopog.*dummyTopog;
onshoreTopog = dummyTopog(1:glob.faultYCo-1,:);
% % % % Remove zero rows
% % % onshoreTopog( all(~onshoreTopog,2), : ) = [];
% % % % Remove zero columns
% % % onshoreTopog( :, all(~onshoreTopog,1) ) = [];

% % replace zero value in onshoretOpog with the value in the same position
% % from dummyTopog
% dummyTopog = dummyTopog(1:size(onshoreTopog,1),1:size(onshoreTopog,2));
% onshoreTopog(onshoreTopog==0) = dummyTopog(onshoreTopog==0);

% onshoreTopog(1,:) = onshoreTopog(2,:);
% onshoreTopog(end,:) = onshoreTopog(end-1,:);
% onshoreTopog(:,1) = onshoreTopog(:,2);
% onshoreTopog(:,end) = onshoreTopog(:,end-1);


% % detect drainage basins and watersheds
% watersh = watershed(onshoreTopog);
% 
% % figure(11)
% % h = pcolor(watersh); 
% % colormap(hsv), colorbar 
% % set(h,'LineStyle','none') 
% % axis equal
% % title('Watershed') 
% % [r c] = size(watersh); 
% % axis([1 c 1 r])
% % set(gca,'TickDir','out');
% 
% cc = bwconncomp(watersh); 
% catchmentNum = cc.NumObjects;


% % % % % % find local minima for every drainage basin (from which start transport)
% % % % % for i = 1:catchmentNum
% % % % %     [row, col] = ind2sub(size(onshoreTopog), cc.PixelIdxList{i}); % cc.PixelIdxList = cell array in which each cell contains indices of the upsole contributing area
% % % % %     for k = 1:size(row)
% % % % %         dummy(k) = onshoreTopog(row(k),col(k));
% % % % %     end
% % % % %         [localMin ind] = min(dummy);
% % % % %         yMin(i) = row(ind); 
% % % % %         xMin(i) = col(ind);  
% % % % %         
% % % % %         dummy = 0;
% % % % % end
% % % % %   
[grads] = neighbourGradients(onshoreTopog, glob);
% flow accumulation algorithm (multiple-flow-direction method)
N = [0 -1;-1 -1;-1 0;-1 +1;0 +1;+1 +1;+1 0;+1 -1];  
w = 50; %1.1; % weighting factor allowing the concentration of the flow in the max gradient direction
flow = (grads.*(-1*grads<0)).^w; % select gradients that are less that zero (up-slope) and multiply them for the weighting factor w
upssum = sum(flow,3); % sum the up-slope gradient
upssum(upssum==0) = 1; % replace gradient values of zero by 1
for i = 1:8
flow(:,:,i) = flow(:,:,i).*(flow(:,:,i)>0)./upssum;
end
inflowsum = upssum; 
flowac = upssum;
inflow = grads*0;

while sum(inflowsum(:))>0   %%% QUI DEVO CORREGGERE IL TREND!!!!!
    for i = 1:8
     inflow(:,:,i) = circshift(inflowsum,[N(i,1) N(i,2)]); 
    end
inflowsum = sum(inflow.*flow.*grads>0,3); 
flowac = flowac + inflowsum; % flowac = flow accumulation, represent the catchment area
end

% figure(12)
% h = pcolor(log(1+flowac)); 
% colormap(flipud(jet)), colorbar
% set(h,'LineStyle','none') 
% axis equal
% title('Flow accumulation') 
% [r c] = size(flowac); 
% axis([1 c 1 r])
% set(gca,'TickDir','out');

% stream power index (potential of erosion)

[maxSlope, angleMaxSlope] = maxSlopeHorn(onshoreTopog, glob);

spi = flowac.*tand(maxSlope);

% figure(13)
% h = pcolor(log(1+spi)); 
% colormap(jet), colorbar 
% set(h,'LineStyle','none') 
% axis equal
% title('Stream power index') 
% [r c] = size(spi); 
% axis([1 c 1 r])
% set(gca,'TickDir','out');

%% REGOLITE/DILAVAMENTO DEPOSITION = TRASPORTO MATERIALE CON LINEAR DIFFUSION



% % %% landsliding erosion
% % % find the lowest nodes in channels respect to base level
% % 
% % landslideBaseLevel = dummyTopog(20,:);
% % [localMin indices] = min(landslideBaseLevel);
% % [row col] = ind2sub (landslideBaseLevel,indices);
% % landCoord = [20, col];






% % erode the topography (proportional to stream power and calculate the eroded volume proportional to stream power!!!)
onshoreTopog = onshoreTopog - spi*10; 
[row col] = size(onshoreTopog);
topog(1:row,1:col) = onshoreTopog;

% % % % % calculate the material eroded for each drainage basin (proportional to spi and drainage area) 
% % % % for i = 1:catchmentNum
% % % %     [row, col] = ind2sub(size(onshoreTopog), cc.PixelIdxList{i}); % cc.PixelIdxList = cell array in which each cell contains indices of the upsole contributing area
% % % %     for k = 1:size(row)
% % % %         dummyThick(k) = spi(row(k),col(k));
% % % %     end
% % % %         drainedThick(i) = sum(dummyThick); 
% % % %         dummy = 0;
% % % % end

% % % % output:
% % % glob.y = yMin(2:end-1);
% % % glob.x = xMin(2:end-1);
% % % % eroded volume = thickness for each catchment
% % % glob.erodedSed = drainedThick(2:end-1).*10^-3;  

% % %  glob.transEvent = length(glob.x); % number of transport events
end

