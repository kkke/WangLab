%% try to cluster behaviors
function [groupdata, cluster_id] = behavior_analysis_cluster(groupdata, clusterN)
baf = behavior_analysis_func;
figure
reward_summary = [];
for i = 1:length(groupdata)
    scatter3(groupdata(i).reward.infusion, groupdata(i).reward.infusion_punishment, ...
        groupdata(i).reward.infusion_reinstatment)
    hold on
    reward_summary(i, :) = [groupdata(i).reward.infusion, groupdata(i).reward.infusion_punishment, ...
        groupdata(i).reward.infusion_reinstatment];
end
xlabel('Infusion')
ylabel('Infusion with punishment')
zlabel('Infusion during reinstatment')
% calculate resistence score
resistence = reward_summary(:, 2)./(reward_summary(:, 2) + reward_summary(:, 1));
reinstatment = reward_summary(:, 3)./(reward_summary(:, 3) + reward_summary(:, 1));
% figure; scatter(resistence, reinstatment, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'w')
% hold on
% plot([0, 0.7], [0, 0.7], 'k--')
% xlabel('Resistence Score')
% ylabel('Reinstatment Score')
% 
% plot([0.4, 0.4], [0, 0.7], 'r--')
% plot([0, 0.4], [0.4, 0.4], 'r--')

% group1 = find(resistence > 0.4);
% group2 = find(resistence < 0.4 & reinstatment > 0.4 );
% group3 = find(resistence < 0.4 & reinstatment < 0.4 );
% cluster_id = zeros(size(groupdata));
% cluster_id(group1) = 1;
% cluster_id(group2) = 2;
% cluster_id(group3) = 3;



figure;
cluster_id = baf.hierarchical_cluster([resistence, reinstatment], clusterN);
% figure;
% cluster_id = baf.hierarchical_cluster(reward_summary);
colors = cbrewer2('div', 'RdYlBu', 4);

figure;
cluster_id_class = unique(cluster_id);
for i = 1:length(cluster_id_class)
    scatter(resistence(cluster_id==i), reinstatment(cluster_id ==i), 'MarkerFaceColor',colors(i, :), 'MarkerEdgeColor','w')
    hold on
end
hold on
plot([0, 0.7], [0, 0.7], 'k--')
xlabel('Resistence Score')
ylabel('Reinstatment Score')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
axis square
% plot([0.4, 0.4], [0, 0.7], 'r--')
% plot([0, 0.4], [0.4, 0.4], 'r--')

% figure;
% imagesc(reward_summary')
% cluster_id = baf.hierarchical_cluster(reward_summary);
figure
label_id = {'Fentanyl', 'Fentanyl + Punishment', 'Saline'}
for i = 1:3
    subplot(1, 3, i)
    hold on
    for j = 1:length(cluster_id_class)
        cluster_temp = reward_summary(cluster_id == j,:);
        mean_value= mean(cluster_temp(:, i));
        sem_value = std(cluster_temp(:, i))/sqrt(length(cluster_temp(:, i)));

        b(j) = bar(j, mean_value);
        b(j).FaceColor = 'flat';
    
    b(j).CData = colors(j, :);
    hold on
    errorbar(j, mean_value, sem_value,'k.', 'LineWidth', 1, 'CapSize',10)
    scatter(j + 0.3* (rand(size(cluster_temp(:, i)))-0.5), cluster_temp(:, i), 'k', 'MarkerFaceColor','k')
    
    xlabel('Cluster #');
    ylabel('Infusion #');
    end
    title(label_id{i})
    % ttest2()
end


% save cluster info to the dataset
for i = 1:length(groupdata)
    groupdata(i).cluster.resistence = resistence(i);
    groupdata(i).cluster.reinstatement = reinstatment(i);
    groupdata(i).cluster.cluster       = cluster_id(i);
end