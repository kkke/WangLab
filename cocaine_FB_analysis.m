%% Step 1: Summarize all data into a single file, alt
% In your summary folder, summarize all data into a single file
clear; close all;clc
% go the data folder
cd("/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure3/Cocaine_FB")
files = dir('*FB_summary.mat');
summary_FB_NAc_all = [];
summary_FB_DS_all  = [];
for j = 1:length(files)
    load(files(j).name)
    % find the autoshaping, PR, and shock session
    % clean the data
    % add raw_time to data
    temp_var = summarydata;
    for i = 1:numel(summarydata)
        if ~isfield(summarydata(i), 'raw_time')
            % Check if 'time' field exists before copying
            if isfield(summarydata(i), 'time')
                temp_var(i).raw_time = summarydata(i).time;
                fprintf('Added raw_time to element %d.\n', i);
            else
                warning('Element %d does not have a "time" field.', i);
            end
        else
            fprintf('Element %d already has raw_time.\n', i);
        end
    end

    % save data with NAc and DS separately

    % Get logical index where regions == 'NAc'
    nacMask = arrayfun(@(x) isfield(x, 'region') && strcmp(x.region, 'NAc'), summarydata);
    % Convert logical mask to indices
    nacIndices = find(nacMask);
    dsIndices  = find(~nacMask);
    summary_FB_NAc_all(j).animalID = summarydata(1).animalID;
    summary_FB_NAc_all(j).data = temp_var(nacIndices);

    summary_FB_DS_all(j).animalID = summarydata(1).animalID;
    summary_FB_DS_all(j).data    = temp_var(dsIndices);
end
cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure3')
save('Cocaine_FB_NAc_summary.mat', 'summary_FB_NAc_all', '-v7.3')
save('Cocaine_FB_DS_summary.mat', 'summary_FB_DS_all', '-v7.3')
%% Step 2: analyze taking or baseline phases
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure3/Cocaine_FB_NAc_summary.mat')
baseline_data = [];
for i = 1:length(summary_FB_NAc_all)
    temp = summary_FB_NAc_all(i).data;
    baseline_mask = arrayfun(@(x) strcmp(x.session, 'Taking'), temp);
    baseline_index = find(baseline_mask);
    baseline_data = [baseline_data, temp(baseline_index)]; % baseline_data represent animal-session pair
end
%% calculate all PSTHs (here for aligned to infusion)
fb = fb_extract_doric;
events = {'infusion', 'leverInsertion', 'leverRetraction'};
k = 1; % choose infusion to align
pre = -10; % time before event, sec
post = 50; % time after event, sec
plot_tf = 0; % plot: 1; not plot: 0
psth_summary =[];
psth_summary_avg =[];
for i = 1:length(baseline_data)
    [psth_time,baseline_data(i).psth_infusion, fig] = fb.psth_fb(baseline_data(i).signal, baseline_data(i).time,baseline_data(i).(events{k}), pre, post, plot_tf, events{k});
    baseline_data(i).psth_infusion_avg = mean(baseline_data(i).psth_infusion, 2, 'omitmissing');
    baseline_data(i).psth_infusion_time = mean(psth_time, 2, 'omitmissing');
end
%% remove mice that lost patency
% SA81, SA110 and SA150 lost patency, tested before perfusion
remove_mask = arrayfun(@(x) strcmp(x.animalID, 'SA81')|strcmp(x.animalID, 'SA110')|strcmp(x.animalID, 'SA150'), baseline_data);
baseline_data = baseline_data(~remove_mask);

% convert stuctures to matrix or cell array
animalID = [];
psth_data = [];
for i = 1:length(baseline_data)
    animalID{i} = baseline_data(i).animalID;
    psth_data(:, i) = baseline_data(i).psth_infusion_avg;
end
psth_time = baseline_data(1).psth_infusion_time;
%% find unique ids
% Loop through each ID and pad the numeric part
new_ids = [];
for i = 1:length(animalID)
    % Extract numeric part
    num_part = regexp(animalID{i}, '\d+', 'match');

    % Convert to number and pad with leading zeros to 5 digits
    padded_num = sprintf('%03d', str2double(num_part{1}));

    % Recombine with 'SA' prefix
    new_ids{i} = ['SA' padded_num];
end
animalID_unique = unique(new_ids);
index_array =[];
for i = 1:length(animalID_unique)
    index_array{i} = find(strcmp(new_ids, animalID_unique{i}));
end

%% analyze the last taking sessions
index_last_taking = []

for i = 1:length(index_array)
    index_last_taking(i) = max(index_array{i});
end

data_to_plot = baseline_data(index_last_taking);
population_psth_avg = psth_data(:, index_last_taking);

%% add behavioral data
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_testing_summary.mat')

% SA81, SA110 and SA150 lost patency, tested before perfusion
remove_mask = arrayfun(@(x) strcmp(x.animalID, 'sa81')|strcmp(x.animalID, 'sa110')|strcmp(x.animalID, 'SA150'), summary_testing);
behavior_testing = summary_testing(~remove_mask);
for i = 1:length(data_to_plot)
    data_to_plot(i).behavior = behavior_testing(i);
    % Original date string in MMDDYY format
    inputDate = data_to_plot(i).date;

    % Parse the string
    month = inputDate(1:2);
    day = inputDate(3:4);
    yearSuffix = inputDate(5:6);

    % Assume all dates are from 2000s (you can adjust logic if needed)
    year = ['20', yearSuffix];

    % Concatenate in YYYYMMDD format
    outputDate = [year, month, day];

    % Display the result
    disp(['Converted date: ', outputDate]);
    index_behavior = find(strcmp(behavior_testing(i).data.date, outputDate));
    data_to_plot(i).behavior.reward_all = behavior_testing(i).data{index_behavior,'Reward'};
    data_to_plot(i).behavior.front_all = behavior_testing(i).data{index_behavior, "Resp-F"} + behavior_testing(i).data{index_behavior, "Resp-Cue-F"};
    data_to_plot(i).behavior.front_cue = behavior_testing(i).data{index_behavior, "Resp-Cue-F"};

    data_to_plot(i).behavior.back_all = behavior_testing(i).data{index_behavior, "Resp-B"} + behavior_testing(i).data{index_behavior, "Resp-Cue-B"};
    data_to_plot(i).behavior.back_cue = behavior_testing(i).data{index_behavior, "Resp-Cue-B"};

end
save('Cocaine_FB_taking_plot.mat', 'data_to_plot', 'population_psth_avg', 'psth_time')
%% plot the population psth
clearvars -except data_to_plot population_psth_avg psth_time
fb = fb_extract_doric;
fb.groupplot_psth_avg(psth_time, population_psth_avg);
set(gcf,'position',[100,100,340,340])


% % response profile
% for i = 1:size(norm_population_psth_avg, 2)
%     figure
%     plot(psth_time, norm_population_psth_avg(:, i))
% end

%% sort the responses based on counts of all infusions of that sessions
trial_counts = arrayfun(@(x) x.behavior.reward_all, data_to_plot);
[B,sort_index] = sort(trial_counts, 'descend');
% normalized to baseline
population_psth_fp_sorted(psth_time, population_psth_avg, sort_index, trial_counts)

%% Single-trial analysis
events = {'infusion', 'leverInsertion', 'leverRetraction'};
k = 1; % choose infusion to align
pre = -10; % time before event, sec
post = 50; % time after event, sec
plot_tf = 0; % plot: 1; not plot: 0
psth_summary =[];
psth_summary_avg =[];
baseline_data = [];
baseline_data_trial01 = []
for i = 1:length(data_to_plot)
    [psth_time,baseline_data(i).psth_infusion, fig] = fb.psth_fb(data_to_plot(i).signal, data_to_plot(i).time,data_to_plot(i).(events{k}), pre, post, plot_tf, events{k});
    baseline_data(i).psth_infusion_avg = mean(baseline_data(i).psth_infusion, 2, 'omitmissing');
    baseline_data(i).psth_infusion_time = mean(psth_time, 2, 'omitmissing');
    baseline_data_trial01(:, i)           = baseline_data(i).psth_infusion(:, 1);
end

% check the 1st trial
%% correlation analysis- sustained- 1st trial
close all
population_psth_fp_sorted(psth_time(:, 1), baseline_data_trial01, sort_index, trial_counts)
figure(1)
clim([-2, 5])
figure(2)
xlim([0, 5])
figure(3)
xlim([0, 3])
%% calculate the fano factor
psth_time = psth_time(:, 1);
baseline_index = find(psth_time> -10 & psth_time < 0);
sustained_index = find(psth_time> 0 & psth_time < 19.5);
fano_value = [];
for i = 1:length(baseline_data)
    basline_value = baseline_data(i).psth_infusion(baseline_index, :);
    sustained_value = baseline_data(i).psth_infusion(sustained_index, :);
    evoked_resp     = mean(sustained_value, 1) -  mean(basline_value);
    fano_value(i) = var(evoked_resp)/mean(evoked_resp);
end
figure;
mdl = fb.correlaiton_analysis_cluster(fano_value, trial_counts, []);
xlim([0, 10])
xlabel('Fano Factor of Sustained DA')
ylim([30, 100])
ylabel('Infusion Counts')
set(gcf,'position',[100,100,340,340])

%% calculate responsive proportion

%% check the video, and find animal's state



































