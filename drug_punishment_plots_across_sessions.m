function [value_phasic, value_sustained] = drug_punishment_plots_across_sessions(data_plot, data_to_plot, population_psth_avg, psth_time)


% close all
fb = fb_extract_doric;

% trial_counts = arrayfun(@(x) x.behavior.reward_all, data_to_plot);

high_taker = data_plot.high_resistance;
low_taker = data_plot.low_resistance;

[B,sort_index] = sort(data_plot.animal_avg_punishment(data_plot.high_resistance), 'descend');
% normalized to baseline
baseline_time = 10;
baseline_index = find(psth_time>-baseline_time & psth_time< 0);
baseline = mean(population_psth_avg(baseline_index,:));
norm_population_psth_avg = population_psth_avg - baseline;
% plot sorted normalized population psth
fb.groupplot_psth_avg(psth_time, norm_population_psth_avg(:, sort_index)); % sorted based one infusion counts
xlim([-5, 20])
ax = findall(gcf, 'Type', 'axes');
% Update y-axis labels
ylim(ax(1), [-1, 3])
ylabel(ax(2), 'Animals');
xlim(ax(2), [-5, 20])
set(gcf,'position',[100,100,250,250])
%% Extract phasic and sustained responses
time_sustained = [1, 19.5];
time_phasic    = [0, 1];
phasic_index = find(psth_time> time_phasic(1) & psth_time< time_phasic(2));
sustained_index = find(psth_time>time_sustained(1) & psth_time< time_sustained(2));
value_sustained = mean(norm_population_psth_avg(sustained_index, :), 1);
value_phasic    = mean(norm_population_psth_avg(phasic_index, :), 1);
%% plot the the time course of DA Dynamics for high and low drug taker
% figure;
% subplot(1, 4, 1)
% popPSTH_cluster(norm_population_psth_avg, psth_time, high_taker, low_taker, [1, 4])
% ylim([-1, 4])
% legend({'', 'High Resistance','', 'Low Resistance'}, 'Box','off')
% 
% subplot(1, 4, 2)
% popPSTH_cluster(norm_population_psth_avg, psth_time, high_taker, low_taker, [1, 4])
% xlim([-2, 5])
% ylim([-1, 4])
% legend({'', 'High Resistance','', 'Low Resistance'}, 'Box','off')
% 
% 
% subplot(1, 4, 3)
% correlation_cluster(value_sustained, data_plot.animal_avg_punishment, high_taker, low_taker, [1, 4])
% xlim([0, 4])
% ylim([0, 120])
% ylabel('Punishment Infusions')
% 
% subplot(1, 4, 4)
% correlation_cluster(value_phasic, data_plot.animal_avg_punishment, high_taker, low_taker, [1, 4])
% xlim([-1.5, 2.5])
% ylim([0, 120])
% xlabel('Phasic DA (Z-Score 0-1s)')
% ylabel('Punishment Infusions')
% 
% set(gcf, 'Position', [10 10 1000 200]);
% 
% %% Bar plots of sustained and phasic responses
% figure 
% subplot(1, 2, 1)
% % phasic DA
% bar_scatter_cluster_punishment_v2(value_phasic, high_taker, low_taker)
% ylim([-1.5, 2.5])
% ylabel('Phasic DA (Z-Score 0-1s)', 'FontSize',14)
% % sustained DA
% subplot(1, 2, 2)
% bar_scatter_cluster_punishment_v2(value_sustained, high_taker, low_taker)
% ylim([0, 4])
% ylabel('Sustained DA (Z-Score 1-19.5s)', 'FontSize',14)
% set(gcf,'position',[0,600,300,200])
% set(gcf, 'Color', 'w')
% %% check response variance: singal to noise ratio
% % baseline_index = find(psth_time> -10 & psth_time < 0);
% % sustained_index = find(psth_time> 0 & psth_time < 19.5);
% SNR_sustained = [];
% SNR_phasic    = [];
% evoked_sustained_trials ={};
% evoked_phasic_trials ={};
% 
% for i = 1:length(data_to_plot)
%     basline_value_trials = data_to_plot(i).psth_infusion(baseline_index, :);
%     sustained_value_trials = data_to_plot(i).psth_infusion(sustained_index, :);
%     phasic_value_trials    = data_to_plot(i).psth_infusion(phasic_index, :);
%     data_to_plot(i).norm_psth_infusion = data_to_plot(i).psth_infusion - mean(basline_value_trials);
%     evoked_sustained_trials{i}     = mean(sustained_value_trials, 1) -  mean(basline_value_trials, 1);
%     evoked_phasic_trials{i}        = mean(phasic_value_trials, 1) -  mean(basline_value_trials, 1);
%     if length(evoked_sustained_trials{i})> 1
%     SNR_sustained(i) = abs(mean(evoked_sustained_trials{i}))/var(evoked_sustained_trials{i});
%     SNR_phasic(i)    = abs(mean(evoked_phasic_trials{i}))/var(evoked_phasic_trials{i});
%     else
%         SNR_sustained(i) = NaN;
%         SNR_phasic(i) = NaN;
%     end
% end
% figure;
% subplot(1, 2, 1)
% correlation_cluster(SNR_sustained, data_plot.animal_avg_punishment, high_taker, low_taker, [1, 4]);
% xlim([0, 10])
% xlabel('SNR of Sustained DA', 'FontSize',14) % use 1/fano_factor to represent SNR
% ylabel('Punishment Infusions')
% 
% ylim([0, 100])
% 
% subplot(1, 2, 2)
% correlation_cluster(SNR_phasic, data_plot.animal_avg_punishment, high_taker, low_taker, [1, 4]);
% xlim([0, 6])
% xlabel('SNR of Phasic DA', 'FontSize',14) % use 1/fano_factor to represent SNR
% ylabel('Punishment Infusions')
% 
% ylim([0, 100])
% set(gcf,'position',[100,100,500,250])
% set(gcf, 'Color', 'w')
% %% Bar plots of SNR of sustained and phasic responses
% figure 
% subplot(1, 2, 1)
% % phasic DA
% bar_scatter_cluster_punishment_v2(SNR_phasic, high_taker, low_taker)
% ylim([0, 6])
% ylabel('SNR of Phasic DA', 'FontSize',14)
% % sustained DA
% subplot(1, 2, 2)
% bar_scatter_cluster_punishment_v2(SNR_sustained, high_taker, low_taker)
% ylim([0, 10])
% ylabel('SNR of Sustained DA', 'FontSize',14)
% set(gcf,'position',[0,600,300,250])
% set(gcf, 'Color', 'w')
% %% plot example mice
% figure;
% tiledlayout("vertical", 'TileSpacing', 'compact', 'Padding', 'compact')
% nexttile
% imagesc(psth_time',[], data_to_plot(22).norm_psth_infusion') % cocaine 11; fentanyl 22
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
% set(gca, 'XTick', [], 'XTickLabel', []);
% box off
% title('High Resistance')
% 
% nexttile
% imagesc(psth_time',[], data_to_plot(14).norm_psth_infusion') % cocaine 19; fentanyl 20
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
% title('Low Resistance')
% set(gcf,'position',[100,100,250,250])
% %% calculate responsive proportion 
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
% bar_scatter_cluster_punishment_v2(resp_ratio(:, 1), high_taker, low_taker);
% ylim([0.4, 1.1])
% ylabel('Response Ratios of Sustained DA')
% subplot(1, 2, 2)
% bar_scatter_cluster_punishment_v2(resp_ratio_phasic(:, 1), high_taker, low_taker);
% ylim([0, 1.1])
% set(gcf,'position',[100,100,300,250])
% ylabel('Response Ratios of Phasic DA')
% %% Correlation between response ratios with infusion counts
% figure;
% subplot(1, 2, 1)
% correlation_cluster(resp_ratio(:, 1), data_plot.animal_avg_punishment, high_taker, low_taker, [1, 4]);
% xlim([0.4, 1.1])
% xlabel('Response Ratios of Sustained DA', 'FontSize',14) % use 1/fano_factor to represent SNR
% ylim([0, 120])
% ylabel('Punishment Infusions')
% 
% subplot(1, 2, 2)
% correlation_cluster(resp_ratio_phasic(:, 1), data_plot.animal_avg_punishment, high_taker, low_taker, [1, 4]);
% xlim([0, 1.1])
% xlabel('Response Ratios of Phasic DA', 'FontSize',14) % use 1/fano_factor to represent SNR
% ylim([0, 120])
% ylabel('Punishment Infusions')
% set(gcf,'position',[100,100,500,250])
% set(gcf, 'Color', 'w')
% %% Response across sessions
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
%     data_to_plot(i).recording(j).time = data_to_plot(i).time(index_range(1,j) : index_range(2,j));
%     data_to_plot(i).recording(j).signal = data_to_plot(i).signal(index_range(1,j) : index_range(2,j));
%     [psth_time,data_to_plot(i).recording(j).psth_infusion, fig] = fb.psth_fb(data_to_plot(i).recording(j).signal, ...
%         data_to_plot(i).recording(j).time, data_to_plot(i).(events{k}), pre, post, plot_tf, events{k});
%     data_to_plot(i).recording(j).psth_infusion_avg = mean(data_to_plot(i).recording(j).psth_infusion, 2, 'omitmissing');
%     data_to_plot(i).recording(j).psth_infusion_time = mean(psth_time, 2, 'omitmissing');
%     data_to_plot(i).recording(j).psth_baseline = mean(data_to_plot(i).recording(j).psth_infusion_avg(baseline_index));
%     data_to_plot(i).recording(j).psth_phasic   = mean(data_to_plot(i).recording(j).psth_infusion_avg(phasic_index));
%     data_to_plot(i).recording(j).psth_sustained = mean(data_to_plot(i).recording(j).psth_infusion_avg(sustained_index));
%     data_to_plot(i).recording(j).psth_evoked_sustained = data_to_plot(i).recording(j).psth_sustained - data_to_plot(i).recording(j).psth_baseline;
%     data_to_plot(i).recording(j).psth_evoked_phasic = data_to_plot(i).recording(j).psth_phasic - data_to_plot(i).recording(j).psth_baseline;
%     data_sustained_sessions(j, i) = data_to_plot(i).recording(j).psth_evoked_sustained;
%     data_phasic_sessions(j, i) = data_to_plot(i).recording(j).psth_evoked_phasic;
%     end
% end
% %% get the sustained response across three sessions
% baf = behavior_analysis_func;
% figure
% subplot(1, 2, 1)
% baf.line_plot_MA_avg(data_sustained_sessions(:,high_taker)', data_sustained_sessions(:,low_taker)')
% xlim([0, 4])
% % Set the x-ticks
% xticks([1 2 3 ]);
% % Set custom x-tick labels
% xticklabels({'1st', '2nd', '3rd'});
% xlabel('Recording Series')
% ylabel('Sustained DA (Z-Score 1-19.5 s)')
% set(gcf,'position',[100,100,340,340])
% legend('off')
% subplot(1, 2, 2)
% baf.line_plot_MA_avg(data_phasic_sessions(:,high_taker)', data_phasic_sessions(:,low_taker)')
% xlim([0, 4])
% % Set the x-ticks
% xticks([1 2 3 ]);
% % Set custom x-tick labels
% xticklabels({'1st', '2nd', '3rd'});
% xlabel('Recording Series')
% ylabel('Phasic DA (Z-Score 1-19.5 s)')
% set(gcf,'position',[100,100,500,250])
% legend({'High Resistance', 'Low Resistance'}, 'Box', 'off')
% %% only check the first serier of recording
% data01 =NaN(length(data_to_plot), 20);
% data01_phasic = NaN(length(data_to_plot), 20);
% for i = 1:length(data_to_plot)
%     temp = data_to_plot(i).recording(1).psth_infusion;
%     baseline_temp = mean(temp(baseline_index,:),1);
%     sustained_temp = mean(temp(sustained_index,:), 1);
%     phasic_temp    = mean(temp(phasic_index,:), 1);
%     evoked_temp     = sustained_temp - baseline_temp;
%     evoked_temp_phasic = phasic_temp - baseline_temp;
%     for j = 1:length(evoked_temp)
%         data01(i,j) = evoked_temp(j);
%         data01_phasic(i,j) = evoked_temp_phasic(j);
%     end
% end
% 
% figure
% subplot(1, 2, 1)
% baf.line_plot_MA_avg(data01(high_taker,1:4), data01(low_taker,1:4))
% xlim([0, 4])
% xlabel('Trials in 1st Series')
% ylabel('Sustained DA')
% set(gcf,'position',[100,100,340,340])
% legend('off')
% 
% 
% subplot(1, 2, 2)
% baf.line_plot_MA_avg(data01_phasic(high_taker,1:4), data01_phasic(low_taker,1:4))
% xlim([0, 4])
% xlabel('Trials in 1st Series')
% ylabel('Phasic DA')
% legend({'High Resistance', 'Low Resistance'}, 'Box', 'off')
% 
% set(gcf,'position',[100,100,500,250])
% %% plot evoked responses across trials
% colors = cbrewer2('div', 'RdYlBu', 4);
% all_trials = NaN(length(data_to_plot), 60);
% all_trials_phasic = NaN(length(data_to_plot), 60);
% figure;
% for i = 1:length(evoked_sustained_trials)
%         all_trials(i, 1:length(evoked_sustained_trials{i})) = evoked_sustained_trials{i};
%         all_trials_phasic(i, 1:length(evoked_phasic_trials{i})) = evoked_phasic_trials{i};
% end
% 
% figure
% subplot(1, 2, 1)
% baf.line_plot_MA_avg(all_trials(high_taker,1:34), all_trials(low_taker,1:15))
% xlim([0, 50])
% xlabel('Trials in all Series')
% ylabel('Sustained DA')
% legend('off')
% 
% set(gcf,'position',[100,100,340,340])
% 
% subplot(1, 2, 2)
% baf.line_plot_MA_avg(all_trials_phasic(high_taker,1:34), all_trials_phasic(low_taker,1:15))
% xlim([0, 50])
% xlabel('Trials in all Series')
% ylabel('Phasic DA')
% legend({'High Resistance', 'Low Resistance'}, 'Box', 'off')
% 
% set(gcf,'position',[100,100,500,250])