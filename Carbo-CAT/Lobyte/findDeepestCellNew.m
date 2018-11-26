function [deepY, deepX, sedLost, sedTrap, cellIndex] = findDeepestCellNew(dummyTopog, y, x, it, glob)

sedLost = false;
sedTrap = false;
cellIndex = 3;

% create a vector with al the Nbr cell topography
% topogNbr contains the topography of the neighbouring cells strating from
% East
topogNbr = [dummyTopog(y,x+1); dummyTopog(y+1,x+1); dummyTopog(y+1,x); dummyTopog(y+1,x-1);...
                dummyTopog(y,x-1); dummyTopog(y-1,x-1); dummyTopog(y-1,x); dummyTopog(y-1,x+1)]; 
            
N = [0 1;1 1;1 0;1 -1;0 -1;-1 -1;-1 0;-1 1]; % N contains the neighbours cell indices starting from E 
 
% % % if glob.sedType == 2    % avoid siliciclastic loss outside model boundaries
% % %     
% % %    topogNbr = [dummyTopog(y,x+1); dummyTopog(y+1,x+1); dummyTopog(y+1,x); dummyTopog(y+1,x-1);...
% % %                 dummyTopog(y,x-1)]; 
% % %             
% % % N = [0 1;1 1;1 0;1 -1;0 -1]; % N contains the neighbours cell indices starting from E 
% % %         
% % % end


   if min(topogNbr) <= dummyTopog(y,x)   % at least one lower/equal cell exists 
       
       [val, ~] = min(topogNbr);  % find the minimum and its index
       [row] = find(topogNbr == val); % find all the elements of dummyTopog that are equal to the mimum
       
       if size(row) == 1 % the minimum is unique
           
           deepY = y + N(row,1);
           deepX = x + N(row,2);
           
           cellIndex = row;
           
       else % the minimum is non-unique, shuffle coord and take a random cell between the lowest
           
           aa = 1:length(row);
           aarand = aa(randperm(length(aa)));
           indx = aarand(1); 
           randCellInd = row(indx);
           
           deepY = y + N(randCellInd,1);
           deepX = x + N(randCellInd,2);
           
           cellIndex = randCellInd;   
  
       end
       
       
   end
   
    if min(topogNbr) > dummyTopog(y,x) % none of the Nbr cell is lower
        sedTrap = true;
        
        deepY = y;
        deepX = x; 
    end

    if deepY==1 || deepY==size(dummyTopog,1) || deepX==1 || deepX==size(dummyTopog,2)
         % flow crosses model boundary and get lost
        sedLost = true;
    end   
    
end

    