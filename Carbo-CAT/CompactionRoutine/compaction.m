function glob = compaction(glob,iteration)

%compact after the whole model run
reduction=0.5;
%porosity reduction with depth:
for i=1:iteration
    for y=1:glob.ySize
        for x=1:glob.xSize
            totalL=glob.numberOfLayers(y,x,i);
            if totalL>0
                for sublayer=1:totalL;
                    if glob.facies{y,x,i}(sublayer)>1 && glob.facies{y,x,i}(sublayer)<9
                        %loop through all the layers and correct according to the
                        %compaction of the lower layer
                        removeThick=glob.thickness{y,x,i}(sublayer)*reduction;
                        if removeThick>0
                            glob.thickness{y,x,i}(sublayer)=glob.thickness{y,x,i}(sublayer)-removeThick;
                            for layer=i:iteration
                                glob.strata(y,x,layer)=glob.strata(y,x,layer)-removeThick;
                            end
                        end
                    end
                end
            end
        end
    end
end
end

% phi=70*exp(-z/263); %from
%
% phi=47.8*exp(-z/3990);
