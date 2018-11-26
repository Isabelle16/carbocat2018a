%% Define a structure containing all the variables required to be global
clear all;
close all;
clc;

%% Create a destination folder where output will be stored 
% mkdir 'C:\Users\isabel16\Dropbox\gits2s\carbocatS2S\ModelOutput\ModelRun_Example'
cd 'C:\Users\isabel16\Dropbox\CarboCAT2018a\CarboCAT2018a\ModelOutput'

glob.maxIts = 2800;
glob.modelName = '';
glob.dx = 200.0; % grid cell length dimension in meters
glob.xSize = uint16(110);
glob.ySize = uint16(75);

glob.maxFacies = uint8(12);
glob.maxProdFacies = uint8(4);
glob.faciesCount = uint16(zeros(glob.maxIts, (glob.maxFacies + 2))); % two extra, one for change count, one for blob count
glob.faciesColours = 0; % Defined by reading in file in initializeArrays
glob.blobMap = zeros(glob.ySize, glob.xSize, glob.maxIts);

glob.CARules = zeros(10);
glob.CARulesFName = '';
glob.CADtPerIteration = ones(glob.ySize, glob.xSize); % Model time steps required per iteration of the CA for point y x, based on facies and prod rate
glob.CADtCount = zeros(glob.ySize, glob.xSize); % How many timesteps since last iteration at point y x

glob.totalIterations = uint16(1);
glob.deltaT = 0;
glob.initWD = 0;
glob.initBathymetryFName ='';
glob.subsidenceFName = '';
glob.subRate = uint8(1);
glob.subRateMap = zeros(glob.ySize, glob.xSize,glob.totalIterations);

%% Sea level arrays
glob.prodDepthAdjust = ones(glob.ySize, glob.xSize);
glob.SLPeriod1 = 0;
glob.SLAmp1 = 0;
glob.SLPeriod2 = 0;
glob.SLAmp2 = 0;
glob.SL = zeros(glob.maxIts,1);

glob.wd = zeros(glob.ySize, glob.xSize, glob.maxIts);

glob.CADtMin = uint8(10);
glob.CADtMax = uint8(10);
glob.faciesProdAdjust = zeros(glob.ySize, glob.xSize);
glob.initFaciesFName = '';

%% Production rate arrays
glob.prodRate = zeros(glob.maxProdFacies,1); % 1D array with glob.maxProdFacies elements
glob.surfaceLight = zeros(glob.maxProdFacies,1);
glob.extinctionCoeff = zeros(glob.maxProdFacies,1);
glob.saturatingLight = zeros(glob.maxProdFacies,1);
glob.transportProductFacies = zeros(glob.maxProdFacies,1);
glob.prodRateWDCutOff = zeros(glob.maxProdFacies,1); % 1D array with water depths below which production rate is effectively zero

glob.prodScaleMin = zeros(glob.maxProdFacies,1);
glob.prodScaleOptimum = zeros(glob.maxProdFacies,1);
glob.prodScaleMax = zeros(glob.maxProdFacies,1);

%% Bell shape production curves
glob.profCenter = zeros(glob.maxFacies,1);
glob.profWidth = zeros(glob.maxFacies,1);
glob.profSlope = zeros(glob.maxFacies,1);

%% Wave energy routine arrays
glob.wave = zeros(glob.ySize,glob.xSize, glob.maxIts);

%% Sediment redistribution global arrays 
glob.transportFraction = zeros(glob.maxProdFacies,1); % 1D array with glob.maxProdFacies elements

%% Plotting parameters
glob.timeLineCount = uint8(0);
glob.timeLineAge = zeros(10);
glob.faciesThicknessPlotCutoff = 0.01; % Set 1 cm cutoff for plotting production facies on the chronostrat diagram

% added to run the subsidence module
subs.dummy = 0;

%% Process arrays
glob.productionProfile = '' ;
glob.CARoutine = '';
glob.transportationRoutine = '';
glob.siliciclasticsRoutine = '';
glob.concentrationRoutine = '';
glob.soilRoutine = '';
glob.transportFaciesRoutine = '';
glob.refloodingRoutine = '';
glob.seaLevelRoutine = '';
glob.wrapRoutine = '';

%% Pelagic routine glob arrays
glob.pelagic = zeros(glob.ySize,glob.xSize, glob.maxIts);

set(0,'RecursionLimit',1000);

glob = initializeCarboCAT(glob, subs);







