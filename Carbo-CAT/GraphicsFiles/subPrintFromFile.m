function subPrintFromFile(glob,  iteration, xPosition, yPosition,kk)


%% Reverse the effect of subsidence
% iter =1;

% if glob.plotFromFile == true
%     glob.strata = glob.strata(:,:,1:iteration);
%    for l = 1:iteration
%        glob.strata(:,:,l) = glob.strata(:,:,l) + sum(subs.subsidence(:,:,iteration+1:glob.totalIterations),3); 
%    end
%    subs.subsidence =  subs.subsidence(:,:,1:iteration); 
% end

% plot3DModel(glob,subs,iteration,yPosition,xPosition) % plot 3D view
% plotWaveEnergyDistribution(glob,subs, iteration) % plot wave energy distribution
           
for jPos = 1:size(xPosition,2)

 xPos = xPosition(jPos);
  plotCrossSectionX_forSeismic(glob,xPos,iteration,kk)
%  plotCrossSectionX_dynamic(glob,xPos,iteration,kk);
%  plotChronostratSectionX_dynamic(glob,xPos,iteration,kk); 
 
end
          
% for iPos = 1:size(yPosition,2)
% 
% yPos = yPosition(iPos); 
% plotCrossSectionY_dynamic(glob, yPos, iteration,kk)
% plotChronostratSectionY_dynamic(glob, yPos, iteration,kk)
% 
% end

% eustaticCurve_dynamic(glob, iteration)

       
end
