function PetrelFacies(strataUpscaled,faciesUpscaled,filenameFacies)
fileID=fopen(filenameFacies,'w+');
[ySize,xSize,iterations] = size(strataUpscaled);


fprintf(fileID, 'FACIES\n'); 
fprintf(fileID, '-- Property name in Matlab : Facies\n'); 



%loop through all the cells
    %starting from the top max y, min x
    for k=iterations-1:-1:1
        

        for j=1:ySize

            for i=1:xSize
        fprintf(fileID, '\n  %.3f ',faciesUpscaled(j,i,k)); 
            end


        end
    
    end
    
    
fprintf(fileID, ' /\n');
fprintf(fileID, 'ECHO');
fclose(fileID);

end