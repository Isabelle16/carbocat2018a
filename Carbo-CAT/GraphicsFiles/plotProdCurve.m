function plotProdCurve(glob, iteration)

% ffOne = figure(6);
ffOne = figure('Visible','off');

axis ij
ylabel('Water depth (m)');
xlabel('Production rates (m/My)');
axis tight 
minMax = max(glob.prodRate/glob.deltaT);
% axis([-(minMax*0.05) minMax*1.05 0 100]);
axis([-(minMax*0.05) 8000 0 100]);
grid on;
depth=0:100;
   set(gca,'FontSize',40,'FontWeight','bold')
   
for j=1:glob.maxProdFacies
    if glob.surfaceLight(j)>500
    %use this if you want to use Schlager's production profile
    prodDepth = (glob.prodRate(j)/glob.deltaT) * tanh((glob.surfaceLight(j) * exp(-glob.extinctionCoeff(j) * depth))/ glob.saturatingLight(j));
    else
    %use this if you want to use new production profile
    prodDepth = (glob.prodRate(j)./glob.deltaT).* (1./ (1+((depth-glob.profCentre(j))./glob.profWidth(j)).^(2.*glob.profSlope(j))) );
    end
    lineCol = [glob.faciesColours(j,2) glob.faciesColours(j,3) glob.faciesColours(j,4)];
    line(prodDepth, depth, 'color', lineCol, 'LineWidth',4);
end

% set figure position and dimension
width = 125;     % Width in inches
height = 85;    % Height in inches
set(ffOne, 'Position', [0.5 0.5 width*10, height*15]); %<- Set size

%% Save image using save_fig

set(ffOne,'Color','none'); % set transparent background
set(gca,'Color','none');

export_fig( sprintf('ProductionCurveHigh %d',iteration),...
   '-png', '-transparent', '-m12', '-q101');
    
end