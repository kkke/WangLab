function population_psth_fp_punishment_sorted(psth_time, population_psth_avg, sort_index, trial_counts, clusterID)
fb = fb_extract_doric;
baseline_time = 10;
baseline_index = find(psth_time>-baseline_time & psth_time< 0);
baseline = mean(population_psth_avg(baseline_index,:));
norm_population_psth_avg = population_psth_avg - baseline;
% plot sorted normalized population psth
fb.groupplot_psth_avg(psth_time, norm_population_psth_avg(:, sort_index)); % sorted based one infusion counts
% Get all axes in the current figure
ax = findall(gcf, 'Type', 'axes');
% If you created the subplots in order (subplot(2,1,1) first), then:
first_subplot = ax(2);  % axes are returned in reverse order in older MATLAB versions
% Set y-axis limits or other properties
set(first_subplot, 'YLim', [-1 4]);  % 
% label or other axis properties
ylabel(first_subplot, 'Z-Score');
set(gcf,'position',[100,100,340,340])
%% correlation analysis- sustained 
time_sustained = [0, 19.5];
time_phasic    = [0, 1];
phasic_index = find(psth_time>0& psth_time< 1);
sustained_index = find(psth_time>0 & psth_time< 19.5);
value_sustained = mean(norm_population_psth_avg(sustained_index, :), 1);
value_phasic    = mean(norm_population_psth_avg(phasic_index, :), 1);
mdl = fb.correlaiton_analysis_cluster(value_sustained, trial_counts, clusterID);
xlim([0, 4])
xlabel('Sustained DA (Z-Score 0-19.5 s)')
ylim([0, 150])
ylabel('Infusions')
set(gcf,'position',[100,100,340,340])
%% correlation analysis- phasic 
mdl = fb.correlaiton_analysis_cluster(value_phasic, trial_counts, clusterID);
xlim([-1, 3])
xlabel('Phasic DA (Z-Score 0-1 s)')
ylim([0, 150])
ylabel('Infusions')
set(gcf,'position',[100,100,340,340])
%% get a bar graphing showing high drug taker vs low drug taker
high_taker = find(clusterID == 1 | clusterID ==2);
low_taker = find(clusterID == 3 | clusterID == 4); 
%% plottting
figure;
colors = cbrewer2('div', 'RdYlBu', 4);
e1 = std(norm_population_psth_avg(:, high_taker),1, 2, 'omitmissing')/sqrt(size(norm_population_psth_avg(:, high_taker), 2));
h1 = boundedline(psth_time, mean(norm_population_psth_avg(:, high_taker),2), e1, 'cmap', colors(1,:));
hold on
e2 = std(norm_population_psth_avg(:, low_taker),1, 2, 'omitmissing')/sqrt(size(norm_population_psth_avg(:, low_taker), 2));
h2 = boundedline(psth_time, mean(norm_population_psth_avg(:, low_taker),2), e2, 'cmap', colors(4,:));
xlabel('Time (s)')
ylabel('Z-Score')
xlim([-10, 50])
hold on
ylim([-0.5, 4])
plot([0, 0], [-1, 1], 'r--')
plot([19.50, 19.50], [-1, 1], '--')
plot([40.00, 40.00], [-1, 1], '--')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,340,340])
legend([h1, h2], {'High Punishment Resistance', 'Low Punishment Resistance'})
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
            b.CData(1,:) = colors(1, :);
        case 2
            b.CData(1,:) = colors(4, :);
    end
    b.FaceAlpha = 0.4;
    hold on
    errorbar(i, mean_value, sem_value,'k.', 'LineWidth', 1, 'CapSize',10)
end

scatter(1 + 0.3* (rand(size(value_sustained(high_taker)))-0.5), value_sustained(high_taker), 'MarkerEdgeColor','none', 'MarkerFaceColor',colors(1,:))
scatter(2 + 0.3* (rand(size(value_sustained(low_taker)))-0.5), value_sustained(low_taker), 'MarkerEdgeColor','none', 'MarkerFaceColor',colors(4,:))


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
ylabel('Sustained DA (Z-Score 0-19.5 s)')
ylim([0, 4])

[h,p] = ttest2(data_bar{1}, data_bar{2})
%% phasic 
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
            b.CData(1,:) = colors(1, :);
        case 2
            b.CData(1,:) = colors(4, :);
    end
    b.FaceAlpha = 0.4;
    hold on
    errorbar(i, mean_value, sem_value,'k.', 'LineWidth', 1, 'CapSize',10)
end

scatter(1 + 0.3* (rand(size(value_phasic(high_taker)))-0.5), value_phasic(high_taker), 'MarkerEdgeColor','none', 'MarkerFaceColor',colors(1,:))
scatter(2 + 0.3* (rand(size(value_phasic(low_taker)))-0.5), value_phasic(low_taker), 'MarkerEdgeColor','none', 'MarkerFaceColor',colors(4,:))


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
ylabel('Phasic DA (Z-Score 0-1 s)')
ylim([-1, 3])
[h,p] = ttest2(data_bar{1}, data_bar{2})
%% 
phasic_negative = find(value_phasic < 0);
phasic_positive = find(value_phasic > 0);

negative_low = intersect(low_taker, phasic_negative);
positive_low = intersect(low_taker, phasic_positive);
figure;
colors = cbrewer2('div', 'RdYlBu', 4);
e1 = std(norm_population_psth_avg(:, negative_low),1, 2, 'omitmissing')/sqrt(size(norm_population_psth_avg(:, negative_low), 2));
h1 = boundedline(psth_time, mean(norm_population_psth_avg(:, negative_low),2), e1, 'cmap', colors(3,:));
hold on
e2 = std(norm_population_psth_avg(:, positive_low),1, 2, 'omitmissing')/sqrt(size(norm_population_psth_avg(:, positive_low), 2));
h2 = boundedline(psth_time, mean(norm_population_psth_avg(:, positive_low),2), e2, 'cmap', colors(4,:));

e3 = std(norm_population_psth_avg(:, high_taker),1, 2, 'omitmissing')/sqrt(size(norm_population_psth_avg(:, high_taker), 2));
h3 = boundedline(psth_time, mean(norm_population_psth_avg(:, high_taker),2), e2, 'cmap', colors(1,:));
xlabel('Time (s)')
ylabel('Z-Score')
xlim([-2, 5])
hold on
ylim([-2, 2])
plot([0, 0], [-1, 1], 'r--')
plot([19.50, 19.50], [-1, 1], '--')
plot([40.00, 40.00], [-1, 1], '--')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,340,340])
legend([h1, h2, h3], {'Low Resistance N', 'Low Resistance P', 'High Resistance'})




