function [iAngle,yi,xi] = calculateIncidenceAngle(gy,gx,yDest,xDest,yr,xr)


    G = [gy(yDest,xDest) gx(yDest,xDest)];  % norm vector
    G2 = G;
    G3 = G;
    Vi = [yr xr]; % incidence ray vector
    
    if G(1)==0 && G(2)==0
            iAngle =0;
    else
     % The norm vector should point in the same direction of
        % the incident ray  
        
       iAngle = atan2d(G(1), G(2)) - atan2d(yr, xr);
       
       if iAngle > 90 || iAngle < -90
            
           G = [-gy(yDest,xDest) -gx(yDest,xDest)]; % norm vector pointing in the same direction of Vi
  
       
        iAngle = atan2d(G(1), G(2)) - atan2d(yr, xr);
       
       end
       
       dummyG = sign(G);
      
       if iAngle > 90 || iAngle < -90
          
           G = G2;
           
           iAngle = (180 - abs(atan2d(yr, xr))) + (180 - abs(atan2d(G(1), G(2))));
            
            if dummyG(2)==1
                iAngle = - iAngle;
            end

       end
       
       if iAngle > 90 || iAngle < -90
          
           G = [-gy(yDest,xDest) -gx(yDest,xDest)];
           
           iAngle = (180 - abs(atan2d(yr, xr))) + (180 - abs(atan2d(G(1), G(2))));
            
            if dummyG(2)==1
                iAngle = - iAngle;
            end

       end
        

        
          % Check
          if iAngle > 90 || iAngle < -90
            stop = 1;
          end      
            

    end

    yi = yr;
    xi = xr;

end











