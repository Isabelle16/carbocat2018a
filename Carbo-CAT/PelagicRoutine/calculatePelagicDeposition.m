function [glob] = calculatePelagicDeposition(glob, pltf, iteration)
% Deposit a pre-defined amount of pelagic carbonate in low energy area,
% sediment thickness is uniformily distributed: pelagic production 
%(coccoliths and microforaminifera/foram) is ligth dependent factory! 

pelagicFaciesCode = 11;
pelagicProdThick = glob.pelagicProdRate*glob.deltaT;



 for y=1:glob.ySize
    for x=1:glob.xSize

       if glob.wd(y,x,iteration) > pelagicProdThick && glob.wave(y,x,iteration)...
               <= glob.pelagicMaxWave && pltf.tauCurrent(y,x) <= glob.pelagicMaxCurrent
           
            glob.numberOfLayers(y,x,iteration) = glob.numberOfLayers(y,x,iteration)+1;

            glob.strata(y,x,iteration) = glob.strata(y,x,iteration-1) + pelagicProdThick;

            glob.facies{y,x,iteration}(glob.numberOfLayers(y,x,iteration)) = pelagicFaciesCode;
            glob.thickness{y,x,iteration}(glob.numberOfLayers(y,x,iteration)) = pelagicProdThick;

            glob.wd(y,x,iteration) = glob.wd(y,x,iteration) - pelagicProdThick;
            
            glob.pelagic(y,x,iteration) =   glob.pelagic(y,x,iteration) + 1;

       end
    end
 end 
         
         
end
