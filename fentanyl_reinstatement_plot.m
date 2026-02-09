%% plot the population psth
clear; clc; close all
% load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_testing_summary.mat')
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure5/data/Fentanyl_FB_Reinstatement_plot.mat')

%% plot the data
extinction_score = data_plot.extinction_score;
reinstatement_score = data_plot.infusion(7,:)./data_plot.animal_avg_taking;
extinction_threshold = 0.1;
reinstatement_threshold = 0.1;
index = find(extinction_score< extinction_threshold & reinstatement_score > reinstatement_threshold);

data_to_plot = data_to_plot(index);
population_psth_avg = population_psth_avg(:, index);
reinstatement_score = reinstatement_score(index);
reinstatement_counts = data_plot.infusion(7,index);
%%
close all
fb = fb_extract_doric;

% trial_counts = arrayfun(@(x) x.behavior.reward_all, data_to_plot);



[B,sort_index] = sort(reinstatement_counts, 'descend');
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

%%
time_sustained = [1, 19.5];
time_phasic    = [0, 1];
phasic_index = find(psth_time> time_phasic(1) & psth_time< time_phasic(2));
sustained_index = find(psth_time>time_sustained(1) & psth_time< time_sustained(2));
value_sustained = mean(norm_population_psth_avg(sustained_index, :), 1);
value_phasic    = mean(norm_population_psth_avg(phasic_index, :), 1);
figure;
mdl = fitlm(value_phasic, reinstatement_counts)
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


%%
for i = 1:length(data_to_plot)
    basline_value_trials = data_to_plot(i).psth_infusion(baseline_index, :);
    sustained_value_trials = data_to_plot(i).psth_infusion(sustained_index, :);
    phasic_value_trials    = data_to_plot(i).psth_infusion(phasic_index, :);
    data_to_plot(i).norm_psth_infusion = data_to_plot(i).psth_infusion - mean(basline_value_trials);
end

figure;
tiledlayout("vertical", 'TileSpacing', 'compact', 'Padding', 'compact')
for i = 1:length(data_to_plot)
    nexttile
    imagesc(psth_time',[], data_to_plot(sort_index(i)).norm_psth_infusion')
    colormap(jet)
    xlabel('')
    ylabel('Trials')
    box off
    set(gca,'TickDir','out')
    set(gca,'fontsize',12)
    set(gca,'TickLengt', [0.015 0.015]);
    set(gca, 'LineWidth',1)
    clim([-2, 5])
    set(gca, 'XTick', [], 'XTickLabel', []);
    box off

end
xticks([-10, 0, 10, 20, 30, 40, 50])
xticklabels([-10, 0, 10, 20, 30, 40, 50])
xlabel('Time (s)')
set(gcf,'position',[100,100,340,1020])



% figure
% mdl = fitlm(value_sustained, reinstatement_score)
% hold on
% h1 = plot(mdl);
% % format the correlation graph
% h1(1).Color = [0.8, 0.8, 0.8];
% h1(1).Marker = 'o';
% h1(1).MarkerFaceColor = [0.8,0.8,0.8];
% h1(2).Color = [0, 0, 0];
% h1(2).LineWidth = 1;
% h1(3).Color = [0,0,0];
% title('')
% % 
% hold on
% colors = cbrewer2('div', 'RdYlBu', 4);
% scatter(value_sustained(high_taker), counts(high_taker), 'MarkerFaceColor',colors(colorIndex(1),:), 'MarkerEdgeColor',colors(colorIndex(1),:))
% scatter(value_sustained(low_taker), counts(low_taker), 'MarkerFaceColor',colors(colorIndex(2),:), 'MarkerEdgeColor',colors(colorIndex(2),:))
% ylim([30, 120])
% xlim([0, 1.6])
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf,'position',[100,100,250,250])
% legend('off')
% xlabel('Sustained DA (Z-Score 1-19.5 s)', 'FontSize', 14)
% ylabel('Baseline Cocaine Infusions', 'FontSize', 14)

%%
figure(1)
ax = findall(gcf, 'Type', 'axes');
ylim(ax(1), [-1, 2])

figure(2)
ax = findall(gcf, 'Type', 'axes');
% Update axis range
ylim(ax(4), [-1, 3])
ylim(ax(3), [-1, 3])
ylim(ax(2), [0, 100])
xlim(ax(2), [-0.4, 2.2]);
xticks(ax(2), [-0.4, 0, 1, 2.0])
xlim(ax(1), [-2, 4]);
xticks(ax(1), [-2, 0, 2, 4])
ylim(ax(1), [0, 100])

figure(3)
ax = findall(gcf, 'Type', 'axes');
% Update axis range
ylim(ax(2), [-2, 4]);
yticks(ax(2), [-2, 0, 2, 4])

ylim(ax(1), [-0.4, 2.2]);
yticks(ax(1), [-0.4, 0, 1, 2.0])


figure(4)
ax = findall(gcf, 'Type', 'axes');
% Update axis range
xlim(ax(2), [0, 5]);
xlim(ax(1), [0, 5]);

figure(5)
ax = findall(gcf, 'Type', 'axes');
% Update axis range
ylim(ax(2), [0, 5]);
ylim(ax(1), [0, 5]);

