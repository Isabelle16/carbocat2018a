function [glob] = calculateProduction(glob, iteration)

%% Calculate the sub-time step parameters
glob = calculateSubTimeStepParams(glob,iteration);

%% Calculate carbonate production for each point on the grid.
oneFacies = uint8(0);
prod = 0.0;
prodMap = zeros(glob.ySize, glob.xSize);
glob.suspendedTransportThickMap = zeros(glob.ySize, glob.xSize);
glob.bedloadTransportThickMap = zeros(glob.ySize, glob.xSize);
availableForTransport = 0.0;
totalProd=0.0;

for y=1:glob.ySize
    for x=1:glob.xSize
              
        oneFacies =  glob.facies{y,x,iteration}(1);
        subIts = glob.subIts(y,x); % number of iterations to calculate production
        deltaWD = glob.dWD(y,x); % water depth interval to be add at every sub-iteration
        
        waterDepth = glob.wd(y,x,iteration-1) + deltaWD; 
        
        for i = 1:subIts
            
%             waterDepth = glob.wd(y,x,iteration-1) + deltaWD; 
   

            if oneFacies > 0 && oneFacies <= glob.maxProdFacies && waterDepth > 0

                % Bosscher and Schlager production variation with water depth
                if waterDepth > 0.0

                    if glob.surfaceLight(oneFacies) > 500
                        %use this if you want to use Schlager's production profile
                        glob.prodDepthAdjust(y,x) =  tanh((glob.surfaceLight(oneFacies) * exp(-glob.extinctionCoeff(oneFacies) * waterDepth))/ glob.saturatingLight(oneFacies));
                    else
                        %use this if you want to use new production profile
                        glob.prodDepthAdjust(y,x) = (1./ (1+((waterDepth-glob.profCentre(oneFacies))./glob.profWidth(oneFacies)).^(2.*glob.profSlope(oneFacies))) );
                    end

                else
                    glob.prodDepthAdjust(y,x) = 0;                     
                end

                % Set production thickness to depth and neighbour-adjusted thickness for this
                % facies. Note that faciesProdAdjust is calculated in calculateFaciesCA
                % glob.faciesProdAdjust(y,x)=1; %delete this line to neighbour-adjusted production to work
                prod = glob.prodRate(oneFacies) * glob.prodDepthAdjust(y,x) * glob.productionBySiliciclasticMap(y,x,oneFacies) * glob.faciesProdAdjust(y,x);

                if prod > waterDepth % if production > accommodation set prod=accommodation to avoid build above SL
                    prod = waterDepth;
                end

                % check against the dissolved carbonate volume
                checkProcess = strcmp(glob.concentrationRoutine,'on');
                if checkProcess == 1
                    volp = prod*(glob.dx^2); %in metres
                    if volp>glob.carbonateVolMap(y,x)
                        volp=glob.carbonateVolMap(y,x);
                        glob.carbonateVolMap(y,x)=0;
                    else
                        glob.carbonateVolMap(y,x)=glob.carbonateVolMap(y,x) - volp;
                    end
                    prod = volp/(glob.dx^2);
                end


                prodMap(y,x) = prodMap(y,x) + prod;
                
                
                %% Calculate the transportable thickness as a proportion of production.

                  if glob.medianGrainDiameter(oneFacies) >= glob.transThreshold
                      
                      glob.bedloadTransportThickMap(y,x) = prod * glob.transportFraction(oneFacies);
                  else
                      glob.suspendedTransportThickMap(y,x) = prod * glob.transportFraction(oneFacies);
                  end
                  

            else % No deposition so record zero thickness
                glob.prodDepthAdjust(y,x) = 0;
                prodMap(y,x) = prodMap(y,x) + 0;
            end
            
            % Increase the water depth by the water depth interval and
            % decrease it by the carbonate produced in the current sub-iter
             waterDepth = waterDepth + deltaWD - prod; 
        end
        %% Update arrays     
        
        % Decrease WD by amount of production
        glob.wd(y,x,iteration) = glob.wd(y,x,iteration) - prodMap(y,x);

        % Update strata and thickness arrays
        if isempty(find(glob.facies{y,x,iteration}(:) == 8, 1)) % 8 == SILICICLASTIC FACIES CODE
            glob.strata(y,x,iteration) = glob.strata(y,x,iteration-1) + prodMap(y,x); 
            glob.thickness{y,x,iteration}(1) = prodMap(y,x);
        else
            glob.strata(y,x,iteration) = glob.strata(y,x,iteration) + prodMap(y,x); 
            glob.thickness{y,x,iteration}(1) = prodMap(y,x);
        end
        
        if x==50 && y==32
            fprintf('SL %3.2f WD:%3.2f @25,25 Facies %d Prod %3.2f ', glob.SL(iteration), glob.wd(y,x,iteration), oneFacies, prodMap(y,x));
        end
    
    end
end

totalProd = sum(sum(prodMap));

fprintf('Total accum. %3.2f For suspension trans %3.2f For bedload trans %3.2f ', totalProd, sum(sum(glob.suspendedTransportThickMap(:,:))),...
    sum(sum(glob.bedloadTransportThickMap(:,:))));


end




