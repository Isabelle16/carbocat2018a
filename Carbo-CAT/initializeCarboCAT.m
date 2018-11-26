function glob = initializeCarboCAT(glob, subs)
iteration = 0;

%% Run ExtSubs and display subsidence map
subs.paramsSubsFName ='params/faultParamsTest.txt';
subs = readFaults (subs);
subs = runSubsidence(subs);

% % initializeSubsGraphicsNew(glob, subs);
% makeSubsVideo(glob,subs,iteration)
% plotSubsidenceHistory(glob,subs,iteration);

%% Initialize model parameters and arrays
glob.paramsFName = 'params/paramsFile.txt';

glob = initializeModelParams(glob, glob.paramsFName);
glob = readProcesses(glob,glob.processFName);
glob = initializeLobyteParameters (glob);
glob = initializeSiliciclasticParams(glob, glob.silicFName);
glob = initializeArrays(glob);
glob = initializeWaveRoutineParams(glob);
glob = initializeCrossPltfTransParams(glob);


initializeGraphics(glob, graph, subs,1);  % plot initial parameters
% plotMultipleEustaticCurves(glob, iteration)
% initializeSubsGraphicsNew(glob,subs, iteration);
% plotEustaticCurve_vertical( glob, iteration)


%% Run Carbo-CAT
[glob] = runCAModel(glob, subs);
    
end