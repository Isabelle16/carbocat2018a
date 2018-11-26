function [waveH,waveEnergy,waveBreak] = calculateWaveEnergy (glob,g,rho,fetch,WD,yOut,xOut,Li,waveEnergy)

d = WD(yOut,xOut);
formerWaveEnergy = waveEnergy;


% Calculate wave height from fetch area and wind
a = double(g*fetch/glob.windVelocity^2);
b = 0.283*tanh(0.0125*(a)^0.42); 
waveH= b*glob.windVelocity^2/g;  %wave height in m

% Calculate wave energy
waveEnergy=(rho*g*waveH^2)/8; %wave energy density...

if d < Li/2 %wave interacts with sea bottom (calculate energy dissipation)
    
extinctionCoeff = (0.3*(d/waveH)^-2)/(0.3*((waveH/0.78)/waveH)^-2);

    if extinctionCoeff > 0
        
        waveEnergy = waveEnergy * (1 - extinctionCoeff);

    else % breaking wave depth
        
%       waveBreak = true; 
%       waveEnergy = formerWaveEnergy;
        
    end
 
    
end

if waveEnergy <= 0
    waveEnergy = formerWaveEnergy;
    waveBreak = true;
else 
    waveBreak = false;
    
end

    

    




% end

end