function [pltf] = calculatePlatformShearStress (glob, iteration)

%% Initialize arrays
pltf.tauSlope = zeros(glob.ySize,glob.xSize); %shear stress due to topographic gradient
pltf.tauCurrent = zeros(glob.ySize,glob.xSize); %shear stress due to unidirectional current 
pltf.tauFlow = zeros(glob.ySize,glob.xSize); %resultant, total shear stress 
tauCurrentY(:,:) = zeros(glob.ySize,glob.xSize); 
tauCurrentX(:,:) = zeros(glob.ySize,glob.xSize);
pltf.tauFlowAspect = zeros(glob.ySize,glob.xSize);
pltf.tauCurrentAspect = zeros(glob.ySize,glob.xSize);
topog = glob.strata(:,:,iteration); 

% Define current direction (vector component) for every point along the platform
tauCurrentY(:,:) = glob.tauCurrentY; 
tauCurrentX(:,:) = glob.tauCurrentX; 

% find the current angle with x axis
pltf.tauCurrentAspect(:,:) =  atan2(glob.tauCurrentY,glob.tauCurrentX);


%% Calculate shear stress due to the slope    
[gradX,gradY] = gradient(topog); % vector gradient x and y component        
% gradAspect = atan2(gradX,gradY); % gradient angle from x+ axis
gradMagnitude = sqrt(gradX.^2 + gradY.^2);

averageD50 = 0.0001; %%!!!!!!!!!!!!!!!!!

% calculate slope shear stress and component
for i = 1:glob.ySize
    for j = 1:glob.xSize

        pltf.tauSlope(i,j) = (glob.deltaRho*glob.gravity*averageD50*gradMagnitude(i,j)); 

        pltf.slopeX(i,j) = (pltf.tauSlope(i,j) / gradMagnitude(i,j)) * gradX(i,j);
        pltf.slopeY(i,j) = (pltf.tauSlope(i,j) / gradMagnitude(i,j)) * gradY(i,j);
        
    end
end

%% Calculate shear stress due to currents and waves 
% the effect of tauCurrent is represented by unidirectional
% shear stress vector field, where the shear stress value varies with depth.

% Calculate tauCurrent for the entire platform
for i = 1:glob.ySize
    for j = 1:glob.xSize 
        
         if glob.wd(i,j,iteration) > 0 && glob.wd(i,j,iteration) < glob.currentDepthCutOff
         pltf.tauCurrent(i,j) = glob.currentMaxShearStress * tanh(exp(-glob.currentDump*glob.wd(i,j,iteration)));  
            pltf.currentX(i,j) = pltf.tauCurrent(i,j)*tauCurrentX(i,j) ;
            pltf.currentY(i,j) = pltf.tauCurrent(i,j)*tauCurrentY(i,j) ;
         else           
         pltf.tauCurrent(i,j) = 0;  
         pltf.currentX(i,j) = 0;
         pltf.currentY(i,j) = 0;
         end   
         
    end
end

                
%% Sum tauCurrent and tauSlope
% sum tauCurrent and tauSlope vector component to find resultant vector
% component

for i = 1:glob.ySize
    for j = 1:glob.xSize
        
%         if glob.wd(i,j,iteration) > 0
          pltf.flowY(i,j) = pltf.currentY(i,j) + pltf.slopeY(i,j);
          pltf.flowX(i,j) = pltf.currentX(i,j) + pltf.slopeX(i,j);
          if isnan(pltf.slopeY(i,j)) == 1 || isnan(pltf.slopeY(i,j)) == 1
                pltf.flowY(i,j) = pltf.currentY(i,j);
                pltf.flowX(i,j) = pltf.currentX(i,j);
          end
          
          
%         else
%             pltf.flowY(i,j) = 0;
%             pltf.flowX(i,j) = 0; 
%         end
 
    end
end

% find resultant vector magnitude
for i = 1:glob.ySize
    for j = 1:glob.xSize
      
      pltf.tauFlow(i,j) = sqrt(pltf.flowY(i,j)^2 + pltf.flowX(i,j)^2);

    end
end

% find the angle 
for i = 1:glob.ySize
    for j = 1:glob.xSize

      pltf.tauFlowAspect(i,j) =  atan2(pltf.flowY(i,j),pltf.flowX(i,j));
  
           
    end
end

% graphic_pltfTransport(glob, iteration, topog, pltf);

end

% 
function graphic_pltfTransport(glob, iteration, topog, pltf)

figure(23)
hh = surface(topog);
%put light and shading 
camlight(18,5); 
set(hh,'FaceAlpha',0.5);
set(hh,'specularexponent',100.,'specularstrength',0.0,'EdgeColor', 'None'); 
set(hh,'diffusestrength',[0.9],'Ambientstrength',0.3); 
% hold on
% contour3(1:glob.ySize,1:glob.xSize,topog);
hold on
slopeZ = zeros(size(pltf.slopeX));
quiver3(topog,pltf.slopeX, pltf.slopeY,slopeZ , 'AutoScale','on', 'AutoscaleFactor', 0.9,'color','red')
hold off
title('Slope shear stress vector field')
view(-52,40)


figure(24)
hh = surface(topog);
%put light and shading 
camlight(18,5); 
set(hh,'FaceAlpha',0.5);
set(hh,'specularexponent',100.,'specularstrength',0.0,'EdgeColor', 'None'); 
set(hh,'diffusestrength',[0.9],'Ambientstrength',0.3); 
% hold on
% contour3(1:glob.ySize,1:glob.xSize,topog);
hold on
currentZ = zeros(size(pltf.currentX));
quiver3(topog,pltf.currentX, pltf.currentY,currentZ , 'AutoScale','on', 'AutoscaleFactor', 0.9,'color','red')
hold off
title('Current shear stress vector field')
view(-52,40)
axis on

figure(25)
hh = surface(topog);
%put light and shading 
camlight(18,5); 
set(hh,'FaceAlpha',0.5);
set(hh,'specularexponent',100.,'specularstrength',0.0,'EdgeColor', 'None'); 
set(hh,'diffusestrength',[0.9],'Ambientstrength',0.3); 
% hold on
% contour3(1:glob.ySize,1:glob.xSize,topog);
hold on
flowZ = zeros(size(pltf.flowX));
quiver3(topog,pltf.flowX, pltf.flowY,flowZ, 'AutoScale','on', 'AutoscaleFactor', 0.9,'color','red')
hold off
title('Total shear stress vector field')
view(-52,40)
% 
end



