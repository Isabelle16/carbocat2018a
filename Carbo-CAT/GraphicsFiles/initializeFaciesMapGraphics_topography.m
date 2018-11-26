function initializeFaciesMapGraphics_topography(glob, iteration)
%% facies map

% ffOne = figure(4);
ffOne = figure('Visible','off');

% Load and apply the 3 facies colourmap from the params folder
%load('colorMaps/colorMapCA3Facies','colorMapCA3Facies');
%set(graph.main,'Colormap',colorMapCA3Facies);
if glob.maxProdFacies==1
load('colorMaps/colorMapCA1Facies','CA1FaciesCMap');
CAFaciesCMap=CA1FaciesCMap;
elseif glob.maxProdFacies==2
load('colorMaps/colorMapCA2Facies','CA2FaciesCMap');
CAFaciesCMap=CA2FaciesCMap;
elseif glob.maxProdFacies==3
load('colorMaps/colorMapCA3Facies','CA3FaciesCMap');
CAFaciesCMap=CA3FaciesCMap;
elseif glob.maxProdFacies==4
load('colorMaps/colorMapCA4Facies','CA4FaciesCMap');
CAFaciesCMap=CA4FaciesCMap;
end

faciesM=zeros(glob.ySize,glob.xSize);
testX = 1:glob.xSize;
testY = 1:glob.ySize;
for y=1:glob.ySize
    for x=1:glob.xSize
        faciesM(y,x)=glob.facies{y,x,iteration}(1);
    end
end
p=pcolor(testX, testY, double(faciesM));
set(p,'LineStyle','none');
view([0 90]);
xlabel('X Distance (km)');
ylabel('Y Distance (km)');
set(gca,'FontSize',30)
axis square
colormap(CAFaciesCMap);

    
% Set figure position and dimension
width = 125;     % Width in inches
height = 125;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*10, height*15]); % <- Set size

% Save image using save_fig
set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('InitialFaciesMap %d',iteration),...
   '-png', '-transparent', '-m8', '-q101');

end