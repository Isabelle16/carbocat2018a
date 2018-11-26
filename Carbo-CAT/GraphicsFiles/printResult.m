function [iter] = printResult(glob,subs, iteration, iter)

glob.figureNum = ''; 
glob.plotFromFile = false;

ffTimeStep = [glob.totalIterations]; % iterations vector 
% ffTimeStep = [subs.endingTime(1) subs.maxT];

% set cross-sections position
xPosition = [35]; 
yPosition = [55];

kk = 1;
if iter <= length(ffTimeStep)  
    if iteration == ffTimeStep(iter)        
     glob.figureNum = 100 + iter;
     
     plot3DModel(glob,subs,iteration,yPosition,xPosition); % plot 3D view
     
        for jPos = 1:size(xPosition,2)
            xPos = xPosition(jPos);
            glob.figureNum = 200 + iter;
            plotCrossSectionX_dynamic(glob,xPos,iteration,kk);
            glob.figureNum = 300 + iter;
            plotChronostratSectionX_dynamic(glob,xPos,iteration,kk); 
        end
           
        for iPos = 1:size(yPosition,2)
            yPos = yPosition(iPos); 
            glob.figureNum = 400 + iter;
            plotCrossSectionY_dynamic(glob, yPos, iteration,kk);
            glob.figureNum = 500 +iter;
            plotChronostratSectionY_dynamic(glob, yPos, iteration,kk)
        end
     glob.figureNum = 600 + iter;
     eustaticCurve_dynamic(glob, iteration)
     iter = iter +1;
    end
end

if iteration == glob.totalIterations
    %% Save arrays and generate petrel file
    kk = 1;

    save('globalArrays.mat','-struct','glob','-v7.3')
    % save('subsArrays.mat','-struct','subs','-v7.3')

    generatePetrelFiles(glob,kk) 
end

end
