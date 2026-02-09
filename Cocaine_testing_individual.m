%% Plot the individual difference for cocaine IVSA testing
%% load the data
clc; clear
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_testing_summary')
%%
taking = 1:3;
punishment = 4:6;
data_plot.animal_avg_taking = mean(data_plot.infusion(taking, :));
data_plot.animal_avg_punishment = mean(data_plot.infusion(punishment, :));
data_plot.activeLever_taking = mean(data_plot.activeLever(taking, :));
data_plot.activeLever_punishment = mean(data_plot.activeLever(punishment, :));

data_plot.activeLever_perInfusion = data_plot.activeLever./data_plot.infusion;
data_plot.activeLever_perInfusion(isinf(data_plot.activeLever_perInfusion)) = NaN;
data_plot.activeLever_Cue_taking = mean(data_plot.activeLever_Cue(taking, :));
data_plot.activeLever_Cue_punishment = mean(data_plot.activeLever_Cue(punishment, :));

data_plot.n_animal_avg_taking   = data_plot.animal_avg_taking/mean(data_plot.animal_avg_taking);
data_plot.n_animal_avg_punishment  = data_plot.animal_avg_punishment/mean(data_plot.animal_avg_punishment);
data_plot.extinction_score      = data_plot.infusion(6,:)./data_plot.animal_avg_taking;
data_plot.n_extinction_score    = data_plot.extinction_score/mean( data_plot.extinction_score);
%
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
save('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_testing_summary_cluster.mat', ...
    'summary_testing', 'data_plot')

figure;
mysets = ["High Taker" "Low Taker" "High Resistance" "Low Resistance"];
mylabels = [length(high_taker), length(low_taker), length(high_resistance), length(low_resistance),...
    length(intersect(high_taker, low_taker)), length(intersect(high_taker, high_resistance)), length(intersect(high_taker, low_resistance)), ...
    length(intersect(low_taker, high_resistance)), length(intersect(low_taker, low_resistance)), 0, 0, 0, 0,0];
venn(4, 'sets', mysets, 'labels', mylabels )
%%
figure
baf = behavior_analysis_func;
subplot(1, 2, 1)
active_levers = [data_plot.activeLever_taking', data_plot.activeLever_punishment'];
plot(active_levers', '-o', 'Color', 0.8* [1, 1, 1], 'LineWidth', 1, 'MarkerFaceColor','w')
hold on
baf.line_plot_errorbar(active_levers, 'r', 'Active Lever Presses')
xlim([0, 3])
ylim([0, 1000])
xticks([1, 2])
xticklabels({'Baseline', 'Punishment'})
xlabel('')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf, 'Color', 'white')

subplot(1, 2, 2)
infusions = [data_plot.animal_avg_taking', data_plot.animal_avg_punishment']
plot(infusions', '-o', 'Color', 0.8* [1, 1, 1], 'LineWidth', 1, 'MarkerFaceColor','w')
hold on
baf.line_plot_errorbar(infusions, 'k', 'Infusions/3 hours')
xlim([0, 3])
ylim([0, 150])
xticks([1, 2])
xticklabels({'Baseline', 'Punishment'})
xlabel('')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[500,100,500,250])
set(gcf, 'Color', 'white')

%% reaction time
for i = 1:length(summary_testing)
    summary_testing(i).high_taker = NaN;
    summary_testing(i).resistance = NaN;
end

[summary_testing(high_taker).high_taker] = deal(1);
[summary_testing(low_taker).high_taker] = deal(0);
[summary_testing(high_resistance).resistance] = deal(1);
[summary_testing(low_resistance).resistance] = deal(0);

% get the reward time for each trial
for i = 1:length(data_plot.timestamps)
    for j = 1:length(data_plot.timestamps(i).timestamps)
        if isempty(data_plot.timestamps(i).timestamps(j).reward)
            data_plot.timestamps(i).timestamps(j).reward_time = NaN;
            data_plot.reward_time_avg(j, i) = NaN;

        elseif length(data_plot.timestamps(i).timestamps(j).reward) == length(data_plot.timestamps(i).timestamps(j).cue)
            data_plot.timestamps(i).timestamps(j).reward_time = data_plot.timestamps(i).timestamps(j).reward - data_plot.timestamps(i).timestamps(j).cue;
        elseif length(data_plot.timestamps(i).timestamps(j).reward) < length(data_plot.timestamps(i).timestamps(j).cue)
            data_plot.timestamps(i).timestamps(j).reward_time = data_plot.timestamps(i).timestamps(j).reward - data_plot.timestamps(i).timestamps(j).cue(1:end-1);
        end
        data_plot.reward_time_avg(j, i) = mean(data_plot.timestamps(i).timestamps(j).reward_time);
    end
end
%% get the inter-infusion-interval
% get the reward time for each trial
for i = 1:length(data_plot.timestamps)
    for j = 1:length(data_plot.timestamps(i).timestamps)
        if isempty(data_plot.timestamps(i).timestamps(j).reward)||length(data_plot.timestamps(i).timestamps(j).reward)<2
            data_plot.ifi(j, i) = NaN;
        else
           data_plot.ifi(j,i) = mean(diff(data_plot.timestamps(i).timestamps(j).reward));
        end
    end
end

%% get the active lever press timestamps
baf = behavior_analysis_func;
for i = 1:length(summary_testing)
    training_protocol = split(summary_testing(i).data{1, 'training'}, " ");
    switch training_protocol{1}
        case 'Back'
            active_lever = 'back_lever';
            inactive_lever = 'front_lever';
        case 'Front'
            active_lever = 'front_lever';
            inactive_lever = 'back_lever';
    end
    for j = 1:length(data_plot.timestamps(i).timestamps)
    data_plot.timestamps(i).timestamps(j).active_lever = data_plot.timestamps(i).timestamps(j).(active_lever);
    data_plot.timestamps(i).timestamps(j).inactive_lever = data_plot.timestamps(i).timestamps(j).(inactive_lever);
    data_plot.timestamps(i).timestamps(j).perievent =  baf.raster_plot(data_plot.timestamps(i).timestamps(j));
    data_plot.reaction_time_avg(j, i) = mean([data_plot.timestamps(i).timestamps(j).perievent.reaction_time]);
    data_plot.ipi_avg(j,i) = mean([data_plot.timestamps(i).timestamps(j).perievent.ipi]);
    end
end

%%
data_plot.reward_time_avg_taking = mean(data_plot.reward_time_avg(taking, :));
data_plot.ifi_taking             = mean(data_plot.ifi(taking,:));
save('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_testing_summary_cluster.mat', ...
    'summary_testing', 'data_plot')
%% plot the individual differences
drug_individual_plots(data_plot)
%% hierarchival 
% data_for_cluster = [data_plot.n_animal_avg_taking;data_plot.n_animal_avg_punishment;data_plot.n_extinction_score]';
% Z = linkage(data_for_cluster, 'ward', 'euclidean');
% clusterN = 4;
% T = cluster(Z,'maxclust',clusterN); % edit by ke, increase the cluster from 9 to 16.
% cutoff =  Z(end-clusterN+2,3);
% figure
% subplot(2, 1, 1)
% [H,tt,outperm] = dendrogram(Z,0,'ColorThreshold',cutoff);
% for i = 1:size(resp_ap_scaled, 2)
%     subplot(size(resp_ap_scaled, 2),1,i)
%     bar(resp_ap_scaled(outperm,i))
%     hold on
% end
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


% plot based on clusters
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

% plot individual mice
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
%% save cluster information
% data_plot.cluster_ID = 1:4;
% data_plot.clusters = 1:length(data_plot.infusion);
% data_plot.clusters(index_01) = 1;
% data_plot.clusters(index_02) = 2;
% data_plot.clusters(index_03) = 3;
% data_plot.clusters(index_04) = 4;
%% plottting
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
%%

