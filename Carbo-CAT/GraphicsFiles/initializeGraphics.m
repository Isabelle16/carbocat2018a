function initializeGraphics(glob, ~, subs, iteration)

    
%% Initial Subsidence map
initializeSubsGraphics_topography(glob, subs, iteration);

%% Initial Bathymetry map
initializeBathymetryGraphics(glob, subs, iteration);
    
%% Initial Facies map
initializeFaciesMapGraphics_topography(glob, iteration)
% 
%% Initial Water-Level curve
initializeEustaticCurveGraphic(glob, iteration)

% Production depth curve plot
plotProdCurve(glob, iteration);

%% CA rules plot 
plotCARules(glob, iteration)

%% Plot siliciclastic input curve
initializeSiliciclasticInputCurveGraphic(glob, iteration) 

   


end
