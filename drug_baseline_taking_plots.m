function drug_baseline_taking_plots(data_plot, data_to_plot, population_psth_avg, psth_time)


close all
fb = fb_extract_doric;

% trial_counts = arrayfun(@(x) x.behavior.reward_all, data_to_plot);

high_taker = data_plot.high_taker;
low_taker = data_plot.low_taker;

[B,sort_index] = sort(data_plot.animal_avg_taking, 'descend');
% normalized to baseline
baseline_time = 10;
baseline_index = find(psth_time>-baseline_time & psth_time< 0);
baseline = mean(population_psth_avg(baseline_index,:));
norm_population_psth_avg = population_psth_avg - baseline;
% plot sorted normalized population psth
fb.groupplot_psth_avg(psth_time, norm_population_psth_avg(:, sort_index)); % sorted based one infusion counts
ax = findall(gcf, 'Type', 'axes');
% Update y-axis labels
ylabel(ax(2), 'Animals');
set(gcf,'position',[100,100,250,250])
%% Extract phasic and sustained responses
time_sustained = [1, 19.5];
time_phasic    = [0, 1];
phasic_index = find(psth_time> time_phasic(1) & psth_time< time_phasic(2));
sustained_index = find(psth_time>time_sustained(1) & psth_time< time_sustained(2));
value_sustained = mean(norm_population_psth_avg(sustained_index, :), 1);
value_phasic    = mean(norm_population_psth_avg(phasic_index, :), 1);
%% plot the the time course of DA Dynamics for high and low drug taker
figure;
subplot(1, 4, 1)
popPSTH_cluster(norm_population_psth_avg, psth_time, high_taker, low_taker, [2, 3])

subplot(1, 4, 2)
popPSTH_cluster(norm_population_psth_avg, psth_time, high_taker, low_taker, [2, 3])
xlim([-2, 5])

subplot(1, 4, 3)
correlation_cluster(value_sustained, data_plot.animal_avg_taking, high_taker, low_taker, [2, 3])
ylabel('Baseline Fentanyl Infusions','FontSize',14)
xlabel('Sustained DA (1-19.5s)')

subplot(1, 4, 4)
correlation_cluster(value_phasic, data_plot.animal_avg_taking, high_taker, low_taker, [2, 3])
xlim([-0.5, 1])
xlabel('Phasic DA (0-1s)')
set(gcf, 'Position', [10 10 1000 200]);
ylabel('Baseline Fentanyl Infusions','FontSize',14)

%% Bar plots of sustained and phasic responses
figure 
subplot(1, 2, 1)
% phasic DA
bar_scatter_cluster_v2(value_phasic, high_taker, low_taker)
ylim([-0.5, 1])
ylabel('Phasic DA (0-1s)', 'FontSize',14)
% sustained DA
subplot(1, 2, 2)
bar_scatter_cluster_v2(value_sustained, high_taker, low_taker)
ylim([0, 2])
ylabel('Sustained DA (1-19.5s)', 'FontSize',14)
set(gcf,'position',[0,600,300,200])
set(gcf, 'Color', 'w')
%% check response variance: singal to noise ratio
% baseline_index = find(psth_time> -10 & psth_time < 0);
% sustained_index = find(psth_time> 0 & psth_time < 19.5);
SNR_sustained = [];
SNR_phasic    = [];
evoked_sustained_trials ={};
evoked_phasic_trials ={};

for i = 1:length(data_to_plot)
    basline_value_trials = data_to_plot(i).psth_infusion(baseline_index, :);
    sustained_value_trials = data_to_plot(i).psth_infusion(sustained_index, :);
    phasic_value_trials    = data_to_plot(i).psth_infusion(phasic_index, :);
    data_to_plot(i).norm_psth_infusion = data_to_plot(i).psth_infusion - mean(basline_value_trials);
    evoked_sustained_trials{i}     = mean(sustained_value_trials, 1) -  mean(basline_value_trials, 1);
    evoked_phasic_trials{i}        = mean(phasic_value_trials, 1) -  mean(basline_value_trials, 1);
    SNR_sustained(i) = abs(mean(evoked_sustained_trials{i}))/std(evoked_sustained_trials{i});
    SNR_phasic(i)    = abs(mean(evoked_phasic_trials{i}))/std(evoked_phasic_trials{i});
end
figure;
subplot(1, 2, 1)
correlation_cluster(SNR_sustained, data_plot.animal_avg_taking, high_taker, low_taker, [2, 3]);
xlim([0, 2])
xlabel('SNR of Sustained DA', 'FontSize',14) % use 1/fano_factor to represent SNR
ylim([30, 120])
ylabel('Baseline Fentanyl Infusions','FontSize',14)

subplot(1, 2, 2)
correlation_cluster(SNR_phasic, data_plot.animal_avg_taking, high_taker, low_taker, [2, 3]);
xlim([0, 2])
xlabel('SNR of Phasic DA', 'FontSize',14) % use 1/fano_factor to represent SNR
ylim([30, 120])
ylabel('Baseline Fentanyl Infusions','FontSize',14)
set(gcf,'position',[100,100,500,200])
set(gcf, 'Color', 'w')
%% Bar plots of SNR of sustained and phasic responses
figure 
subplot(1, 2, 1)
% phasic DA
bar_scatter_cluster_v2(SNR_phasic, high_taker, low_taker)
ylim([0, 2])
ylabel('SNR of Phasic DA', 'FontSize',14)
% sustained DA
subplot(1, 2, 2)
bar_scatter_cluster_v2(SNR_sustained, high_taker, low_taker)
ylim([0, 2])
ylabel('SNR of Sustained DA', 'FontSize',14)
set(gcf,'position',[0,600,300,200])
set(gcf, 'Color', 'w')
%% plot example mice
% figure;
% for i = 1:length(data_plot.high_taker)
% plot_example_mouse(psth_time, data_to_plot, data_plot.high_taker(i))
% ylim([-1, 2])
% end
% tiledlayout("vertical", 'TileSpacing', 'compact', 'Padding', 'compact')
% nexttile
% i = 7
% imagesc(psth_time',[], data_to_plot(i).norm_psth_infusion') % cocaine 19; fentanyl 23
% colormap(jet)
% xlabel('')
% ylabel('Trials')
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf,'position',[100,100,340,170])
% clim([-2, 5])
% xlim([-10, 20])
% set(gca, 'XTick', [], 'XTickLabel', []);
% box off
% title('High Drug Taking')
% 
% nexttile
% x = mean(psth_time, 2, 'omitnan');
% y = mean(data_to_plot(i).norm_psth_infusion, 2, 'omitnan');
% e = std(data_to_plot(i).norm_psth_infusion,1, 2, 'omitmissing')/sqrt(size(data_to_plot(i).norm_psth_infusion, 2));
% boundedline(x, y, e, '-k');
% xlabel('Time (s)','FontName', 'Arial')
% ylabel('Z-Score','FontName', 'Arial')
% xlim([-10, 50])
% hold on
% ylim([-0.5, 2.5])
% plot([0, 0], [-1, 1], 'r--')
% plot([19.50, 19.50], [-1, 1], 'k--')
% plot([40.00, 40.00], [-1, 1], 'k--')
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12, 'FontName', 'Arial')
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf,'position',[100,100,250,200])
% xlim([-10, 20])


% imagesc(psth_time',[], data_to_plot(20).norm_psth_infusion')
% colormap(jet)
% xlabel('Time')
% ylabel('Trials')
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf,'position',[100,100,340,170])
% clim([-2, 5])
% title('Low Drug Taking')
% set(gcf,'position',[100,100,250,250])
%% get the baseline activity
% define baseline activity as the activity from trials start (lever
% Insertion) to drug infusion
% % First let's check the DA Dynamic every 10 min
% i = 11
% figure
% for j = 1:3
%     index = find(data_to_plot(i).time>10* 60* (j-1) & data_to_plot(i).time < 10* 60*j);
% 
%     signal_time = data_to_plot(i).signal(index);
%     hold on
%     ecdf(signal_time)
% end






%% calculate responsive proportion 
% p00 = [];
% p01 = [];
% p02 = [];
% resp_p = {};
% p_value_array = [0.05, 0.01, 0.001, 0.0001];
% resp_ratio = [];
% for k = 1:length(p_value_array)
%     for j = 1:length(data_to_plot)
%         p01 = [];
%         p02 = [];
%         resp_type01 = [];
%         resp_type02 = [];
% 
%         psth_data = data_to_plot(j).psth_infusion;
%         baseline_data = psth_data(baseline_index,:);
%         time_window00 = find(psth_time > 0  &  psth_time < 1);
%         time_window01 = find(psth_time > 1  &  psth_time < 10);
%         time_window02 = find(psth_time > 10 & psth_time < 19.5);
%         data_window00 = psth_data(time_window00,:);
%         data_window01 = psth_data(time_window01,:);
%         data_window02 = psth_data(time_window02,:);
%         for i =1: size(psth_data, 2)
%             p00(i) = ranksum(baseline_data(:, i), data_window00(:, i));
%             resp_type00(i) = mean(baseline_data(:,i)) < mean(data_window00(:, i));
%             p01(i) = ranksum(baseline_data(:, i), data_window01(:, i));
%             resp_type01(i) = mean(baseline_data(:,i)) < mean(data_window01(:, i));
%             p02(i) = ranksum(baseline_data(:, i), data_window02(:, i));
%             resp_type02(i) = mean(baseline_data(:, i)) < mean(data_window02(:, i));
% 
%         end
%         resp_p{j} = [p01; p02];
%         resp_type{j} = [resp_type01;resp_type02];
%         resp_ratio(j,k) = length(find(p01< p_value_array(k) & p02<p_value_array(k) ...
%              & resp_type01 == true & resp_type02 == true))/length(p01);
%         resp_ratio_phasic(j,k) = length(find(p00< p_value_array(k) & resp_type00 == true))/length(p00);
%     end
% end
% figure
% subplot(1, 2, 1)
% bar_scatter_cluster_v2(resp_ratio(:, 1), high_taker, low_taker);
% ylim([0, 1.1])
% ylabel('Response Ratios of Sustained DA')
% subplot(1, 2, 2)
% bar_scatter_cluster_v2(resp_ratio_phasic(:, 1), high_taker, low_taker);
% ylim([0, 1.1])
% set(gcf,'position',[100,100,300,250])
% ylabel('Response Ratios of Phasic DA')
%% Correlation between response ratios with infusion counts
% figure;
% subplot(1, 2, 1)
% correlation_cluster(resp_ratio(:, 1), data_plot.animal_avg_taking, high_taker, low_taker, [2, 3]);
% xlim([0, 1.1])
% xlabel('Response Ratios of Sustained DA', 'FontSize',14) % use 1/fano_factor to represent SNR
% ylim([30, 120])
% 
% subplot(1, 2, 2)
% correlation_cluster(resp_ratio_phasic(:, 1), data_plot.animal_avg_taking, high_taker, low_taker, [2, 3]);
% xlim([0, 1.1])
% xlabel('Response Ratios of Phasic DA', 'FontSize',14) % use 1/fano_factor to represent SNR
% ylim([30, 120])
% set(gcf,'position',[100,100,500,250])
% set(gcf, 'Color', 'w')
%% Response across sessions
events = {'infusion', 'leverInsertion', 'leverRetraction'};
k = 1; % choose infusion to align
pre = -10; % time before event, sec
post = 50; % time after event, sec
plot_tf = 0; % plot: 1; not plot: 0
data_sustained_sessions  = [];
for i = 1:length(data_to_plot)
    time = data_to_plot(i).time;
    index = find(diff(time)> 30);
    index_range = [1, index(1)+1, index(2)+1;
        index(1), index(2), length(time)];
    for j = 1:3 % split into three sessions
    data_to_plot(i).recording(j).time = data_to_plot(i).time(index_range(1,j) : index_range(2,j));
    data_to_plot(i).recording(j).signal = data_to_plot(i).signal(index_range(1,j) : index_range(2,j));
    data_to_plot(i).recording(j).infusions = find(data_to_plot(i).infusion > data_to_plot(i).recording(j).time(1) & ...
        data_to_plot(i).infusion < data_to_plot(i).recording(j).time(end));
    [psth_time,data_to_plot(i).recording(j).psth_infusion, fig] = fb.psth_fb(data_to_plot(i).recording(j).signal, ...
        data_to_plot(i).recording(j).time, data_to_plot(i).(events{k}), pre, post, plot_tf, events{k});
    data_to_plot(i).recording(j).psth_infusion_avg = mean(data_to_plot(i).recording(j).psth_infusion, 2, 'omitmissing');
    data_to_plot(i).recording(j).psth_infusion_time = mean(psth_time, 2, 'omitmissing');
    data_to_plot(i).recording(j).psth_baseline = mean(data_to_plot(i).recording(j).psth_infusion_avg(baseline_index));
    data_to_plot(i).recording(j).psth_baseline_trial = mean(data_to_plot(i).recording(j).psth_infusion(baseline_index, :), 1);

    data_to_plot(i).recording(j).psth_phasic   = mean(data_to_plot(i).recording(j).psth_infusion_avg(phasic_index));
    data_to_plot(i).recording(j).psth_sustained = mean(data_to_plot(i).recording(j).psth_infusion_avg(sustained_index));
    data_to_plot(i).recording(j).psth_evoked_sustained = data_to_plot(i).recording(j).psth_sustained - data_to_plot(i).recording(j).psth_baseline;
    data_to_plot(i).recording(j).psth_evoked_phasic = data_to_plot(i).recording(j).psth_phasic - data_to_plot(i).recording(j).psth_baseline;
    data_sustained_sessions(j, i) = data_to_plot(i).recording(j).psth_evoked_sustained;
    data_phasic_sessions(j, i) = data_to_plot(i).recording(j).psth_evoked_phasic;
    data_infusions(j, i)       = length(data_to_plot(i).recording(j).infusions);
    data_baseline(j,i)         = data_to_plot(i).recording(j).psth_baseline;
    end
end
%% add another baseline for tracking the decay of DA
% events = {'infusion', 'leverInsertion', 'leverRetraction'};
% k = 1; % choose infusion to align
% pre = -10; % time before event, sec
% post = 50; % time after event, sec
% plot_tf = 0; % plot: 1; not plot: 0
% data_sustained_sessions  = [];
% for i = 1:length(data_to_plot)
%     time = data_to_plot(i).time;
%     index = find(diff(time)> 30);
%     index_range = [1, index(1)+1, index(2)+1;
%         index(1), index(2), length(time)];
%     for j = 1:3 % split into three sessions
%          [~,psth, fig] = fb.psth_fb(data_to_plot(i).recording(j).signal, ...
%         data_to_plot(i).recording(j).time, data_to_plot(i).(events{k}), pre, post, plot_tf, events{k});
%         data_to_plot(i).recording(j).psth_baseline = mean(psth(baseline_index));
%     end
% end

%%
recordings = [];
for i = 1:3
    for j = 1:length(data_to_plot)
 
        recordings(i).norm_PSTH(:, j) = data_to_plot(j).recording(i).psth_infusion_avg - data_to_plot(j).recording(i).psth_baseline;
        recordings(i).PSTH(:, j) = data_to_plot(j).recording(i).psth_infusion_avg;
    end
end

figure;
subplot(1, 3, 1)
popPSTH_cluster(recordings(1).norm_PSTH, mean(psth_time, 2), high_taker, low_taker, [2, 3])
xlim([-10, 20])
ylim([-0.5, 2])

subplot(1, 3, 2)
popPSTH_cluster(recordings(2).norm_PSTH, mean(psth_time, 2), high_taker, low_taker, [2, 3])
xlim([-10, 20])
ylim([-0.5, 2])


subplot(1, 3, 3)
popPSTH_cluster(recordings(3).norm_PSTH, mean(psth_time, 2), high_taker, low_taker, [2, 3])
set(gcf, 'Position', [10 10 750 200]);
xlim([-10, 20])
ylim([-0.5, 2])
%% get the baseline activity changes across trials and sessions
figure
for k = 1:3
    subplot(1, 3, k)
    for i = 1:length(high_taker)
        scatter(1:length(data_to_plot(high_taker(i)).recording(k).psth_baseline_trial), data_to_plot(high_taker(i)).recording(k).psth_baseline_trial, ...
            'MarkerFaceColor', [0.9922,0.6824, 0.3804], 'MarkerEdgeColor','none');
        hold on
    end

    for i = 1:length(low_taker)
        scatter(1:length(data_to_plot(low_taker(i)).recording(k).psth_baseline_trial), data_to_plot(low_taker(i)).recording(k).psth_baseline_trial, ...
            'MarkerFaceColor', [0.6706, 0.8510, 0.9137], 'MarkerEdgeColor','none');
        hold on
    end
    xlabel('Trials')
    ylabel('Baseline DA (-10 - 0s)')
    ylim([-2, 3])
    box off
    set(gca,'TickDir','out')
    set(gca,'fontsize',12, 'FontName', 'Arial')
    set(gca,'TickLengt', [0.015 0.015]);
    set(gca, 'LineWidth',1)
end

% set(gcf, 'Position', [10 10 250 250]);
% set(gcf,'position',[100,100,340,340])
set(gcf,'position',[100,100,750,200])
set(gcf, 'Color', 'w')
%% get the sustained response across three sessions
baf = behavior_analysis_func;
figure
subplot(1, 2,1)
baf.line_plot_MA_avg(data_sustained_sessions(:,high_taker)', data_sustained_sessions(:,low_taker)')
xlim([0, 4])
ylim([0, 1.5])
% Set the x-ticks
xticks([1 2 3 ]);
% Set custom x-tick labels
xticklabels({'1st', '2nd', '3rd'});
xlabel('Recording Series')
ylabel('Sustained DA (1-19.5 s)')
set(gcf,'position',[100,100,340,340])
legend('off')
subplot(1, 2, 2)
baf.line_plot_MA_avg(data_phasic_sessions(:,high_taker)', data_phasic_sessions(:,low_taker)')
xlim([0, 4])
ylim([0, 1.5])

% Set the x-ticks
xticks([1 2 3 ]);
% Set custom x-tick labels
xticklabels({'1st', '2nd', '3rd'});
xlabel('Recording Series')
ylabel('Phasic DA (0-1 s)')
set(gcf,'position',[100,100,500,200])
legend({'High Drug Taking', 'Low Drug Taking'}, 'Box', 'off')

%% get the infusion counts across recordings
baf = behavior_analysis_func;
figure
subplot(1, 2,1)
baf.line_plot_MA_avg(data_baseline(:,high_taker)', data_baseline(:,low_taker)')
xlim([0, 4])
ylim([-1, 0])
% Set the x-ticks
xticks([1 2 3 ]);
% Set custom x-tick labels
xticklabels({'1st', '2nd', '3rd'});
xlabel('Recording Series')
ylabel('Baseline DA')
set(gcf,'position',[100,100,340,340])
legend('off')
subplot(1, 2, 2)
baf.line_plot_MA_avg(data_infusions(:,high_taker)', data_infusions(:,low_taker)')
xlim([0, 4])
ylim([5, 20])

% Set the x-ticks
xticks([1 2 3 ]);
% Set custom x-tick labels
xticklabels({'1st', '2nd', '3rd'});
xlabel('Recording Series')
ylabel('Infusions')
set(gcf,'position',[100,100,500,200])
legend({'High Drug Taking', 'Low Drug Taking'}, 'Box', 'off')

%% only check the first serier of recording
data01 =NaN(length(data_to_plot), 20);
data01_phasic = NaN(length(data_to_plot), 20)
for i = 1:length(data_to_plot)
    temp = data_to_plot(i).recording(1).psth_infusion;
    baseline_temp = mean(temp(baseline_index,:),1);
    sustained_temp = mean(temp(sustained_index,:), 1);
    phasic_temp    = mean(temp(phasic_index,:), 1);
    evoked_temp     = sustained_temp - baseline_temp;
    evoked_temp_phasic = phasic_temp - baseline_temp;
    for j = 1:length(evoked_temp)
        data01(i,j) = evoked_temp(j);
        data01_phasic(i,j) = evoked_temp_phasic(j);
    end
end

figure
subplot(1, 2, 1)
baf.line_plot_MA_avg(data01(high_taker,1:4), data01(low_taker,1:4))
xlim([0, 4])
xlabel('Trials in 1st Series')
ylabel('Sustained DA')
set(gcf,'position',[100,100,340,340])

subplot(1, 2, 2)
baf.line_plot_MA_avg(data01_phasic(high_taker,1:4), data01_phasic(low_taker,1:4))
xlim([0, 4])
xlabel('Trials in 1st Series')
ylabel('Phasic DA')
set(gcf,'position',[100,100,500,250])
%% plot evoked responses across trials
colors = cbrewer2('div', 'RdYlBu', 4);
all_trials = NaN(length(data_to_plot), 60);
all_trials_phasic = NaN(length(data_to_plot), 60);
figure;
for i = 1:length(evoked_sustained_trials)
        all_trials(i, 1:length(evoked_sustained_trials{i})) = evoked_sustained_trials{i};
        all_trials_phasic(i, 1:length(evoked_phasic_trials{i})) = evoked_phasic_trials{i};
end

figure
subplot(1, 2, 1)
baf.line_plot_MA_avg(all_trials(high_taker,1:34), all_trials(low_taker,1:15))
xlim([0, 50])
xlabel('Trials in all Series')
ylabel('Sustained DA')
set(gcf,'position',[100,100,340,340])

subplot(1, 2, 2)
baf.line_plot_MA_avg(all_trials_phasic(high_taker,1:34), all_trials_phasic(low_taker,1:15))
xlim([0, 50])
xlabel('Trials in all Series')
ylabel('Phasic DA')
set(gcf,'position',[100,100,500,250])