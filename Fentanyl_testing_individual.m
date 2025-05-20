%% Plot the individual difference for fentanyl IVSA testing

%% load the data
clc; clear
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/fentanyl_testing_summary')
%%
taking = 1:3;
punishment = 4:6;
data_plot.animal_avg_taking = mean(data_plot.infusion(taking, :));
data_plot.animal_avg_punishment = mean(data_plot.infusion(punishment, :));
data_plot.n_animal_avg_taking   = data_plot.animal_avg_taking/mean(data_plot.animal_avg_taking);
data_plot.n_animal_avg_punishment  = data_plot.animal_avg_punishment/mean(data_plot.animal_avg_punishment);
data_plot.extinction_score      = data_plot.infusion(6,:)./data_plot.animal_avg_taking;
data_plot.n_extinction_score    = data_plot.extinction_score/mean( data_plot.extinction_score);

%% high vs low drug taker and punishment resistance
threshold = 0.1;
high_taker = find(data_plot.n_animal_avg_taking >1 + threshold);
low_taker  = find(data_plot.n_animal_avg_taking <1 - threshold);
high_resistance = find(data_plot.n_animal_avg_punishment >1 + threshold);
low_resistance  = find(data_plot.n_animal_avg_punishment< 1 - threshold);
data_plot.threshold = threshold;
data_plot.high_taker = high_taker;
data_plot.low_taker = low_taker;
data_plot.high_resistance = high_resistance;
data_plot.low_resistance = low_resistance;
save('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/fentanyl_testing_summary_cluster.mat', ...
    'summary_testing', 'data_plot')
%% plot the individual differences
drug_individual_plots(data_plot)
% figure
% subplot(1, 3, 1)
% hold on
% plot([100, 100], [0, 400], '--k')
% plot([0, 200], [100, 100], '--k')
% xlabel('Fentanyl Infusion (% of Group)')
% ylabel('Fentanyl Infusion With Footshock (% of Group)')
% clusterID = 1:4;
% colors = cbrewer2('div', 'RdYlBu', 4);
% index_01 = find(data_plot.n_animal_avg_taking >1 & data_plot.n_animal_avg_punishment> 1);
% index_02 = find(data_plot.n_animal_avg_taking <1 & data_plot.n_animal_avg_punishment> 1);
% index_03 = find(data_plot.n_animal_avg_taking >1 & data_plot.n_animal_avg_punishment< 1);
% index_04 = find(data_plot.n_animal_avg_taking <1 & data_plot.n_animal_avg_punishment< 1);
% scatter(data_plot.n_animal_avg_taking(index_01) *100, data_plot.n_animal_avg_punishment(index_01) *100, ...
%     'o', 'MarkerFaceColor', colors(1,:), 'MarkerEdgeColor',colors(1,:))
% hold on
% scatter(data_plot.n_animal_avg_taking(index_02)*100, data_plot.n_animal_avg_punishment(index_02)*100, ...
%     'o', 'MarkerFaceColor', colors(2,:), 'MarkerEdgeColor',colors(2,:))
% 
% scatter(data_plot.n_animal_avg_taking(index_03)*100, data_plot.n_animal_avg_punishment(index_03)*100, ...
%     'o', 'MarkerFaceColor', colors(3,:), 'MarkerEdgeColor',colors(3,:))
% scatter(data_plot.n_animal_avg_taking(index_04)*100, data_plot.n_animal_avg_punishment(index_04)*100, ...
%     'o', 'MarkerFaceColor', colors(4,:), 'MarkerEdgeColor',colors(4,:))
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf, 'Color', 'white')
% set(gcf,'position',[100,600,250,250])
% saveas(gcf, 'Fentanyl_testing_Individual_scatterPlots.pdf');
% 
% % plot individual mice
% figure
% rectangle('Position',[3.5, 1, 3, 150], 'FaceColor', [0.8, 0, 0, 0.4], 'EdgeColor', 'none', 'FaceAlpha',0.4);
% hold on
% plot(data_plot.infusion(1:6, index_01), '-o', 'MarkerFaceColor', colors(1,:), 'Color', colors(1,:))
% hold on
% plot(data_plot.infusion(1:6, index_02), '-o', 'MarkerFaceColor', colors(2,:), 'Color', colors(2,:))
% plot(data_plot.infusion(1:6, index_03), '-o', 'MarkerFaceColor', colors(3,:), 'Color', colors(3,:))
% plot(data_plot.infusion(1:6, index_04), '-o', 'MarkerFaceColor', colors(4,:), 'Color', colors(4,:))
% xlim([0, 6.5])
% xlabel('Sessions')
% ylabel('Infusion #')
% set(gcf,'position',[500,600,250,250])
% ylim([0, 200])
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf, 'Color', 'white')
% saveas(gcf, 'Fentanyl_testing_Individual_LinePlots.pdf');
% save('Fentanyl_testing_summary_behavior.mat', 'summary_testing', 'data_plot')
% %% Plot other behavior parameters
% clusterID = zeros(length(summary_testing), 1);
% clusterID(index_01) = 1;
% clusterID(index_02) = 2;
% clusterID(index_03) = 3;
% clusterID(index_04) = 4;
% high_taker = find(clusterID == 1 | clusterID ==3);
% low_taker  = find(clusterID == 2 | clusterID == 4);
% % re-plot scatters 
% figure
% hold on
% plot([100, 100], [0, 400], '--k')
% plot([0, 200], [100, 100], '--k')
% scatter(data_plot.n_animal_avg_taking(high_taker) *100, data_plot.n_animal_avg_punishment(high_taker) *100, ...
%     'o', 'MarkerFaceColor', colors(2,:), 'MarkerEdgeColor',colors(2,:))
% hold on
% scatter(data_plot.n_animal_avg_taking(low_taker)*100, data_plot.n_animal_avg_punishment(low_taker)*100, ...
%     'o', 'MarkerFaceColor', colors(3,:), 'MarkerEdgeColor',colors(3,:))
% box off
% xlabel('Infusions (% Group Mean)')
% ylabel('Infusions w. Footshock (% Mean)')
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf,'position',[100,600,250,250])
% % re-plot line 
% % plot individual mice
% figure
% rectangle('Position',[3.5, 1, 3, 150], 'FaceColor', [0.8, 0, 0, 0.4], 'EdgeColor', 'none', 'FaceAlpha',0.4);
% hold on
% plot(data_plot.infusion(1:6, high_taker), '-o', 'MarkerFaceColor', colors(2,:), 'Color', colors(2,:))
% hold on
% plot(data_plot.infusion(1:6, low_taker), '-o', 'MarkerFaceColor', colors(3,:), 'Color', colors(3,:))
% xlim([0, 6.5])
% xlabel('Sessions')
% ylabel('Infusions')
% set(gcf,'position',[500,600,250,250])
% ylim([0, 200])
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf, 'Color', 'white')
% 
% % lever press
% 
% % infusion
% bar_scatter_cluster(data_plot.animal_avg_taking, high_taker, low_taker, clusterID)
% ylim([0, 150])
% ylabel('Infusions', 'FontSize', 16)
% % infusions with punishment
% bar_scatter_cluster(data_plot.animal_avg_punishment, high_taker, low_taker, clusterID)
% ylim([0, 100])
% ylabel('Infusions with Punishment')
% % futile lever press
% % reaction time
% %%
% %% Plot other behavior parameters
% clusterID = zeros(length(summary_testing), 1);
% clusterID(index_01) = 1;
% clusterID(index_02) = 2;
% clusterID(index_03) = 3;
% clusterID(index_04) = 4;
% high_taker = find(clusterID == 1 | clusterID ==2);
% low_taker  = find(clusterID == 3 | clusterID == 4);
% 
% % re-plot scatters 
% figure
% hold on
% plot([100, 100], [0, 400], '--k')
% plot([0, 200], [100, 100], '--k')
% scatter(data_plot.n_animal_avg_taking(high_taker) *100, data_plot.n_animal_avg_punishment(high_taker) *100, ...
%     'o', 'MarkerFaceColor', colors(1,:), 'MarkerEdgeColor',colors(1,:))
% hold on
% scatter(data_plot.n_animal_avg_taking(low_taker)*100, data_plot.n_animal_avg_punishment(low_taker)*100, ...
%     'o', 'MarkerFaceColor', colors(4,:), 'MarkerEdgeColor',colors(4,:))
% box off
% xlabel('Infusions (% Group Mean)')
% ylabel('Infusions w. Footshock (% Mean)')
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf,'position',[100,600,250,250])
% set(gcf, 'Color', 'white')
% 
% % re-plot line 
% % plot individual mice
% figure
% rectangle('Position',[3.5, 1, 3, 150], 'FaceColor', [0.8, 0, 0, 0.4], 'EdgeColor', 'none', 'FaceAlpha',0.4);
% hold on
% plot(data_plot.infusion(1:6, high_taker), '-o', 'MarkerFaceColor', colors(1,:), 'Color', colors(1,:))
% hold on
% plot(data_plot.infusion(1:6, low_taker), '-o', 'MarkerFaceColor', colors(4,:), 'Color', colors(4,:))
% xlim([0, 6.5])
% xlabel('Sessions')
% ylabel('Infusions')
% set(gcf,'position',[500,600,250,250])
% ylim([0, 200])
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf, 'Color', 'white')
% 
% 
% % lever press
% 
% 
% % infusion
% bar_scatter_cluster_resistance(data_plot.animal_avg_taking, high_taker, low_taker, clusterID)
% ylim([0, 150])
% ylabel('Infusions', 'FontSize', 16)
% xlabel('Resistance')
% set(gcf, 'Color', 'white')
% 
% % infusions with punishment
% bar_scatter_cluster_resistance(data_plot.animal_avg_punishment, high_taker, low_taker, clusterID)
% ylim([0, 100])
% ylabel('Infusions with Punishment')
% xlabel('Resistance')
% set(gcf, 'Color', 'white')
% 
% % futile lever press
% % reaction time
% 
% %% hierarchival 
% data_for_cluster = [data_plot.n_animal_avg_taking;data_plot.n_animal_avg_punishment;data_plot.n_extinction_score]';
% Z = linkage(data_for_cluster, 'ward', 'euclidean');
% clusterN = 4;
% T = cluster(Z,'maxclust',clusterN); % edit by ke, increase the cluster from 9 to 16.
% cutoff =  Z(end-clusterN+2,3);
% figure
% subplot(2, 1, 1)
% [H,tt,outperm] = dendrogram(Z,0,'ColorThreshold',cutoff);
% % for i = 1:size(resp_ap_scaled, 2)
% %     subplot(size(resp_ap_scaled, 2),1,i)
% %     bar(resp_ap_scaled(outperm,i))
% %     hold on
% % end
% data_reorg = data_for_cluster(outperm, :);
% subplot(2, 1, 2)
% imagesc(data_reorg')
% colormap(jet)
% set(gca,'YTick',[1, 2, 3])
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gca, 'YTickLabel', {'Baseline','Punishment', 'Extinction'})
% set(gcf,'position',[1000,100,340,340])
% 
% 
% % plot based on clusters
% clusterID = 1:4;
% colors = cbrewer2('div', 'RdYlBu', 4);
% index_01 = find(T ==3);
% index_02 = find(T ==4);
% index_03 = find(T ==2);
% index_04 = find(T ==1);
% figure
% scatter(data_plot.n_animal_avg_taking(index_01) *100, data_plot.n_animal_avg_punishment(index_01) *100, ...
%     'o', 'MarkerFaceColor', colors(1,:), 'MarkerEdgeColor',colors(1,:))
% hold on
% scatter(data_plot.n_animal_avg_taking(index_02)*100, data_plot.n_animal_avg_punishment(index_02)*100, ...
%     'o', 'MarkerFaceColor', colors(2,:), 'MarkerEdgeColor',colors(2,:))
% 
% scatter(data_plot.n_animal_avg_taking(index_03)*100, data_plot.n_animal_avg_punishment(index_03)*100, ...
%     'o', 'MarkerFaceColor', colors(3,:), 'MarkerEdgeColor',colors(3,:))
% scatter(data_plot.n_animal_avg_taking(index_04)*100, data_plot.n_animal_avg_punishment(index_04)*100, ...
%     'o', 'MarkerFaceColor', colors(4,:), 'MarkerEdgeColor',colors(4,:))
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf, 'Color', 'white')
% set(gcf,'position',[1000,600,340,340])
% hold on
% plot([100, 100], [0, 400], '--k')
% plot([0, 200], [100, 100], '--k')
% xlabel('Fentanyl Infusion (% of Group)')
% ylabel('Fentanyl Infusion With Footshock (% of Group)')
% 
% % plot individual mice
% figure
% rectangle('Position',[3.5, 1, 3, 150], 'FaceColor', [0.8, 0, 0, 0.4], 'EdgeColor', 'none','FaceAlpha', 0.4);
% hold on
% plot(data_plot.infusion(1:6, index_01), '-o', 'MarkerFaceColor', colors(1,:), 'Color', colors(1,:))
% hold on
% plot(data_plot.infusion(1:6, index_02), '-o', 'MarkerFaceColor', colors(2,:), 'Color', colors(2,:))
% plot(data_plot.infusion(1:6, index_03), '-o', 'MarkerFaceColor', colors(3,:), 'Color', colors(3,:))
% plot(data_plot.infusion(1:6, index_04), '-o', 'MarkerFaceColor', colors(4,:), 'Color', colors(4,:))
% xlim([0, 6.5])
% xlabel('Sessions')
% ylabel('Infusion #')
% set(gcf,'position',[100,100,340,340])
% ylim([0, 200])
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf, 'Color', 'white')
% %% save cluster information
% data_plot.cluster_ID = 1:4;
% data_plot.clusters = 1:length(data_plot.infusion);
% data_plot.clusters(index_01) = 1;
% data_plot.clusters(index_02) = 2;
% data_plot.clusters(index_03) = 3;
% data_plot.clusters(index_04) = 4;
% %% plottting
% % Infusion counts baseline
% infusion_counts = [];
% for i = 1:length(data_plot.cluster_ID)
%     infusion_counts{i} = data_plot.animal_avg_taking(data_plot.clusters ==i);
% end
% figure
% baf.barplot_scatter(infusion_counts)
% ylabel('Fentanyl Infusion')
% ylim([0, 150])
% 
% infusion_counts_punishment = [];
% for i = 1:length(data_plot.cluster_ID)
%     infusion_counts_punishment{i} = data_plot.animal_avg_punishment(data_plot.clusters ==i);
% end
% figure
% baf.barplot_scatter(infusion_counts_punishment)
% ylabel('Fentanyl Infusion with Punishment')
% ylim([0, 150])
% 
% extinction_score = [];
% for i = 1:length(data_plot.cluster_ID)
%     extinction_score{i} = data_plot.extinction_score(data_plot.clusters ==i);
% end
% figure
% baf.barplot_scatter(extinction_score)
% ylabel('Extinction Score')
% ylim([0, 3])
% 
% 
