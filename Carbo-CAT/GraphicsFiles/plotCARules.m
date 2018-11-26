function plotCARules(glob, iteration)

% ffOne = figure(7);
ffOne = figure('Visible','off');

radius=glob.CARules(1:glob.maxProdFacies,1);
bigRadius=max(radius(:));

    baseF=+0.5;
    for f=1:glob.maxProdFacies
    minS=glob.CARules(f,2);
    maxS=glob.CARules(f,3);
    minT=glob.CARules(f,4);
    maxT=glob.CARules(f,5);
    Col = [glob.faciesColours(f,2) glob.faciesColours(f,3) glob.faciesColours(f,4)];
    patch([minS maxS maxS minS],[baseF+0+0.1 baseF+0+0.1 baseF+0.5 baseF+0.5],Col,'linewidth',3);
    patch([minT maxT maxT minT],[baseF+0.5 baseF+0.5 baseF+1-0.1 baseF+1-0.1],Col,'edgeColor','k','linewidth',3);
    
    
    posX=(minS+(maxS-minS)/2);
    posY=baseF+.3;
    text(posX,posY,'S','FontSize',20);
    posX=(minT+(maxT-minT)/2);
    posY=baseF+0.7;
    text(posX,posY,'T','FontSize',20);
    baseF=baseF+1;
    end
    axis([0 (((bigRadius*2+1))^2)-1 0.5 glob.maxProdFacies+.5]);
    xTicks=[0:2:(((bigRadius*2+1))^2)-1];
    yTicks=[1:1:glob.maxProdFacies];
     
set(gca,'XTick',xTicks)
set(gca,'YTick',yTicks)

xlabel('CA rules');
ylabel('Facies');
axis tight 

set(gca,'FontSize',35)
   
% set figure position and dimension
width = 125;     % Width in inches
height = 125;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*7, height*7]); %<- Set size

%% Save image using save_fig

set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('CARules %d',iteration),...
   '-png', '-transparent', '-m8', '-q101');
    
end