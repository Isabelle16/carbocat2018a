function [glob] = readProcesses(glob, fPName)

%% Read the processes file
fileIn = fopen(fPName);

glob.CARoutine = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); % Read to the end of the line to skip any label text
glob.waveRoutine = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); % Read to the end of the line to skip any label text
glob.siliciclasticsRoutine = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); % Read to the end of the line to skip any label text
glob.concentrationRoutine = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); % Read to the end of the line to skip any label text
glob.soilRoutine = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); % Read to the end of the line to skip any label text
glob.refloodingRoutine = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); % Read to the end of the line to skip any label text
glob.seaLevelRoutine = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); % Read to the end of the line to skip any label text
glob.wrapRoutine = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); % Read to the end of the line to skip any label text
glob.pelagicRoutine = fscanf(fileIn,'%s', 1);
dummyLabel = fgetl(fileIn); % Read to the end of the line to skip any label text

fprintf('CA routine is %s based \n', glob.CARoutine);
fprintf('Wave routine is %s \n', glob.waveRoutine);
fprintf('Siliciclastics are %s \n', glob.siliciclasticsRoutine);
fprintf('Carbonate concentration in water is %s \n', glob.concentrationRoutine);
fprintf('Soild deposition is %s \n', glob.soilRoutine);
fprintf('Reflooded cells are %s \n', glob.refloodingRoutine);
fprintf('Sea-level curve from %s \n', glob.seaLevelRoutine);
fprintf('Model edges are treated as %s \n', glob.wrapRoutine);
fprintf('Pelagic routine is %s \n \n', glob.pelagicRoutine);

end
