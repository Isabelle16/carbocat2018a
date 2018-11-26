function testSubProdCalc
glob.maxIts = 500000;
glob.wd = zeros(glob.maxIts,1);
glob.strata = zeros(glob.maxIts,1);
glob.deltaT = 0.001;
glob.initWD = 0;
glob.subRate = 1000;
glob.prodRate = 500;
glob.prodDepthAdjust = 1;
glob.SLPeriod1 = 0;
glob.SLAmp1 = 0;
glob.SLPeriod2 = 0;
glob.SLAmp2 = 0;
glob.SL = zeros(glob.maxIts,1);
glob.surfaceLight = 2000;
glob.extinctionCoeff = 0.075;
glob.saturatingLight = 300;

totalThick = zeros(20,2);
subTimeStep = glob.deltaT;
modelRun = 1;

i=1:100;
prodDepthPlot(i,1) = tanh((glob.surfaceLight * exp(-glob.extinctionCoeff * i))/ glob.saturatingLight) * glob.prodRate;
plot(prodDepthPlot);
axis ij;

goOnGoOn = input('Continue...');

while subTimeStep > 0.000001 && modelRun <= 20

    prodRate = glob.prodRate * subTimeStep;
    subRate = glob.subRate * subTimeStep;
    glob.strata = zeros(glob.maxIts,1);
    glob.wd = zeros(glob.maxIts,1);
    glob.wd(1) = 10.0;
    prodSum = 0;
    
    emt = 0.0;
    totalIterations =  0.10 / subTimeStep;
    iteration = 2;
    %if totalIterations > glob.maxIts fprintf('More than %d iterations\n',glob.maxIts); break;end
        
    fprintf('Run %d sub time step %8.7f total iterations %d ... ', modelRun, subTimeStep, totalIterations);
    
    while iteration < totalIterations

        % Calculate the elapsed model time
        emt = subTimeStep * iteration;
        glob.wd(iteration) = glob.wd(iteration-1) + subRate;

        % Bosscher and Schlager production variation with water depth
        if (glob.wd(iteration) > 0.0)
            glob.prodDepthAdjust = tanh((glob.surfaceLight * exp(-glob.extinctionCoeff * glob.wd(iteration)))/ glob.saturatingLight);
        else
            glob.prodDepthAdjust = 0;
        end

        % Set production to depth and neighbour-adjusted rate for this
        % facies. Note that faciesProdAdjust is calculated in calculateFaciesCA
        prod = prodRate * glob.prodDepthAdjust;

        if prod > glob.wd(iteration) % if production > accommodation set prod=accommodation
            prod = glob.wd(iteration);
        end
        
        prodSum = prodSum + prod;
        %fprintf('WD %5.4f Production %5.4f \n', glob.wd(iteration), prod);
        
        % Decrease WD by amount of production
        glob.wd(iteration) = glob.wd(iteration) - prod;

        % Record the production as thickness in the strata array
        glob.strata(iteration) = glob.strata(iteration-1) + prod;
        
        iteration = iteration + 1;
    end
    
    totalThick(modelRun,1) = prodSum;
    totalThick(modelRun,2) = subTimeStep;
    fprintf('Total thickness %3.2f\n', totalThick(modelRun));
    subTimeStep = subTimeStep / 2.0;
    modelRun = modelRun + 1;
end

%totalThick(modelRun:20) = [];
totalThick

graph1 = semilogx(totalThick(:,2), totalThick(:,1), 'marker', 'square');
%axis(graph1, 'GridLineStyle','--');


  


