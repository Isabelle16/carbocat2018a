% function [strata,facies] = addSiliciclastic(UpStrata, UpFacies)
function [glob] = addSiliciclastic(glob)

%% Add before Petrel routine
sandFCode = 11;
shaleFCode = 12;
strataThickness = [50 60 70 80 90 100]; % tickness of sand a and shale layers
topH = 100;
i = 1;
maxH = -10000;

%% add 2000 strata of siliciclastic 
while maxH < topH 
    
    it = glob.totalIterations +i;
    pos = randi(length(strataThickness));
    deposThick = strataThickness(pos);
   
    if mod(it,2) == 0
     fCode = sandFCode;
    else
     fCode = shaleFCode; 
    end
    
     minH = min(min(glob.strata(:,:,it-1)));
     maxH = max(max(glob.strata(:,:,it-1)));
     
     
        maxLevel = minH + deposThick;
        minLevel = minH; 

         for y=1:glob.ySize
            for x=1:glob.xSize

                    bottom = glob.strata(y,x,it-1);

                    layerStrata = maxLevel - (glob.strata(y,x,it-1));

                    if bottom >= minLevel && bottom < maxLevel 

                        glob.strata(y,x,it) = glob.strata(y,x,it-1) + layerStrata;
                        glob.facies{y,x,it} = fCode;
                        glob.thickness{y,x,it}= layerStrata;
                    else
                        glob.strata(y,x,it) = glob.strata(y,x,it-1); 
%                         glob.facies{y,x,it}(1) = 0;
                    end
            end
         end
         i = i+1;
end

% % % %% Add after Petrel routine
% % % [ySize,xSize,maxIteration]=size(UpStrata); % UpStrata = upscaled strata array created by Estani's routine
% % % maxItFacies = size(UpFacies,3); % UpFacies = upscaled facies array created by Estani's routine
% % % strata = zeros(ySize,xSize,maxIteration + 10);  % Initialize new strata array where I want to add the overburden succession
% % % strata(:,:,1:maxIteration) = UpStrata; % add existing carbonate platform strata 
% % % facies = zeros(ySize,xSize,maxIteration + 10); % Initialize new facies array where I want to add the overburden succession
% % % facies(:,:,1:maxItFacies) = UpFacies; % add existing carbonate platform facies
% % % 
% % % newIter = maxIteration + 10;
% % % 
% % % sandFCode = 11; % sand facies code
% % % shaleFCode = 12; % shale facies code
% % % noFacies = -9999; % no facies
% % % strataThickness = [3 5 7 10 12 15 18 20]; % tickness of sand a and shale layers
% % % % strataThickness = [200 300];
% % % minH = 10000;
% % % 
% % % %% The following for loops find the loowest/deepest point in the platform top  
% % %     for y = 1:ySize
% % %         for x = 1:xSize
% % %             
% % %             minPos = find(strata(y,x,:) ~= 0,1,'last'); 
% % %             min = strata(y,x,minPos);
% % %             if min < minH
% % %                 minH = min;
% % %             end
% % %             
% % %             
% % %         end
% % %     end
% % %     
% % % % minH = min(min(min(strata(:,:,:)))); % model lowest point
% % % maxH = max(max(max((strata(:,:,:))))) + 30; %% highest point to be reached by the siliciclastic succession
% % % 
% % % H = -10000;
% % % it = 1;
% % % 
% % % % iteration = maxIteration+1; %first iteration to fill
% % % 
% % % while H <= maxH  %% maxH == highest point to be reached by the siliciclastic succession
% % %     
% % %     %% Pick a random thickness from the strataThickness arrays
% % %     pos = randperm(length(strataThickness));
% % %     deposThick = strataThickness(pos(1)); 
% % %     
% % %     %% Pick a facies (shale or sand alternatively with iterations)
% % %     if mod(it,2) == 0 
% % %         fCode = sandFCode;
% % %     else
% % %        fCode = shaleFCode; 
% % %     end
% % %     
% % %     %% the shale/sand strata needs to drap uniformily the platform top irregularities (they are post-tectonic strata)
% % %     % hence we start depositing the layers in the lowest point of the
% % %     % platform 
% % %     maxLevel = minH + deposThick; %% heigth of the overburden current strata top
% % %     minLevel = minH; %% height of bottom of the overburden strata
% % %    
% % %    %% In the lowest point of the platform we add the whole thickness of the current overburden strata
% % %    %% now check if other points of the carbonate platform are below the top of the overburden layer and then
% % %    %% add part of that layer to that cells to (NB: the strata has to 'DRAPE' the platform topography)
% % %     for y = 1:ySize
% % %         for x = 1:xSize
% % %             
% % %             %% find current cell top height  
% % %             bottomCo = find(strata(y,x,:) ~= 0,1,'last'); 
% % %             bottom = strata(y,x,bottomCo); %% find the top platform strata for current cell 
% % %             
% % %             %% For every cell, in the UpscaledFacies array there may be multiple coordinate with the same height (no heigth increase)
% % %             %% so find the lowest, upper part of the platform 
% % %             while bottom == strata(y,x,bottomCo-1) 
% % %                 strata(y,x,bottomCo) = 0;
% % %                 bottomCo = bottomCo-1;
% % %                 bottom = strata(y,x,bottomCo);
% % %             end
% % %             
% % % 
% % %             %% layerStrata is the thickness 'portion' of the current overburden layer that we can deposit in this cell
% % %             %% keeping the top at the same level in every model cell
% % %             layerStrata = maxLevel - (strata(y,x,bottomCo)); 
% % %             
% % %             %% if the top of the platform is heigher that the  height of bottom of the overburden strata (minLevel) and
% % %             %% lower that his top (maxLevel) add the layer thickness and the corresponding facies
% % %             if bottom >= minLevel && bottom < maxLevel 
% % %                 strata(y,x,bottomCo+1) = strata(y,x,bottomCo) + layerStrata; 
% % %                 facies(y,x,bottomCo) = fCode;
% % %             else
% % % %                 strata(y,x,bottomCo+1) = 0 ; %strata(y,x,bottomCo+1); 
% % % %                 facies(y,x,bottomCo) = noFacies;
% % %             end
% % %         end
% % %     end
% % % 
% % %     H = max(max(max(strata(:,:,:))));
% % %     it = it+1;
% % %     
% % %     minH = 10000;
% % % 
% % %     for y = 1:ySize
% % %         for x = 1:xSize
% % %             
% % %             minPos = find(strata(y,x,:) ~= 0,1,'last');
% % %             min = strata(y,x,minPos);
% % %             if min < minH
% % %                 minH = min;
% % %             end
% % %             
% % %             
% % %         end
% % %     end
% % % 
% % % end
% % %     
% % % %% fill the last iterations with no strata (strata==0) (the ones added to include the overburden) with -9999 facies code
% % % for y = 1:ySize
% % %  for x = 1:xSize
% % %      for it = 1:newIter
% % % 
% % %         if strata(y,x,it) == 0
% % %             facies(y,x,it) = noFacies;
% % %         end
% % %      end
% % %  end
% % %  
% % % end







end