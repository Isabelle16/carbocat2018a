function [yOut,xOut,step,rayDone,rowDone] = checkDestCell(glob,yOut,xOut,yDest,xDest,ySize, xSize, step,rayDone,i,rowDone,WD,waveBreak,winDir)


% if we are within the model boundaries
if yDest <= ySize && yDest > 0 && xDest <= xSize...
    && xDest > 0 && WD(yDest,xDest) >= 0.1 && waveBreak == false 

    yOut = yDest;
    xOut = xDest;
    step = step+1;
    
   
    
    return

% if we are at the model boundaries
elseif yDest > ySize || yDest == 0 || xDest > xSize...
    || xDest == 0  ||  WD(yDest,xDest) < 0.1 || waveBreak == true
    step = 1;
    rayDone = true; 
       
    % check if a new ray wave should start along the current row
   
    
    if strcmp(winDir,'-y') || strcmp(winDir,'+y')
    
        row = glob.rayStep(:,i,i);
        row1 = row;
        rowwd = WD(:,i);
        row(rowwd < 0.1) = NaN; 
        
        if strcmp(winDir,'-y')
          [y] = find(row == 0,1,'last');
            if isempty(y)  
               rowDone = true; 
            elseif y ~= 0 && sum(row1(1:y))==0
                yOut = y;
                xOut = i;  
            else
                rowDone = true;    
            end
        else
          [y] = find(row == 0,1,'first');
    
            if isempty(y)
                rowDone = true; 
            elseif y ~= 0 && sum(row1(y:end))==0
                yOut = y;
                xOut = i;  
            else
                rowDone = true;    
            end
        
        end
        
        
    else % winDir = +-x
        row = glob.rayStep(i,:,i);
        row1 = row;
        rowwd = WD(i,:);
        row(rowwd < 0.1) = NaN; 
        
        if strcmp(winDir,'-x')
          [x] = find(row == 0,1,'last');
            if isempty(x)  
               rowDone = true; 
            elseif x ~= 0 && sum(row1(1:x))==0
                yOut = i;
                xOut = x;  
            else
                rowDone = true;    
            end
        else
          [x] = find(row == 0,1,'first');
    
            if isempty(x)
                rowDone = true; 
            elseif x ~= 0 && sum(row1(x:end))==0
                yOut = i;
                xOut = x;  
            else
                rowDone = true;    
            end
        
        end
        
    end
    
    
    
    
   
end










