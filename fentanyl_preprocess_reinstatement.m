clear
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure2/data/Fentanyl_FB_NAc_summary.mat')
baseline_data = [];
for i = 1:length(summary_FB_NAc_all)
    temp = summary_FB_NAc_all(i).data;
    baseline_mask = arrayfun(@(x) strcmp(x.session, 'Seeking'), temp);
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
% SA96, SA151 lost patency, tested before perfusion
remove_mask = arrayfun(@(x) strcmp(x.animalID, 'SA96')|strcmp(x.animalID, 'SA151'), baseline_data);
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

%% analyze the Seeking sessions
index_last_taking = []

for i = 1:length(index_array)
    index_last_taking(i) = min(index_array{i});
end

data_to_plot = baseline_data(index_last_taking);
population_psth_avg = psth_data(:, index_last_taking);

%% add behavioral data
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Fentanyl_testing_summary_cluster.mat')
cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure5/data')
% SA96, SA151 lost patency, tested before perfusion
remove_mask = arrayfun(@(x) strcmp(x.animalID, 'sa96')|strcmp(x.animalID, 'SA151'), summary_testing);
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
save('Fentanyl_FB_Reinstatement_plot.mat', 'data_to_plot', 'population_psth_avg', 'psth_time', 'summary_testing', 'data_plot')