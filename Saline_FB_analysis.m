%% Step 1: Summarize all data into a single file, alt
% In your summary folder, summarize all data into a single file
clear; close all;clc
% go the data folder
cd("/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure2/raw_data/Saline_FB")
files = dir('*FB_summary.mat');
summary_FB_NAc_all = [];
for j = 1:length(files)
    load(files(j).name)
    % find the autoshaping, PR, and shock session
    % clean the data
    % add raw_time to data
    summary_FB_NAc_all(j).animalID = summarydata(1).animalID;
    summary_FB_NAc_all(j).data = summarydata;
end
cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure3/data')
save('Saline_FB_NAc_summary.mat', 'summary_FB_NAc_all', '-v7.3')
%% Step 2: analyze baseline drug taking phases
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure3/data/Saline_FB_NAc_summary.mat')

%%
baseline_data = [];
for i = 1:length(summary_FB_NAc_all)
    temp = summary_FB_NAc_all(i).data;
    baseline_mask = arrayfun(@(x) strcmp(x.session, 'Punishment'), temp);
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


%% convert stuctures to matrix or cell array
animalID = [];
psth_data = [];
for i = 1:length(baseline_data)
    animalID{i} = baseline_data(i).animalID;
    psth_data(:, i) = baseline_data(i).psth_infusion_avg;
end
psth_time = baseline_data(1).psth_infusion_time;
%% find unique ids
new_ids = [];
for i = 1:length(animalID)
    % Extract numeric part
    num_part = regexp(animalID{i}, '\d+', 'match');
    % extract just the alphabet part 
    Alpha_part = regexp(animalID{i}, '[A-Za-z]+', 'match');
    % 
    % % Convert to number and pad with leading zeros to 5 digits
    padded_num = sprintf('%03d', str2double(num_part{1}));
    %
    new_ids{i} = [Alpha_part{1}, padded_num];
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

% index_last_taking = [1, 5, 7, 10]; % this for analyzing punishment responses
data_to_plot = baseline_data(index_last_taking);
population_psth_avg = psth_data(:, index_last_taking);
%% plot the population psth
fb = fb_extract_doric;
fb.groupplot_psth_avg(psth_time, population_psth_avg);
set(gcf,'position',[100,100,340,340])


% % response profile
% for i = 1:size(norm_population_psth_avg, 2)
%     figure
%     plot(psth_time, norm_population_psth_avg(:, i))
% end

%% normalize to baseline activity
% normalized to baseline
baseline_time = 10;
baseline_index = find(psth_time>-baseline_time & psth_time< 0);
baseline = mean(population_psth_avg(baseline_index,:));
norm_population_psth_avg = population_psth_avg - baseline;
% plot sorted normalized population psth
fb.groupplot_psth_avg(psth_time, norm_population_psth_avg); % sorted based one infusion counts
ax = findall(gcf, 'Type', 'axes');
% Update y-axis labels
ylabel(ax(2), 'Animals');
set(gcf,'position',[100,100,250,250])
ylim([-1, 3])
%% extract phasic and sustained responses
time_sustained = [1, 19.5];
time_phasic    = [0, 1];
phasic_index = find(psth_time> time_phasic(1) & psth_time< time_phasic(2));
sustained_index = find(psth_time>time_sustained(1) & psth_time< time_sustained(2));
value_sustained = mean(norm_population_psth_avg(sustained_index, :), 1);
value_phasic    = mean(norm_population_psth_avg(phasic_index, :), 1);
%% plot example mouse
norm_population_psth_avg_update = [];
for i = 1:length(data_to_plot)
    basline_value_trials = data_to_plot(i).psth_infusion(baseline_index, :);
    data_to_plot(i).norm_psth_infusion = data_to_plot(i).psth_infusion - mean(basline_value_trials);
    norm_population_psth_avg_update(:, i) = mean(data_to_plot(i).norm_psth_infusion, 2, "omitmissing");

end

for i = 1:size(norm_population_psth_avg_update, 2)
    plot_example_mouse(psth_time, data_to_plot, i)
    ylim([-1, 2])
    xlim([-10, 50])
    ax = findall(gcf, 'Type', 'axes');
    % Update y-axis labels
    xlim(ax(2), [-10, 50]);
end

%% plot normalized population psth 

figure
fb.groupplot_psth_avg(psth_time, norm_population_psth_avg_update); % sorted based one infusion counts
set(gcf,'position',[100,100,250,200])
