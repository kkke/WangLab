filename = 'SA57_NAc_011923_0001'; 

% Data_Acquired = ExtractDataAcquisition([filename, '.doric');
ProcessedData_filename = {[filename, '_DFF001'], [filename, '_DFF002'], [filename, '_DFF003']};
rawdata_tree = '/DataAcquisition/FPConsole/Signals/';
processed_data_tree = '/DataProcessed/FPConsole/DFFSignals/';
Seriers = {'Series0001', 'Series0002', 'Series0003'};
EventVariables = {'DataAcquisition_FPConsole_Signals_Series0001_DigitalIO', ...
    'DataAcquisition_FPConsole_Signals_Series0002_DigitalIO', ...
    'DataAcquisition_FPConsole_Signals_Series0002_DigitalIO'};

for i = 1:length(Seriers)
    ProcessedData(i).Seriers = Seriers{i};
    ProcessedData(i).rawData.Sig405   = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/AIN02xAOUT01-LockIn/Values']);
    ProcessedData(i).rawData.Sig470   = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/AIN02xAOUT02-LockIn/Values']);
    ProcessedData(i).rawData.time     = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/AIN02xAOUT02-LockIn/Time']);
    ProcessedData(i).processed.signal = h5read([ProcessedData_filename{i}, '.doric'], [processed_data_tree, Seriers{i}, '/AIN02xAOUT02-LockIn/Values']);
    ProcessedData(i).processed.time = h5read([ProcessedData_filename{i}, '.doric'], [processed_data_tree, Seriers{i}, '/AIN02xAOUT02-LockIn/Time']);
    ProcessedData(i).rawDIO.lever     = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/DigitalIO/DIO01']);
    ProcessedData(i).rawDIO.infusion  = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/DigitalIO/DIO02']);
    ProcessedData(i).rawDIO.front     = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/DigitalIO/DIO03']);
    ProcessedData(i).rawDIO.back      = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/DigitalIO/DIO04']);
    ProcessedData(i).rawDIO.time      = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/DigitalIO/Time']);
end
save('SA57_NAc_011923_0001_processed.mat', 'ProcessedData')
%% do some visualization
clearvars -except ProcessedData
i = 3;
figure
h1 = plot(ProcessedData(i).rawDIO.time, ProcessedData(i).rawDIO.lever* -1 + 1)
hold on
h2 = plot(ProcessedData(i).rawDIO.time, ProcessedData(i).rawDIO.infusion* -1 + 1)
h3 = plot(ProcessedData(i).rawDIO.time, ProcessedData(i).rawDIO.front*-1)
h4 = plot(ProcessedData(i).rawDIO.time, ProcessedData(i).rawDIO.back*-1)
h5 = plot(ProcessedData(i).processed.time, ProcessedData(i).processed.signal)
legend({'Lever', 'Infusion', 'Front', 'Back', 'DA'})

%% get the timestamps of each event.

