% In your summary folder, summarize all data into a single file
clear; close all;clc
% go the data folder
cd('C:\Users\KeChen\MIT Dropbox\Ke Chen\Wang Lab\Manuscripts\DA_Cocaine_Fentanyl\Figures\Figure1\Data\Fentanyl_ThreeHoursSessions')

files = dir('*ThreeHoursSessions.mat');
% contruct a summary dictionary containing all data 
summary_testing = [];
for i = 1:length(files)
    load(files(i).name)
% find the autoshaping, PR, and shock session
    training_protocol = summarydata.training;
    recording_index = find(contains(training_protocol, 'Ephys'));
    shock_session     = find(contains(training_protocol, 'shock'));
    summary_testing(i).animalID          = summarydata.subject{1};
    summary_testing(i).data              = summarydata;
    summary_testing(i).recording_index   = recording_index;
    summary_testing(i).shock_session     = shock_session;

end
cd('C:\Users\KeChen\MIT Dropbox\Ke Chen\Wang Lab\Manuscripts\DA_Cocaine_Fentanyl\Figures\Figure1\Data')
save('Fentanyl_testing_summary.mat', 'summary_testing')
%% plot the lever press and infusion counts
clear; close all; clc;
baf = behavior_analysis_func;
cd('C:\Users\KeChen\MIT Dropbox\Ke Chen\Wang Lab\Manuscripts\DA_Cocaine_Fentanyl\Figures\Figure1\Data\')
load('C:\Users\KeChen\MIT Dropbox\Ke Chen\Wang Lab\Manuscripts\DA_Cocaine_Fentanyl\Figures\Figure1\Data\Fentanyl_testing_summary.mat')
% plot the data drug infusion;
data_plot = [];
% only plot the 3 sessions of baseline, 3 sessions of punishments and 1
% sessions of Saline
for i = 1:length(summary_testing)
    shock_session = summary_testing(i).shock_session;
    index_to_plot = (shock_session(1) - 3) : (shock_session(end) + 1);  % only plot the 3 sessions of baseline, 3 sessions of punishement and 1 sessions of Saline
    data_plot.activeLever(:, i)   = summary_testing(i).data.activeLeverPress(index_to_plot);
    data_plot.inactiveLever(:, i) = summary_testing(i).data.inactiveLeverPress(index_to_plot);
    data_plot.infusion(:,i)       = summary_testing(i).data.Reward(index_to_plot);
end
%% plot the active and inactive lever press
figure
baf.line_plot_MA_avg(data_plot.activeLever', data_plot.inactiveLever')
xlim([0, 8])
set(gcf,'position',[1500,600,340,340])

rectangle('Position',[3.5, 1, 3, 830], 'FaceColor', [0.8, 0, 0, 0.4], 'EdgeColor', 'none');
text(3.7, 815, 'Punishment', 'FontSize', 12, 'Color', 'r')
text(3.6, 765, '0.2 mA Shock', 'FontSize',12)
ylim([0, 1200])
hold on
plot([0.8, 6.5], [850, 850], 'Color', [178,178,1]/255, 'LineWidth',2)
text(3, 890, 'Fentanyl', 'FontSize', 12, 'Color', [178,178,1]/255, 'FontWeight','bold')
plot([6.5, 7.5], [850, 850], 'Color', [49,163,84]/255, 'LineWidth',2)
text(6.5, 890, 'Saline', 'FontSize', 12, 'Color', [49,163,84]/255, 'FontWeight','bold')
hold on
saveas(gcf, 'Fentanyl_Testing_LeverPress.pdf');
%% plot the infusion counts
figure;
baf.line_plot_errorbar(data_plot.infusion','k', 'Infusion #')
xlim([0, 8])
set(gcf,'position',[1500,600,340,340])
% format figure
rectangle('Position',[3.5, 1, 3, 90], 'FaceColor', [0.8, 0, 0, 0.4], 'EdgeColor', 'none');
text(3.7, 87, 'Punishment', 'FontSize', 12, 'Color', 'r')
text(3.6, 80, '0.2 mA Shock', 'FontSize',12)
ylim([0, 120])
hold on
plot([0.8, 6.5], [95, 95], 'Color', [178,178,1]/255, 'LineWidth',2)
text(3, 100, 'Fentanyl', 'FontSize', 12, 'Color', [178,178,1]/255, 'FontWeight','bold')
plot([6.5, 7.5], [95, 95], 'Color', [49,163,84]/255, 'LineWidth',2)
text(6.5, 100, 'Saline', 'FontSize', 12, 'Color', [49,163,84]/255, 'FontWeight','bold')
hold on
%
saveas(gcf, 'Fentanyl_testing_Infusion.pdf');
%% Plot the individual difference
% 
figure
taking = 1:3;
punishment = 4:6;
data_plot.animal_avg_taking = mean(data_plot.infusion(taking, :));
data_plot.animal_avg_punishment = mean(data_plot.infusion(punishment, :));
data_plot.n_animal_avg_taking   = data_plot.animal_avg_taking/mean(data_plot.animal_avg_taking);
data_plot.n_animal_avg_punishment  = data_plot.animal_avg_punishment/mean(data_plot.animal_avg_punishment);
data_plot.extinction_score      = data_plot.infusion(6,:)./data_plot.animal_avg_taking;
data_plot.n_extinction_score    = data_plot.extinction_score/mean( data_plot.extinction_score);
hold on
plot([100, 100], [0, 400], '--k')
plot([0, 200], [100, 100], '--k')
xlabel('Fentanyl Infusion (% of Group)')
ylabel('Fentanyl Infusion With Footshock (% of Group)')
clusterID = 1:4;
colors = cbrewer2('div', 'RdYlBu', 4);
index_01 = find(data_plot.n_animal_avg_taking >1 & data_plot.n_animal_avg_punishment> 1);
index_02 = find(data_plot.n_animal_avg_taking <1 & data_plot.n_animal_avg_punishment> 1);
index_03 = find(data_plot.n_animal_avg_taking >1 & data_plot.n_animal_avg_punishment< 1);
index_04 = find(data_plot.n_animal_avg_taking <1 & data_plot.n_animal_avg_punishment< 1);
scatter(data_plot.n_animal_avg_taking(index_01) *100, data_plot.n_animal_avg_punishment(index_01) *100, ...
    'o', 'MarkerFaceColor', colors(1,:), 'MarkerEdgeColor',colors(1,:))
hold on
scatter(data_plot.n_animal_avg_taking(index_02)*100, data_plot.n_animal_avg_punishment(index_02)*100, ...
    'o', 'MarkerFaceColor', colors(2,:), 'MarkerEdgeColor',colors(2,:))

scatter(data_plot.n_animal_avg_taking(index_03)*100, data_plot.n_animal_avg_punishment(index_03)*100, ...
    'o', 'MarkerFaceColor', colors(3,:), 'MarkerEdgeColor',colors(3,:))
scatter(data_plot.n_animal_avg_taking(index_04)*100, data_plot.n_animal_avg_punishment(index_04)*100, ...
    'o', 'MarkerFaceColor', colors(4,:), 'MarkerEdgeColor',colors(4,:))
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf, 'Color', 'white')
set(gcf,'position',[1500,600,340,340])

% plot individual mice
figure
rectangle('Position',[3.5, 1, 3, 150], 'FaceColor', [0.8, 0, 0, 0.4], 'EdgeColor', 'none');
hold on
plot(data_plot.infusion(1:6, index_01), '-o', 'MarkerFaceColor', colors(1,:), 'Color', colors(1,:))
hold on
plot(data_plot.infusion(1:6, index_02), '-o', 'MarkerFaceColor', colors(2,:), 'Color', colors(2,:))
plot(data_plot.infusion(1:6, index_03), '-o', 'MarkerFaceColor', colors(3,:), 'Color', colors(3,:))
plot(data_plot.infusion(1:6, index_04), '-o', 'MarkerFaceColor', colors(4,:), 'Color', colors(4,:))
xlim([0, 6.5])
xlabel('Sessions')
ylabel('Infusion #')
set(gcf,'position',[1500,600,340,340])
ylim([0, 200])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf, 'Color', 'white')
%% hierarchival 
data_for_cluster = [data_plot.n_animal_avg_taking;data_plot.n_animal_avg_punishment;data_plot.n_extinction_score]';
Z = linkage(data_for_cluster, 'ward', 'euclidean');
clusterN = 4;
T = cluster(Z,'maxclust',clusterN); % edit by ke, increase the cluster from 9 to 16.
cutoff =  Z(end-clusterN+2,3);
figure
subplot(2, 1, 1)
[H,tt,outperm] = dendrogram(Z,0,'ColorThreshold',cutoff);
% for i = 1:size(resp_ap_scaled, 2)
%     subplot(size(resp_ap_scaled, 2),1,i)
%     bar(resp_ap_scaled(outperm,i))
%     hold on
% end
data_reorg = data_for_cluster(outperm, :);
subplot(2, 1, 2)
imagesc(data_reorg')
colormap(jet)
set(gca,'YTick',[1, 2, 3])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gca, 'YTickLabel', {'Baseline','Punishment', 'Extinction'})
set(gcf,'position',[1500,600,340,340])


% plot based on clusters
clusterID = 1:4;
colors = cbrewer2('div', 'RdYlBu', 4);
index_01 = find(T ==3);
index_02 = find(T ==4);
index_03 = find(T ==2);
index_04 = find(T ==1);
figure
scatter(data_plot.n_animal_avg_taking(index_01) *100, data_plot.n_animal_avg_punishment(index_01) *100, ...
    'o', 'MarkerFaceColor', colors(1,:), 'MarkerEdgeColor',colors(1,:))
hold on
scatter(data_plot.n_animal_avg_taking(index_02)*100, data_plot.n_animal_avg_punishment(index_02)*100, ...
    'o', 'MarkerFaceColor', colors(2,:), 'MarkerEdgeColor',colors(2,:))

scatter(data_plot.n_animal_avg_taking(index_03)*100, data_plot.n_animal_avg_punishment(index_03)*100, ...
    'o', 'MarkerFaceColor', colors(3,:), 'MarkerEdgeColor',colors(3,:))
scatter(data_plot.n_animal_avg_taking(index_04)*100, data_plot.n_animal_avg_punishment(index_04)*100, ...
    'o', 'MarkerFaceColor', colors(4,:), 'MarkerEdgeColor',colors(4,:))
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf, 'Color', 'white')
set(gcf,'position',[1500,600,340,340])
hold on
plot([100, 100], [0, 400], '--k')
plot([0, 200], [100, 100], '--k')
xlabel('Fentanyl Infusion (% of Group)')
ylabel('Fentanyl Infusion With Footshock (% of Group)')

% plot individual mice
figure
rectangle('Position',[3.5, 1, 3, 150], 'FaceColor', [0.8, 0, 0, 0.4], 'EdgeColor', 'none');
hold on
plot(data_plot.infusion(1:6, index_01), '-o', 'MarkerFaceColor', colors(1,:), 'Color', colors(1,:))
hold on
plot(data_plot.infusion(1:6, index_02), '-o', 'MarkerFaceColor', colors(2,:), 'Color', colors(2,:))
plot(data_plot.infusion(1:6, index_03), '-o', 'MarkerFaceColor', colors(3,:), 'Color', colors(3,:))
plot(data_plot.infusion(1:6, index_04), '-o', 'MarkerFaceColor', colors(4,:), 'Color', colors(4,:))
xlim([0, 6.5])
xlabel('Sessions')
ylabel('Infusion #')
set(gcf,'position',[1500,600,340,340])
ylim([0, 200])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf, 'Color', 'white')
%% save cluster information
data_plot.cluster_ID = 1:4;
data_plot.clusters = 1:length(data_plot.infusion);
data_plot.clusters(index_01) = 1;
data_plot.clusters(index_02) = 2;
data_plot.clusters(index_03) = 3;
data_plot.clusters(index_04) = 4;
%% plottting
% Infusion counts baseline
infusion_counts = [];
for i = 1:length(data_plot.cluster_ID)
    infusion_counts{i} = data_plot.animal_avg_taking(data_plot.clusters ==i);
end
figure
baf.barplot_scatter(infusion_counts)
ylabel('Fentanyl Infusion')
ylim([0, 150])

infusion_counts_punishment = [];
for i = 1:length(data_plot.cluster_ID)
    infusion_counts_punishment{i} = data_plot.animal_avg_punishment(data_plot.clusters ==i);
end
figure
baf.barplot_scatter(infusion_counts_punishment)
ylabel('Fentanyl Infusion with Punishment')
ylim([0, 150])

extinction_score = [];
for i = 1:length(data_plot.cluster_ID)
    extinction_score{i} = data_plot.extinction_score(data_plot.clusters ==i);
end
figure
baf.barplot_scatter(extinction_score)
ylabel('Extinction Score')
ylim([0, 3])


