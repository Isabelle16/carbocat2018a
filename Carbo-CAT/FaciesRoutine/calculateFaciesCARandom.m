function [glob] = calculateFaciesCARandom(glob, iteration, order)
% Calculate the facies cellular automata according to neighbour rules in
% glob.CARules and modify production rate modifier for each cell according
% to number of neighbours

% To avoid bias, facies must be dealt with in different order
% each time, hence orderArray
% But note, with variable iteration rate across the grid, this might become
% unecessary since variable it rate will sufficient variability to avoid
% bias
switch glob.maxProdFacies
    case 1
        orderArray = [1];
    case 2
        %orderArray = [1,2; 2,1];
        orderArray = [2,1; 1,2];
    case 3
        orderArray = [1,2,3; 2,3,1; 3,1,2];
    otherwise
        orderArray = [1,2,3,4; 2,3,1,4; 4,3,2,1;3,4,1,2];
        
        % need to add general condition here to deal with 4+ facies
        % cases
end
j = iteration - 1;
k = iteration;
% Neighbours contains a count of neighbours for each facies at each grid
% point and is populated by the countAllNeighbours function
neighbours = zeros(glob.ySize, glob.xSize, glob.maxProdFacies);


[neighbours] = countAllNeighbours(glob, j, neighbours);

glob.faciesProdAdjust = zeros(glob.ySize, glob.xSize);


for y = 1 : glob.ySize;
    for x= 1 : glob.xSize;
        
        % Get the facies currently present at y x for previous iteration
        oneFacies = glob.facies{y,x,j}(1);
        
        %calculate how thick sediment has been deposited in the previous
        %iteration (sed) and much the facies can produce.
        %If deposited sediment is thicker than the ability of the facies to
        %build vertically (pr), kill the facies
        sed=sum(glob.thickness{y,x,iteration-1}(2:end));
        if oneFacies <= glob.maxProdFacies && oneFacies>0
        pr=glob.prodRate(oneFacies) * calculateProductionWDAdjustment(glob, x,y, oneFacies, iteration);
        else
        pr=0;
        end
        
        
        % only do anything here if the latest stratal surface is below sea-level, i.e.
        % water depth > 0.001
        if glob.wd(y,x,iteration) > 0.001

            if oneFacies == 9 % So a subaerial hiatus, now reflooded because from above wd > 0
                
                checkProcess=strcmp(glob.refloodingRoutine,'pre-exposed');
                if checkProcess==1;
                    %get the facies from the pre-exposed
                    glob.facies{y,x,k}(1) = findPreHiatusFacies(glob, x,y,iteration); % reoccupy with facies f
                    glob.numberOfLayers(y,x,k)=1;
                else
                    %set facies =0;
                    glob.facies{y,x,k}(1) = 0;
                    glob.numberOfLayers(y,x,k)=0;
                end
                if glob.facies{y,x,k}(1)> glob.maxProdFacies || glob.facies{y,x,k}(1)==0
                    glob.facies{y,x,k}(1) = 0;
                    glob.numberOfLayers(y,x,k)=0;
                end
                % For cells already containing producing facies (and no transported on top) or 
                %cells containing transported facies but thinner than the
                %ability of the facies to build vertically.
            elseif ((oneFacies > 0 && oneFacies <= glob.maxProdFacies) && glob.numberOfLayers(y,x,j)==1) || ...
                    ((oneFacies <= glob.maxProdFacies && oneFacies>0) &&  glob.numberOfLayers(y,x,j)>1 && pr>sed);

                
                % Check if neighbours is less than min for survival CARules(i,2) or
                % greater than max for survival CARules(i,3), or if water depth is greater than production cutoff and if so kiil
                % that facies
                %or if the concentration of carbonate is too low
                thick = glob.carbonateVolMap(y,x) / (glob.ySize*glob.xSize);
                checkProcess=strcmp(glob.concentrationRoutine,'on');
                
                if (neighbours(y,x,oneFacies) < glob.CARules(oneFacies,2)) ||...
                        (neighbours(y,x,oneFacies) > glob.CARules(oneFacies,3)) ||...
                        (glob.wd(y,x,iteration) >= glob.prodRateWDCutOff(oneFacies)) ||...
                        ( checkProcess == 1 && thick < 0.01)
                    
                    glob.facies{y,x,k}(1) = 0;
                    
                else % The right number of neighbours exists 
                    %Facies persists if wave energy routine is off 
                    checkProcess=strcmp(glob.waveRoutine,'on');
                    if checkProcess==0 
                    glob.facies{y,x,k}(1) = oneFacies;
                    glob.numberOfLayers(y,x,k)=1;
                    
                    else% (wave energy is on )
                        
%                         if glob.wd(stats.averagePos(iteration-1,x),x,iteration-1)> (3/0.78) %the platform margin is below wave break, facies remains
%                             glob.facies{y,x,k}(1) = oneFacies;
%                             glob.numberOfLayers(y,x,k)=1;
%                         else %(the margin is above wave base; the facies remains if it is at the right energy level)
                            [mod]=calculateProductionWaveEnergyAdjustment(glob, x,y, oneFacies, iteration);
                            if mod==1
                                glob.facies{y,x,k}(1) = oneFacies;
                                glob.numberOfLayers(y,x,k)=1;
%                             else
%                                 glob.facies{y,x,k}(1) = 0; 
                            end
%                         end  
                    end
                end
                
                
            else % Otherwise cell must be empty or contain transported product so see if it can be colonised with a producing facies
                % Note that we do not want iteration count to apply to empty cells,
                % hence this else
                %check again the carbonate concentration
                thick = glob.carbonateVolMap(y,x) / (glob.ySize*glob.xSize);
                checkProcess=strcmp(glob.concentrationRoutine,'on');
                if checkProcess == 0 || thick > 0.01
                    for m = 1:glob.maxProdFacies % Loop through all the facies
                        
                        % Select a facies number from the order array. Remember this makes
                        % sure that facies occurrence in adjacent cells is checked in a
                        % different order each time step
                        p = orderArray(order, m);
                        
                        
                        % Check if number of neighbours is within range to trigger new
                        % facies cell, and only allow new cell if the water depth is less
                        % the production cut off depth
                        
                        if (neighbours(y,x,p) >= glob.CARules(p,4)) && (neighbours(y,x,p) <= glob.CARules(p,5) && glob.wd(y,x,iteration) < glob.prodRateWDCutOff(p))
                            %The right number of cells exist
                            %The facies colonise if wave energy routine is off
                            checkProcess=strcmp(glob.waveRoutine,'off');
                            if checkProcess ==1
                                glob.facies{y,x,k}(1) = p; % new facies cell triggered at y,x
                                glob.numberOfLayers(y,x,k)=1;
                            else %the energy routine is on, facies colonise only if the right energy level exists
                                [mod]=calculateProductionWaveEnergyAdjustment(glob, x,y, p, iteration);
                                    if mod==1 
                                        glob.facies{y,x,k}(1) = p;
                                        glob.numberOfLayers(y,x,k)=1;
%                                     else
%                                         glob.facies{y,x,k}(1) = 0;
                                    end
                            end
                        end
                    end
                end
                % added this on 21/03/16 to fix bug
                order = order + 1;
                if order > glob.maxProdFacies; order = 1; end
            end
            
            % Finally, calculate the production adjustment factor for the current facies distribution
            
            oneFacies = glob.facies{y,x,k}(1);
            
            glob.faciesProdAdjust(y,x)=calculateFaciesProductionAdjustementFactor(glob,y,x,oneFacies,neighbours);
            
        else
            
            glob.facies{y,x,k}(1) = 9; % Set to above sea-level facies because must be at or above sea-level%NB: change from 7 to 9 to support 4 facies
            glob.numberOfLayers(y,x,k)=1;
        end
    end
end
end


function [neighbours, numberOfNeighbours] = countAllNeighbours(glob, j, neighbours,numberOfNeighbours)
% Function to count the number of cells within radius containing facies 1
% to maxFacies across the whole grid and store results in neihgbours matrix

ySize=int16(glob.ySize);
xSize=int16(glob.xSize);
for yco = 1 : ySize;
    for xco = 1 : xSize;
        %get the facies of the centre cell
        oneFacies = glob.facies{yco,xco,j}(1);
        if oneFacies>0 && oneFacies<=glob.maxProdFacies
            %if the centre is occupied by a producing cell, get the radius
            %from the file
            radius = glob.CARules(oneFacies,1);
        else
            %if not use two (or one)
            radius = glob.CARules(1,1);
        end
        for l = -radius : radius;
            for m = -radius : radius;
                
                                    y = yco + l;
                    x = xco + m;
                    
                checkProcess=strcmp(glob.wrapRoutine,'unwrap');
                if checkProcess==1;
                    %if near the edge, complete in a mirror-like image the
                    %neighbours array

                    
                    if y<1;  y=1+(1-y); end
                    if x<1;  x=1+(1-x); end
                    if y>ySize; y=ySize+(ySize-y); end
                    if x>xSize; x=xSize+(xSize-x); end
                    
                else
                    %or wrap around the corners
                    if y<1;  y=ySize+1+l; end
                    if x<1;  x=xSize+1+m; end
                    if y>ySize; y=l; end
                    if x>xSize; x=m; end
                end
                %now count the neighbours using the x-y indeces
                
                %Don't include cell that has over a certain wd
                %difference, and penalise the CA with a factor
                wdDiff=abs(glob.wd(yco,xco,j)-glob.wd(y,x,j));
                
                if wdDiff>glob.BathiLimit
                    wdDiffFactor=0;
                else
                    wdDiffFactor=(-1/glob.BathiLimit)*wdDiff+1;
                end
                if wdDiffFactor>0.9; wdDiffFactor=1; end
                faciesType=glob.facies{y,x,j}(1);
                % Count producing facies as neighbours but do not include the center cell -
                % neighbours count should not include itself
                if faciesType > 0 && faciesType <= glob.maxProdFacies && not (l == 0 && m == 0)
                    neighbours(yco,xco,faciesType) = neighbours(yco,xco,faciesType) + (1*wdDiffFactor);
                end
                
            end
        end
    end
end


end

function [preHiatusFacies] = findPreHiatusFacies(glob, x,y,iteration)

k = iteration - 1;

while k > 0 && glob.facies{y,x,k}(1) == 9
    k = k - 1;
end

preHiatusFacies = glob.facies{y,x,k}(1);
end
