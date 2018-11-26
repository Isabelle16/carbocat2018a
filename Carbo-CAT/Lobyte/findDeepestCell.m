function [deepY, deepX, sedLost, glob] = findDeepestCell(dummyTopog, glob, sedLost, it)
    
    deepestCellHeight = dummyTopog(glob.yIn,glob.xIn); 
    deepX = glob.xIn;
    deepY = glob.yIn;
    
  
    
    if it == 1 && glob.sedType == 2 % if we are in the first step of the siliciclastic transport phase, avoid flow to go backward
                                    % set if the input cell/s is/are along the y = 1 row
                                     
       N = [0 1; 1 1; 1 0; 1 -1; 0 -1]; % N contains the neighbours cell indices starting from E
       aa = [1:2:5];
       bb = [2:2:4];         
    else
       N = [0 1;1 1;1 0;1 -1;0 -1;-1 -1;-1 0;-1 1;]; % N contains the neighbours cell indices starting from E 
       aa = [1:2:7];
       bb = [2:2:8];      
    end   
  
    yInd = N(:,1);
    xInd = N(:,2);
    
    rookY = 0;
    rookX = 0;
    bishY = 0;
    bishX = 0;
      
     % shuffle indices to avoid trend
     aarand = aa(randperm(length(aa)));
     bbrand = bb(randperm(length(bb))); 
   
     % find the deepest cell between N,S,W,E cells (rook's case)         
    for i = 1:size(aa,2)
        k = aarand(i);
        yN = glob.yIn+yInd(k);              
        xN = glob.xIn+xInd(k);
    
        if yN~=0 && xN~=0
        if dummyTopog(yN,xN) < deepestCellHeight
            deepestCellHeight = dummyTopog(yN,xN);
            rookY = yN;                   
            rookX = xN;
            rookCellIndex = k;
        end    
        end
    end
  
    deepestCellHeight = dummyTopog(glob.yIn,glob.xIn);

    % find the deepest cell between diagonal cells (bishop's case)     
    for j = size(bb,2)
        k = bbrand(j);
        yN = glob.yIn+yInd(k);              
        xN = glob.xIn+xInd(k); 
      
        if yN~=0 && xN~=0
        if dummyTopog(yN,xN) < deepestCellHeight  
            deepestCellHeight = dummyTopog(yN,xN);
            bishY = yN;
            bishX = xN; 
            bishCellIndex = k;
        end
        end
    end
       
    % if none of the cells (rook case) is lower:
    if rookY == 0   
        rookY = deepY;
        rookX = deepX;
        rookCellIndex = 0;
    end
    
     % if none of the cells (bishop case) is lower:
    if bishY == 0  
        bishY = deepY;
        bishX = deepX;  
        bishCellIndex = 0;
    end

    % move to the closest cell    
    if dummyTopog(bishY,bishX) < dummyTopog(rookY,rookX)
        deepY=bishY;
        deepX=bishX;
        glob.cellIndex = bishCellIndex;
    else
        deepY=rookY;
        deepX=rookX;
        glob.cellIndex = rookCellIndex;
    end  
    
    if deepY==1 || deepY==size(dummyTopog,1) || deepX==1 || deepX==size(dummyTopog,2)
        % flow crosses model boundary and get lost
        sedLost = true;
    end
    
end                 
    
% function [yco, xco] = checkBoundaries(glob, yco, xco)
% 
%     %check boundaries:
%     checkProcess=strcmp(glob.wrapRoutine,'unwrap');
%      if checkProcess==1
%         %if in the edge, close boundary
%         if xco < 1; xco=1; end
%         if xco > glob.xSize; xco=glob.xSize; end
%         if yco < 1; yco = 1; end
%         if yco > glob.ySize; yco = glob.ySize; end
%     else
%         %wrap
%         if xco < 1; xco=glob.xSize; end
%         if xco > glob.xSize; xco=1; end
%         if yco < 1; yco = glob.ySize; end
%         if yco > glob.ySize; yco = 1; end
%     end
% 
% end


