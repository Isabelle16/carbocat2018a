function [deposThick, flowThick] = depoStepGradient(flowThick, deposThick, nbrGrads, glob, y, x)
 
                   %% Deposit a defined amount of sediment
                   
                   if glob.emt == 1
                       deposPercent = glob.fracDepos(glob.sedType)./3;
                   elseif glob.emt == 2
                       deposPercent = glob.fracDepos(glob.sedType)./2;
                   else
                       deposPercent = glob.fracDepos(glob.sedType);
                   end
                   
                   deposVol = (flowThick(y,x)).*deposPercent; 
                   deposThick(y,x) = (deposThick(y,x))+deposVol;
                          
                   % amount of sediment that keep flowing
                   flowThick(y,x) = (flowThick(y,x))-deposVol;  
                    
%             
                    %% Calculate the sediment fraction received by each lower cell from the current cell(y,x)
                    % w is a weighting factor (increase w allow to
                    % concentrate the flow in cell with higher gradient
                    % enabling to obtain a more elongated lobe)                       
                        nbrGrads = nbrGrads.^glob.flowRadiationFactor(glob.sedType); 
                        sedFrac = nbrGrads/sum(nbrGrads);   
                        
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

                        
                        
                        
                        
                        
                        
                        