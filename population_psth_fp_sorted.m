function population_psth_fp_sorted(psth_time, population_psth_avg, sort_index, trial_counts, clusterID)
fb = fb_extract_doric;
baseline_time = 10;
baseline_index = find(psth_time>-baseline_time & psth_time< 0);
baseline = mean(population_psth_avg(baseline_index,:));
norm_population_psth_avg = population_psth_avg - baseline;
% plot sorted normalized population psth
fb.groupplot_psth_avg(psth_time, norm_population_psth_avg(:, sort_index)); % sorted based one infusion counts
set(gcf,'position',[100,100,340,340])
%% correlation analysis- sustained
time_sustained = [0, 19.5];
time_phasic    = [0, 1];
phasic_index = find(psth_time>0& psth_time< 1);
sustained_index = find(psth_time>0 & psth_time< 19.5);
value_sustained = mean(norm_population_psth_avg(sustained_index, :), 1);
value_phasic    = mean(norm_population_psth_avg(phasic_index, :), 1);
mdl = fb.correlaiton_analysis_cluster(value_sustained, trial_counts, clusterID);
xlim([0, 1.5])
xlabel('Average Sustained DA')
ylim([30, 100])
ylabel('Infusion Counts')
set(gcf,'position',[100,100,340,340])
%% correlation analysis- phasic
mdl = fb.correlaiton_analysis_cluster(value_phasic, trial_counts, clusterID);
xlim([-1, 1])
xlabel('Average Phasic DA')
ylim([30, 100])
ylabel('Infusion Counts')
set(gcf,'position',[100,100,340,340])
%% get a bar graphing showing high drug taker vs low drug taker
high_taker = find(clusterID == 1 | clusterID ==3);
low_taker = find(clusterID == 2 | clusterID == 4);
%% plottting
figure;
colors = cbrewer2('div', 'RdYlBu', 4);
e1 = std(norm_population_psth_avg(:, high_taker),1, 2, 'omitmissing')/sqrt(size(norm_population_psth_avg(:, high_taker), 2));
h1 = boundedline(psth_time, mean(norm_population_psth_avg(:, high_taker),2), e1, 'cmap', colors(2,:), 'LineWidth',1.5);
hold on
e2 = std(norm_population_psth_avg(:, low_taker),1, 2, 'omitmissing')/sqrt(size(norm_population_psth_avg(:, low_taker), 2));
h2 = boundedline(psth_time, mean(norm_population_psth_avg(:, low_taker),2), e2, 'cmap', colors(3,:), 'LineWidth',1.5);
xlim([-10, 50])
hold on
ylim([-0.5, 2])
plot([0, 0], [-1, 1.5], '--', 'Color', [1, 0, 0], 'LineWidth',2)
plot([19.50, 19.50], [-1, 1.5], '--', 'Color', [0.8, 0.8, 0.8],'LineWidth',2)
plot([40.00, 40.00], [-1, 1.5], '--','Color', [0.8, 0.8, 0.8], 'LineWidth',2)
box off
set(gca,'TickDir','out')
set(gca,'fontsize',14, 'FontName', 'Arial')
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1.5)
% set(gcf, 'Units', 'centimeters');
set(gcf, 'Position', [10 10 340 340]);
% set(gcf,'position',[100,100,340,340])
legend([h1, h2], {'High Drug Taker', 'Low Drug Taker'}, 'Box','off')
set(gcf, 'Color', 'w')
xlabel('Time (s)', 'FontSize',18, 'FontName', 'Arial')
ylabel('Z-Score', 'FontSize', 18, 'FontName', 'Arial')
print(gcf, 'Population_PSTH_High_low.png', '-dpng', '-r300');  % 300 DPI

%%
xlim([-2, 5])
%%
baf = behavior_analysis_func;
figure
colors = cbrewer2('div', 'RdYlBu', 4);
data_bar = {value_sustained(high_taker),value_sustained(low_taker) };
for i = 1:length(data_bar)
    mean_value = mean(data_bar{i});
    sem_value = std(data_bar{i})./sqrt(length(data_bar{i}));
    b = bar(i, mean_value);
    b.FaceColor = 'flat';
    switch i
        case 1
            b.CData(1,:) = colors(2, :);
            b.FaceAlpha = 0.4

        case 2
            b.CData(1,:) = colors(3, :);
            b.FaceAlpha = 0.4


    end
    hold on
    errorbar(i, mean_value, sem_value,'k.', 'LineWidth', 1, 'CapSize',10)
end
scatter(1 + 0.3* (rand(size(value_sustained(high_taker)))-0.5), value_sustained(high_taker),  'MarkerEdgeColor', 'none', 'MarkerFaceColor',colors(2,:))
scatter(2 + 0.3* (rand(size(value_sustained(low_taker)))-0.5), value_sustained(low_taker),  'MarkerEdgeColor', 'none', 'MarkerFaceColor',colors(3,:))

box off
set(gca,'TickDir','out')
set(gca,'fontsize',14,'FontName', 'Arial')
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1.5)
set(gcf,'position',[100,100,200,340])
set(gca,'XTick',[1, 2, 3, 4])
xticks([1 2 3]);
xticklabels({'High', 'Low', ''});
xlabel('Drug Taking', 'FontSize',18, 'FontName', 'Arial')
ylabel('Sustained DA (Z-Score 0-19.5s)', 'FontSize', 18, 'FontName', 'Arial')
ylim([0, 1.5])
print(gcf, 'Bar_graph_sustained_High_low.png', '-dpng', '-r300');  % 300 DPI
[h,p] = ttest2(data_bar{1}, data_bar{2})
%%
baf = behavior_analysis_func;
figure
colors = cbrewer2('div', 'RdYlBu', 4);
data_bar = {value_phasic(high_taker),value_phasic(low_taker) };
for i = 1:length(data_bar)
    mean_value = mean(data_bar{i});
    sem_value = std(data_bar{i})./sqrt(length(data_bar{i}));
    b = bar(i, mean_value);
    b.FaceColor = 'flat';
    switch i
        case 1
            b.CData(1,:) = colors(2, :);
            b.FaceAlpha = 0.4

        case 2
            b.CData(1,:) = colors(3, :);
            b.FaceAlpha = 0.4


    end
    hold on
    errorbar(i, mean_value, sem_value,'k.', 'LineWidth', 1, 'CapSize',10)
end
scatter(1 + 0.3* (rand(size(value_phasic(high_taker)))-0.5), value_phasic(high_taker),  'MarkerEdgeColor', 'none', 'MarkerFaceColor',colors(2,:))
scatter(2 + 0.3* (rand(size(value_phasic(low_taker)))-0.5), value_phasic(low_taker),  'MarkerEdgeColor', 'none', 'MarkerFaceColor',colors(3,:))

box off
set(gca,'TickDir','out')
set(gca,'fontsize',14,'FontName', 'Arial')
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1.5)
set(gcf,'position',[100,100,200,340])
set(gca,'XTick',[1, 2, 3, 4])
xticks([1 2 3]);
xticklabels({'High', 'Low', ''});
xlabel('Drug Taking', 'FontSize',18, 'FontName', 'Arial')
ylabel('Phasic DA (Z-Score 0-1s)', 'FontSize', 18, 'FontName', 'Arial')
ylim([0, 1.5])
print(gcf, 'Bar_graph_Phasic_High_low.png', '-dpng', '-r300');  % 300 DPI
[h,p] = ttest2(data_bar{1}, data_bar{2})