function [ deposThick, flowThick] = depoStepKinetics(flowThick, deposThick, flowNbr, glob, topog, y, x)
% y, x  = coordinates of the current cell

% add flow thickness in the current cell topography
dummyTopog = topog(y,x);
topog(y,x) = topog(y,x) + flowThick(y,x);   %% questa cosa non ha senso, devo aggiungere l'altezza della testa del flusso = head flow height. 

% topogNbr contains the topography of the neighbouring cells starting from
% East
topogNbr = [topog(y,x+1); topog(y+1,x+1); topog(y+1,x); topog(y+1,x-1);...
                topog(y,x-1); topog(y-1,x-1); topog(y-1,x); topog(y-1,x+1)]; 
            
% if all neighbouring cell are higher than the current cell, all sediment
% are deposited
if isempty(find(topogNbr<topog(y,x), 1))
   deposThick(y,x) = (deposThick(y,x))+(flowThick(y,x));
   
     % Update flowThick
        flowThick(y,x) = 0;

% if at least one of the neighbouring cells is lower or equal...
elseif (find(topogNbr<=topog(y,x), 1)) > 0
    % deposit the 20% of the flow
    deposVol = 0.1*(flowThick(y,x));
    deposThick(y,x) = deposThick(y,x) + deposVol;
    
    % amount of sediment that keep flowing
    flowThick(y,x) = (flowThick(y,x)) - deposVol; 

    %% Calculate the sediment fraction received by each neighbouring cell from the current cell(y,x)
    % w is a weighting factor (increase w allow to
    % concentrate the flow in cell with higher gradient
    % enabling to obtain a more elongated lobe)
    % higher cell will receive less sediment:
    topogNbr(topogNbr > topog(y,x)) = 0; % flow doesn't go in higher cells
    % memory effect
    topogNbr = topogNbr.*flowNbr; % memory effect
    topogNbr = topogNbr.^glob.flowRadiationFactor(glob.sedType); 
    sedFrac = topogNbr/sum(topogNbr);
    
    [row, col] = find(isnan(sedFrac));
    
    if row > 0 
        % if all neighbouring cell are higher than the current cell, all sediment
        % are deposited
        if isempty(find(topogNbr<topog(y,x), 1))
            
           deposThick(y,x) = (deposThick(y,x))+(flowThick(y,x));
   
         % Update flowThick
            flowThick(y,x) = 0;
        
        end  
        
    else
        
    %% Partial Flow from current cell(y,x)
    % partialFlow is a 3x3 matrix of zeros. Then put the
    % thickness of the current cell(y,x) in the central
    % cell(2,2).                           
    partialFlow = zeros(3,3);  
    partialFlow(2,2) = flowThick(y,x);
    % use circshift to move the sediment in the suitable
    % neighbouring cells (N.B. sedFrac is zero for higher cells and already occupied cells)
    partialFlow = circshift(partialFlow,[0 1]).*(sedFrac(1))...   
    + circshift(partialFlow,[1 1]).*(sedFrac(2))...  
    + circshift(partialFlow,[1 0]).*(sedFrac(3))... 
    + circshift(partialFlow,[1 -1]).*(sedFrac(4))...
    + circshift(partialFlow,[0 -1]).*(sedFrac(5))...
    + circshift(partialFlow,[-1 -1]).*(sedFrac(6))...
    + circshift(partialFlow,[-1 0]).*(sedFrac(7))...
    + circshift(partialFlow,[-1 1]).*(sedFrac(8));

    %% Update flowThick
     % once the partial flow has been calculated, store the result in flowThick. 
        flowThick(y-1:y+1, x-1:x+1) = flowThick(y-1:y+1, x-1:x+1) + partialFlow;

      if ~isempty(find(partialFlow, 1)) 
          flowThick(y,x) = 0; 
      end 


    end
 
end 

end
