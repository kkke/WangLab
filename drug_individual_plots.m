function drug_individual_plots(data_plot)
high_taker = data_plot.high_taker;
low_taker  = data_plot.low_taker;
high_resistance = data_plot.high_resistance;
low_resistance = data_plot.low_resistance;
subplot(1, 3, 1)
% mdl = fitlm(data_plot.animal_avg_taking, data_plot.animal_avg_punishment)
hold on
% h1 = plot(mdl);
ylim([0, 120])
xlim([0, 120])
% axis square
xlabel('Baseline Infusions')
ylabel('Punishment Infusions')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
scatter(data_plot.animal_avg_taking, data_plot.animal_avg_punishment, 'MarkerFaceColor',[0,0, 0], 'MarkerFaceAlpha',0.2, 'MarkerEdgeColor','none')
legend('off')
subplot(1, 3, 2)
colors = cbrewer2('div', 'RdYlBu', 4);
hold on
plot([100, 100], [0, 400], '--k')
plot([0, 200], [100, 100], '--k')
scatter(data_plot.n_animal_avg_taking*100, data_plot.n_animal_avg_punishment*100, 'MarkerFaceColor',[0,0, 0], 'MarkerFaceAlpha',0.2, 'MarkerEdgeColor','none')
% mdl = fitlm(data_plot.n_animal_avg_taking*100, data_plot.n_animal_avg_punishment * 100)
hold on
scatter(data_plot.n_animal_avg_taking(high_taker) *100, data_plot.n_animal_avg_punishment(high_taker) *100, ...
    'o', 'MarkerFaceColor', colors(2,:), 'MarkerEdgeColor',colors(2,:));
scatter(data_plot.n_animal_avg_taking(low_taker) *100, data_plot.n_animal_avg_punishment(low_taker) *100, ...
    'o', 'MarkerFaceColor', colors(3,:), 'MarkerEdgeColor',colors(3,:))
% h1 = plot(mdl);
legend('off')
xlabel('Baseline Infusions (% of Mean)')
ylabel('Punishment Infusions (% of Mean)')
% axis square
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf, 'Color', 'white')

%%
% plot individual mice
subplot(1, 3, 3)
rectangle('Position',[3.5, 1, 3, 150], 'FaceColor', [0, 0, 0], 'EdgeColor', 'none', 'FaceAlpha',0.1);
hold on
plot(data_plot.infusion(1:6, high_taker), '-o', 'MarkerFaceColor', colors(2,:), 'Color', colors(2,:))
hold on
plot(data_plot.infusion(1:6, low_taker), '-o', 'MarkerFaceColor', colors(3,:), 'Color', colors(3,:))

xlim([0, 6.5])
xlabel('Testing Sessions')
ylabel('Infusions')
set(gcf,'position',[500,600,750,250])
ylim([0, 200])
% axis square
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf, 'Color', 'white')
% save('Cocaine_testing_summary.mat', 'summary_testing', 'data_plot')

%% Plot other behavior parameters
% clusterID = zeros(length(summary_testing), 1);
% clusterID(index_01) = 1;
% clusterID(index_02) = 2;
% clusterID(index_03) = 3;
% clusterID(index_04) = 4;
% high_taker = find(clusterID == 1 | clusterID ==3);
% low_taker  = find(clusterID == 2 | clusterID == 4);

% lever press

figure
% infusion
subplot(1, 2, 1)
bar_scatter_cluster_v2(data_plot.animal_avg_taking, high_taker, low_taker)
ylim([0, 150])
ylabel('Baseline Infusions')
% infusions with punishment
subplot(1, 2, 2)
bar_scatter_cluster_v2(data_plot.animal_avg_punishment, high_taker, low_taker)
ylim([0, 100])
ylabel('Punishment Infusions')
set(gcf, 'Color', 'white')
set(gcf,'position',[500,600,300,250])

% futile lever press
% reaction time
%%
%% Plot High vs low punishment resistance
% clusterID = zeros(length(summary_testing), 1);
% clusterID(index_01) = 1;
% clusterID(index_02) = 2;
% clusterID(index_03) = 3;
% clusterID(index_04) = 4;
% high_taker = find(clusterID == 1 | clusterID ==2);
% low_taker  = find(clusterID == 3 | clusterID == 4);
figure
subplot(1, 2, 1)
colors = cbrewer2('div', 'RdYlBu', 4);
hold on
plot([100, 100], [0, 400], '--k')
plot([0, 200], [100, 100], '--k')
scatter(data_plot.n_animal_avg_taking*100, data_plot.n_animal_avg_punishment*100, 'MarkerFaceColor',[0,0, 0], 'MarkerFaceAlpha',0.2, 'MarkerEdgeColor','none')
% mdl = fitlm(data_plot.n_animal_avg_taking*100, data_plot.n_animal_avg_punishment * 100)
hold on
scatter(data_plot.n_animal_avg_taking(high_resistance) *100, data_plot.n_animal_avg_punishment(high_resistance) *100, ...
    'o', 'MarkerFaceColor', colors(1,:), 'MarkerEdgeColor',colors(2,:));
scatter(data_plot.n_animal_avg_taking(low_resistance) *100, data_plot.n_animal_avg_punishment(low_resistance) *100, ...
    'o', 'MarkerFaceColor', colors(4,:), 'MarkerEdgeColor',colors(3,:))
% h1 = plot(mdl);
legend('off')
xlabel('Baseline Infusions (% of Mean)')
ylabel('Punishment Infusions (% of Mean)')
% axis square
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf, 'Color', 'white')

% plot individual mice
subplot(1, 2, 2)
rectangle('Position',[3.5, 1, 3, 150], 'FaceColor', [0, 0, 0], 'EdgeColor', 'none', 'FaceAlpha',0.1);
hold on
plot(data_plot.infusion(1:6, high_resistance), '-o', 'MarkerFaceColor', colors(1,:), 'Color', colors(1,:))
hold on
plot(data_plot.infusion(1:6, low_resistance), '-o', 'MarkerFaceColor', colors(4,:), 'Color', colors(4,:))

xlim([0, 6.5])
xlabel('Testing Sessions')
ylabel('Infusions')
set(gcf,'position',[500,600,500,250])
ylim([0, 200])
% axis square
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf, 'Color', 'white')

% infusion
figure
subplot(1, 2, 1)
bar_scatter_cluster_resistance_v2(data_plot.animal_avg_taking, high_resistance, low_resistance)
ylim([0, 150])
ylabel('Baseline Infusions')
% infusions with punishment
subplot(1, 2, 2)
bar_scatter_cluster_resistance_v2(data_plot.animal_avg_punishment, high_resistance, low_resistance)
ylim([0, 100])
ylabel('Punishment Infusions')
set(gcf,'position',[500,600,300,250])