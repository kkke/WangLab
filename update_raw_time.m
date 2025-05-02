% update the data for the following mice:
clear
mice = {'SA138', 'SA139', 'SA140', 'SA141', 'SA143', 'SA144';}
i = 6
cd(['H:\Data\FB_data\Dopamine\Fentanyl\', mice{i}])
load('summary.mat')
for j = 1: 7
    date = summarydata(j).date;
    cd(date)
    filename = [mice{i}, '_', date, '_', 'NAc', '_0000']
    series = {'Series0001', 'Series0002','Series0003'};
    raw_time = load_time_doric(filename, series);
    summarydata(j).raw_time = raw_time;
    cd ..
end
%%
cd(['H:\Data\FB_data\Dopamine\Fentanyl\', mice{i}])
load('summary.mat')
j = 8
date = summarydata(j).date;
cd(date)
filename = [mice{i}, '_', date, '_', 'NAc', '_0000']
series = {'Series0001'};
raw_time = load_time_doric(filename, series);
summarydata(j).raw_time = raw_time;
cd ..
%%
cd(['H:\Data\FB_data\Dopamine\Fentanyl\', mice{i}])
load('summary.mat')
j = 9
date = summarydata(j).date;
cd(date)
filename = [mice{i}, '_', date, '_', 'NAc', '_0001']
series = {'Series0001'};
raw_time = load_time_doric(filename, series);
summarydata(j).raw_time = raw_time;
cd ..
%%
cd(['H:\Data\FB_data\Dopamine\Fentanyl\', mice{i}])
load('summary.mat')
j = 10
date = summarydata(j).date;
cd(date)
filename = [mice{i}, '_', date, '_', 'NAc', '_0003']
series = {'Series0001'};
raw_time = load_time_doric(filename, series);
summarydata(j).raw_time = raw_time;
cd ..
