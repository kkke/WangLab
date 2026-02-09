%% analyze the last punishment sessions
index_last_taking = []

for i = 1:length(index_array)
    index_last_taking(i) = max(index_array{i});
end

data_to_plot = baseline_data(index_last_taking);
population_psth_avg = psth_data(:, index_last_taking);
%%
%% add behavioral data
% load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Fentanyl_testing_summary_cluster.mat')
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_testing_summary_cluster.mat')

% cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure4/data')
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
%% get the mice for high resistance:
data_to_plot_low_first = data_to_plot(data_plot.low_resistance);
population_psth_avg_low_first = population_psth_avg(:, data_plot.low_resistance);

%% get the mice for first high resistance:
data_to_plot_high_first = data_to_plot(data_plot.high_resistance);
population_psth_avg_high_first = population_psth_avg(:, data_plot.high_resistance);
%% mask to delete the same data
a = [1:6, 8, 10, 15];
data_to_plot_low_first(a) = [];
population_psth_avg_low_first(:, a) = [];
data_plot.low_resistance(a)=[];
%%
save('Cocaine_FB_Punishment_first_low_plot.mat', 'data_to_plot_low_first', 'population_psth_avg_low_first', ...
    'psth_time', 'summary_testing', 'data_plot')
%%
data_to_plot_high_first(a) = [];
population_psth_avg_high_first(:, a) = [];
data_plot.high_resistance(a)=[];
save('Cocaine_FB_Punishment_first_high_plot.mat', 'data_to_plot_high_first', 'population_psth_avg_high_first', ...
    'psth_time', 'summary_testing', 'data_plot')
%%
save('Cocaine_FB_Punishment_last_high_plot.mat', 'data_to_plot_high', 'population_psth_avg_high', ...
    'psth_time', 'summary_testing', 'data_plot')
%%
data_to_plot_high_first = data_to_plot(data_plot.high_resistance);
population_psth_avg_high_first = population_psth_avg(:, data_plot.high_resistance);


%%
cd(['/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure4/'])
save('Fentanyl_FB_Punishment_first_high_plot.mat', 'data_to_plot_high_first', 'population_psth_avg_high_first', 'psth_time', 'summary_testing', 'data_plot')

%%
[phasic_first, sustained_first] = drug_punishment_plots_across_sessions(data_plot, data_to_plot_high_first, population_psth_avg_high_first, psth_time);

[phasic, sustained] = drug_punishment_plots_across_sessions(data_plot, data_to_plot_high, population_psth_avg_high, psth_time);

%% Let's do comparision between sessions

[phasic_first, sustained_first] = drug_punishment_plots_across_sessions(data_plot, data_to_plot_low_first, population_psth_avg_low_first, psth_time);

[phasic, sustained] = drug_punishment_plots_across_sessions(data_plot, data_to_plot_low, population_psth_avg_low, psth_time);

%% plot the change of phasic and sustained response
figure
baf = behavior_analysis_func;
subplot(1, 2, 1)
phasic_changes = [phasic_first', phasic'];
plot(phasic_changes', '-o', 'Color', 0.8* [1, 1, 1], 'LineWidth', 1, 'MarkerFaceColor','w')
hold on
baf.line_plot_errorbar(phasic_changes, 'r', 'Phasic DA (0-1s)')
xlim([0, 3])
ylim([0, 3])
xticks([1, 2])
xticklabels({'1st', 'Last'})
xlabel('Punishment Sessions')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf, 'Color', 'white')
[h, p] = ttest(phasic_first, phasic);

subplot(1, 2, 2)
sustained_changes = [sustained_first', sustained'];
plot(sustained_changes', '-o', 'Color', 0.8* [1, 1, 1], 'LineWidth', 1, 'MarkerFaceColor','w')
hold on
baf.line_plot_errorbar(sustained_changes, 'r', 'Sustained DA (1-19.5s)')
xlim([0, 3])
ylim([-0.5, 1.5])
xticks([1, 2])
xticklabels({'1st', 'Last'})
xlabel('Punishment')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[500,100,400,200])
set(gcf, 'Color', 'white')
[h, p] = ttest(sustained_first, sustained);


figure
changes = [phasic_first - sustained_first; phasic - sustained];
plot(changes, '-o', 'Color', 0.8* [1, 1, 1], 'LineWidth', 1, 'MarkerFaceColor','w')
hold on
baf.line_plot_errorbar(changes', 'r', 'phasic - sustained ')
xlim([0, 3])
ylim([-1, 3])
xticks([1, 2])
xticklabels({'1st', 'Last'})
xlabel('Punishment')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[500,100,200,200])
set(gcf, 'Color', 'white')
[h, p] = ttest(changes(1,:), changes(2,:))
%% change of behavior vs change of responses
reward = zeros(length(data_to_plot_high), 2);
for i = 1:length(data_to_plot_high)
    reward(i, 1) = data_to_plot_high_first(i).behavior.reward_all;
    reward(i, 2) = data_to_plot_high(i).behavior.reward_all;
end    

figure
% mdl = fitlm(diff(reward,1, 2), phasic_changes(:,2) - phasic_changes(:,1))

mdl = fitlm(diff(reward,1, 2), changes(2,:) - changes(1,:))
hold on
h1 = plot(mdl);
% format the correlation graph
h1(1).Color = [0.8, 0.8, 0.8];
h1(1).Marker = 'o';
h1(1).MarkerFaceColor = [0.8,0.8,0.8];
h1(2).Color = [0, 0, 0];
h1(2).LineWidth = 1;
h1(3).Color = [0,0,0];
title('')
set(gcf,'position',[500,100,200,200])

%%
