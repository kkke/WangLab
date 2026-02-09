%% Step 1: Summarize all data into a single file, alt
% In your summary folder, summarize all data into a single file
% clear; close all;clc
% % go the data folder
% cd("/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure3/Cocaine_FB")
% files = dir('*FB_summary.mat');
% summary_FB_NAc_all = [];
% summary_FB_DS_all  = [];
% for j = 1:length(files)
%     load(files(j).name)
%     % find the autoshaping, PR, and shock session
%     % clean the data
%     % add raw_time to data
%     temp_var = summarydata;
%     for i = 1:numel(summarydata)
%         if ~isfield(summarydata(i), 'raw_time')
%             % Check if 'time' field exists before copying
%             if isfield(summarydata(i), 'time')
%                 temp_var(i).raw_time = summarydata(i).time;
%                 fprintf('Added raw_time to element %d.\n', i);
%             else
%                 warning('Element %d does not have a "time" field.', i);
%             end
%         else
%             fprintf('Element %d already has raw_time.\n', i);
%         end
%     end

    % save data with NAc and DS separately

%     % Get logical index where regions == 'NAc'
%     nacMask = arrayfun(@(x) isfield(x, 'region') && strcmp(x.region, 'NAc'), summarydata);
%     % Convert logical mask to indices
%     nacIndices = find(nacMask);
%     dsIndices  = find(~nacMask);
%     summary_FB_NAc_all(j).animalID = summarydata(1).animalID;
%     summary_FB_NAc_all(j).data = temp_var(nacIndices);
% 
%     summary_FB_DS_all(j).animalID = summarydata(1).animalID;
%     summary_FB_DS_all(j).data    = temp_var(dsIndices);
% end
% cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure3')
% save('Cocaine_FB_NAc_summary.mat', 'summary_FB_NAc_all', '-v7.3')
% save('Cocaine_FB_DS_summary.mat', 'summary_FB_DS_all', '-v7.3')
%% Step 2: analyze punishment phases
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure3/data/Cocaine_FB_NAc_summary.mat')
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

%% analyze the first Punishment sessions
index_last_taking = []

for i = 1:length(index_array)
    index_last_taking(i) = min(index_array{i});
end

data_to_plot = baseline_data(index_last_taking);
population_psth_avg = psth_data(:, index_last_taking);

%% add behavioral data
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_testing_summary_cluster.mat')

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
cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure4')
save('Cocaine_FB_Punishment_plot_122825.mat', 'data_to_plot', 'population_psth_avg', 'psth_time', 'summary_testing', 'data_plot')
%% plot the population psth
clear;clc;close all
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_testing_summary.mat')
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure4/Cocaine_FB_Punishment_plot.mat')
fb = fb_extract_doric;
fb.groupplot_psth_avg(psth_time, population_psth_avg);
set(gcf,'position',[100,100,340,340])


% % response profile
% for i = 1:size(norm_population_psth_avg, 2)
%     figure
%     plot(psth_time, norm_population_psth_avg(:, i))
% end
%% data cleaning: SA74 has artifacts during 1:30:00 to 2:00:00
i = 2
time = data_to_plot(i).time;
index = find(diff(time)>0.009);
remove_start = index(2);
remove_stop  = index(end);

data_to_plot(i).time(remove_start:remove_stop) =[];
data_to_plot(i).signal(remove_start:remove_stop) =[];

%% sort the responses based on counts of all infusions of that sessions
trial_counts = arrayfun(@(x) x.behavior.reward_all, data_to_plot);
index_01 = find(data_plot.n_animal_avg_taking >1 & data_plot.n_animal_avg_punishment> 1);
index_02 = find(data_plot.n_animal_avg_taking <1 & data_plot.n_animal_avg_punishment> 1);
index_03 = find(data_plot.n_animal_avg_taking >1 & data_plot.n_animal_avg_punishment< 1);
index_04 = find(data_plot.n_animal_avg_taking <1 & data_plot.n_animal_avg_punishment< 1);
clusterID = zeros(length(data_to_plot));
clusterID(index_01) = 1;
clusterID(index_02) = 2;
clusterID(index_03) = 3;
clusterID(index_04) = 4;

[B,sort_index] = sort(trial_counts, 'descend');
% normalized to baseline
population_psth_fp_punishment_sorted(psth_time, population_psth_avg, sort_index, trial_counts, clusterID)

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
population_psth_fp_punishment_sorted(psth_time(:, 1), baseline_data_trial01, sort_index, trial_counts, clusterID)
figure(1)
clim([-2, 5])
figure(2)
xlim([0, 6])
figure(3)
xlim([0, 3])
figure(4)
ylim([-0.5,6])
figure(5)
ylim([0, 6])
%% calculate the fano factor
psth_time = psth_time(:, 1);
baseline_index = find(psth_time> -10 & psth_time < 0);
sustained_index = find(psth_time> 0 & psth_time < 19.5);
fano_value = [];
for i = 1:length(baseline_data)
    basline_value = baseline_data(i).psth_infusion(baseline_index, :);
    sustained_value = baseline_data(i).psth_infusion(sustained_index, :);
    evoked_resp     = mean(sustained_value, 1) -  mean(basline_value);
    if length(evoked_resp) ==1
        fano_value(i) = NaN;
    else
    fano_value(i) = var(evoked_resp)/mean(evoked_resp);

    end
end
figure;
mdl = fb.correlaiton_analysis_cluster(fano_value, trial_counts, clusterID);
xlim([0, 3])
xlabel('Fano Factor of Sustained DA')
ylim([0, 150])
ylabel('Infusion Counts')
set(gcf,'position',[100,100,340,340])

%% get a bar graphing showing high drug taker vs low drug taker
high_taker = find(clusterID == 1 | clusterID ==2);
low_taker = find(clusterID == 3 | clusterID == 4);
%% plottting
baf = behavior_analysis_func;
figure
colors = cbrewer2('div', 'RdYlBu', 4);
data_bar = {fano_value(high_taker),fano_value(low_taker) };
for i = 1:length(data_bar)
    mean_value = mean(data_bar{i}, 'omitmissing');
    sem_value = std(data_bar{i}, 'omitmissing')./sqrt(length(data_bar{i}));
    b = bar(i, mean_value);
    b.FaceColor = 'flat';
    switch i
        case 1
            b.CData(1,:) = colors(1, :);

        case 2
            b.CData(1,:) = colors(4, :);
    end
    b.FaceAlpha = 0.4;
    hold on
    errorbar(i, mean_value, sem_value,'k.', 'LineWidth', 1, 'CapSize',10)
end

scatter(1 + 0.3* (rand(size(fano_value(high_taker)))-0.5), fano_value(high_taker), 'MarkerEdgeColor','none', 'MarkerFaceColor',colors(1,:))
scatter(2 + 0.3* (rand(size(fano_value(low_taker)))-0.5), fano_value(low_taker), 'MarkerEdgeColor','none', 'MarkerFaceColor',colors(4,:))

xlabel('Resistance');
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,200,340])
set(gca,'XTick',[1, 2, 3, 4])
xticks([1, 2])
xticklabels({'High', 'Low'})
ylabel('Fano Factor of Sustained DA')
ylim([0, 3])

% Example cell array with two groups of d
[h,p ]= ttest2(data_bar{1}, data_bar{2})
%% plot example
figure;
imagesc(psth_time',[], data_to_plot(11).psth_infusion')
colormap(jet)
xlabel('Time')
ylabel('Trials')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,340,170])
clim([-2, 5])

figure
imagesc(psth_time',[], data_to_plot(19).psth_infusion')
colormap(jet)
xlabel('Time')
ylabel('Trials')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,340,170])
clim([-2, 5])

%% calculate responsive proportion
p01 = [];
p02 = [];
resp_p = {};
p_value_array = [0.05, 0.01, 0.001, 0.0001];
resp_ratio = [];
for k = 1:length(p_value_array)
    for j = 1:length(data_to_plot)
        p01 = [];
        p02 = [];
        resp_type01 = [];
        resp_type02 = [];

        psth_data = data_to_plot(j).psth_infusion;
        baseline_data = psth_data(baseline_index,:);

        time_window01 = find(psth_time>0  &  psth_time < 10);
        time_window02 = find(psth_time > 10 & psth_time < 19.5);
        data_window01 = psth_data(time_window01,:);
        data_window02 = psth_data(time_window02,:);
        for i =1: size(psth_data, 2)
            p01(i) = ranksum(baseline_data(:, i), data_window01(:, i));
            resp_type01(i) = mean(baseline_data(:,i)) < mean(data_window01(:, i));
            p02(i) = ranksum(baseline_data(:, i), data_window02(:, i));
            resp_type02(i) = mean(baseline_data(:, i)) < mean(data_window02(:, i));

        end
        resp_p{j} = [p01; p02];
        resp_type{j} = [resp_type01;resp_type02];
        resp_ratio(j,k) = length(find(p01< p_value_array(k) & p02<p_value_array(k) ...
             & resp_type01 == true & resp_type02 == true))/length(p01);
    end
end

bar_scatter_cluster_resistance(resp_ratio(:, 1), high_taker, low_taker, clusterID)
set(gcf,'position',[100,100,200,340])
ylim([0.4, 1.1])
[h,p] = ranksum(resp_ratio(high_taker), resp_ratio(low_taker))
ylabel('Proportion of Trials with Significant Response')
%%
figure;
mdl = fb.correlaiton_analysis_cluster(resp_ratio(:,1), trial_counts, clusterID);
ylim([0,150])
xlim([0.4, 1.2])
ylabel('Infusions with Punishment')
xlabel('Proportion of Trials (p < 0.05)')
set(gcf,'position',[100,100,340,340])

%% analyze signal to noise ratio
figure
baf.line_plot_MA_avg(resp_ratio(high_taker,:), resp_ratio(low_taker,:))
xlim([0, 5])
ylim([0, 1])
% Set the x-ticks
xticks([1 2 3 4]);

% Set custom x-tick labels
xticklabels({'0.05', '0.01', '0.001', '0.0001'});
xlabel('P-Value Criterion')
ylabel('Proportion of Trials with Significant Response')
set(gcf,'position',[100,100,340,340])

%% Perform two-way ANOVA with un-balanced design
factor = zeros(size(resp_ratio));
factor(high_taker,:) = 1;
factor(low_taker,:)  = 2;
factor1 = factor(:);
factor(:, 1) = 1;
factor(:, 2) = 2;
factor(:, 3) = 3;
factor(:, 4) = 4;
factor2 = factor(:);
% Grouping variables
group = {factor1, factor2};
%
data = resp_ratio(:);
% Run two-way ANOVA (Type III SS automatically for unbalanced designs)
[p, tbl, stats] = anovan(data, group, ...
    'model', 'interaction', ...
    'varnames', {'Drug Taker', 'P-Value Criterion'});

% Optional: post-hoc Tukey's HSD tests
disp('Post-hoc comparisons:');
multcompare(stats, 'Dimension', 1); % for Drug Taker
multcompare(stats, 'Dimension', 2); % for P-Value Criterion
%% check responses changed across trials: divied into three sessions
events = {'infusion', 'leverInsertion', 'leverRetraction'};
k = 1; % choose infusion to align
pre = -10; % time before event, sec
post = 50; % time after event, sec
plot_tf = 0; % plot: 1; not plot: 0
data_sustained_sessions  = [];
for i = 1:length(data_to_plot)
    time = data_to_plot(i).time;
    index = find(diff(time)> 1);
    index_range = [1, index(1)+1, index(2)+1;
        index(1), index(2), length(time)];
    for j = 1:3 % split into three sessions
    data_to_plot(i).recording(j).time = data_to_plot(i).time(index_range(1,j) : index_range(2,j));
    data_to_plot(i).recording(j).signal = data_to_plot(i).signal(index_range(1,j) : index_range(2,j));
    [psth_time,data_to_plot(i).recording(j).psth_infusion, fig] = fb.psth_fb(data_to_plot(i).recording(j).signal, ...
        data_to_plot(i).recording(j).time, data_to_plot(i).(events{k}), pre, post, plot_tf, events{k});
    data_to_plot(i).recording(j).psth_infusion_avg = mean(data_to_plot(i).recording(j).psth_infusion, 2, 'omitmissing');
    data_to_plot(i).recording(j).psth_infusion_time = mean(psth_time, 2, 'omitmissing');
    data_to_plot(i).recording(j).psth_baseline = mean(data_to_plot(i).recording(j).psth_infusion_avg(baseline_index));
    data_to_plot(i).recording(j).psth_sustained = mean(data_to_plot(i).recording(j).psth_infusion_avg(sustained_index));
    data_to_plot(i).recording(j).psth_evoked_sustained = data_to_plot(i).recording(j).psth_sustained - data_to_plot(i).recording(j).psth_baseline;
    data_sustained_sessions(j, i) = data_to_plot(i).recording(j).psth_evoked_sustained;
    end

end
%% get the sustained response across three sessions
figure
baf.line_plot_MA_avg(data_sustained_sessions(:,high_taker)', data_sustained_sessions(:,low_taker)')
xlim([0, 4])
% Set the x-ticks
xticks([1 2 3 ]);
% Set custom x-tick labels
xticklabels({'1st', '2nd', '3rd'});
xlabel('Recording Series')
ylabel('Sustained DA')
set(gcf,'position',[100,100,340,340])

%% Perform two-way ANOVA with un-balanced design
factor = zeros(size(data_sustained_sessions));
factor(:, high_taker) = 1;
factor(:, low_taker)  = 2;
factor1 = factor(:);
factor(1,:) = 1;
factor(2,:) = 2;
factor(3,:) = 3;
factor2 = factor(:);
% Grouping variables
group = {factor1, factor2};
%
data = data_sustained_sessions(:);
% Run two-way ANOVA (Type III SS automatically for unbalanced designs)
[p, tbl, stats] = anovan(data, group, ...
    'model', 'interaction', ...
    'varnames', {'Drug Taker', 'Series'});

% Optional: post-hoc Tukey's HSD tests
disp('Post-hoc comparisons:');
[results,~,~,gnames]= multcompare(stats, 'Dimension', [1,2]); % for Drug Taker
tbl = array2table(results,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl.("Group A")=gnames(tbl.("Group A"));
tbl.("Group B")=gnames(tbl.("Group B"))
% multcompare(stats, 'Dimension', 2); % for P-Value Criterion
%% only check the first serier of recording
data01 =NaN(length(data_to_plot), 20);
for i = 1:length(data_to_plot)
    temp = data_to_plot(i).recording(1).psth_infusion;
    baseline_temp = mean(temp(baseline_index,:),1);
    sustained_temp = mean(temp(sustained_index,:), 1);
    evoked_temp = sustained_temp - baseline_temp;
    for j = 1:length(evoked_temp)
        data01(i,j) = evoked_temp(j);
    end
end

figure
baf.line_plot_MA_avg(data01(high_taker,:), data01(low_taker,:))
xlim([0, 10])
xlabel('Trials in 1st Series')
ylabel('Sustained DA')
set(gcf,'position',[100,100,340,340])


%% Let's check animals with recordings on multiple days
clear
cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure3/summary_FB_NAc_all.mat')
baseline_data = [];
for i = 1:length(summary_FB_NAc_all)
    temp = summary_FB_NAc_all(i).data;
    baseline_mask = arrayfun(@(x) strcmp(x.session, 'Taking'), temp);
    baseline_index = find(baseline_mask);
    baseline_data = [baseline_data, temp(baseline_index)]; % baseline_data represent animal-session pair
end
%% example
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
    baseline_index = find(baseline_data(i).psth_infusion_time> -10 & baseline_data(i).psth_infusion_time < 0);
    sustained_index = find(baseline_data(i).psth_infusion_time> 0 & baseline_data(i).psth_infusion_time < 19.5);
    baseline_data(i).basline_value = baseline_data(i).psth_infusion_avg(baseline_index, :);
    baseline_data(i).sustained_value = baseline_data(i).psth_infusion_avg(sustained_index, :);
    baseline_data(i).evoked_resp     = mean(baseline_data(i).sustained_value, 1) -  mean(baseline_data(i).basline_value);
end

%%























