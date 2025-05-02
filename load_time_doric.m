function raw_time = load_time_doric(filename, series)
raw_time = [];
data_str = '/DataAcquisition/FPConsole/Signals/';

raw_time = [];
for i = 1:length(series)
    raw_time  = [raw_time; h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Time'])];
end


