%% Load the data
clear; close all; clc
fb = fb_extract_doric;
load("Cocaine_Seeking_data.mat")
%% calculate all PSTHs
events = {'infusion', 'leverInsertion', 'leverRetraction'};
pre = -10; % time before event, sec
post = 50; % time after event, sec
plot_tf = 0; % plot: 1; not plot: 0
psth_summary =[];
psth_summary_avg =[];
for i = 1:length(groupdata)
    [psth_time,groupdata(i).psth_infusion, fig] = fb.psth_fb(groupdata(i).signal, groupdata(i).time,groupdata(i).(events{1}), pre, post, plot_tf, events{1});
    groupdata(i).psth_infusion_avg = mean(groupdata(i).psth_infusion, 2, 'omitmissing');
    groupdata(i).psth_infusion_time = mean(psth_time, 2, 'omitmissing');
end
%% classify animal behaivors
groupdata = behavior_analysis_summary(groupdata);
[groupdata, cluster] = behavior_analysis_cluster(groupdata, 4);
%% plot population psth
time_avg = [];
psth_avg = [];
for i = 1:length(groupdata)
    % figure;
    % plot(groupdata(i).psth_infusion_time, groupdata(i).psth_infusion_avg)
    time_avg(:,i) = groupdata(i).psth_infusion_time;
    psth_avg(:,i) = groupdata(i).psth_infusion_avg;
end
fb.groupplot_psth_avg(time_avg, psth_avg)
set(gcf,'position',[100,100,600,600])
%% sort the psth according to the infusion counts
reward_reinstatement=[];
reinstatement_score = [];
for i = 1:length(groupdata)
    reward_reinstatement(i) = groupdata(i).reward.infusion_reinstatment;
    reinstatement_score(i) = groupdata(i).cluster.reinstatement;
end

[B, I]  = sort(reward_reinstatement, 'descend');
fb.groupplot_psth_avg(time_avg(:, I), psth_avg(:, I))
set(gcf,'position',[100,100,600,600])
%% sort the psth acoording to the responses
resp = [];
resp2 = [];
baseline = [];
for i = 1:length(groupdata)
    resp_index = find(time_avg(:, i) >0 & time_avg(:,i) < 1);
    resp2_index = find(time_avg(:, i)>0 & time_avg(:, i)< 20);
    baseline_index = find(time_avg(:, i)>-1 & time_avg(:, i)< 0);
    baseline(i) = mean(psth_avg(baseline_index, i));
    resp(i)  = mean(psth_avg(resp_index, i) - baseline(i));
    resp2(i) = mean(psth_avg(resp2_index, i)- baseline(i));
end

[B, I]  = sort(reward_reinstatement, 'descend');
fb.groupplot_psth_avg(time_avg(:, I), psth_avg(:, I) -baseline(I))
set(gcf,'position',[100,100,600,600])
%% assemble the summary data
data.seeking.psth_avg = psth_avg -baseline;
data.seeking.resp = resp;
data.seeking.resp2 = resp2;
data.seeking.cluster = cluster;
data.seeking.reinstatement = reinstatement_score;
data.seeking.time_avg = time_avg;
data.seeking.psth_avg_nonnorm = psth_avg;
%% plot the resp based on cluster
figure
colors = cbrewer2('div', 'RdYlBu', 4);
clusterID = unique(cluster);
for i = 1:length(clusterID)
    cluster_index = find(cluster == i);
    resp_cluster{i} = resp(:, cluster_index)';
    resp2_cluster{i} = resp2(:, cluster_index)';
    mean_resp = mean(resp_cluster{i}, 'omitmissing');
    sem_resp = std(resp_cluster{i}, 'omitmissing')/sqrt(length(resp_cluster{i}));
    b = bar(i, mean_resp);
    b.FaceColor = 'flat';
    b.CData(1,:) = colors(i, :);
    hold on
    errorbar(i, mean_resp, sem_resp,'k.', 'LineWidth', 1.5, 'CapSize',20)
    scatter(i + 0.3* (rand(size(resp_cluster{i}))-0.5), resp_cluster{i}, 'k', 'MarkerFaceColor','k')
    % ttest2()
end
xlabel('Cluster #');
ylabel('DA response (0 -1s norm. z-score)');
set(gcf,'position',[100,100,300,300])
%%
figure
colors = cbrewer2('div', 'RdYlBu', 4);
clusterID = unique(cluster);
for i = 1:length(clusterID)
    cluster_index = find(cluster == i);
    resp2_cluster{i} = resp2(:, cluster_index)';
    mean_resp2 = mean(resp2_cluster{i}, 'omitmissing');
    sem_resp2 = std(resp2_cluster{i}, 'omitmissing')/sqrt(length(resp_cluster{i}));
    b = bar(i, mean_resp2);
    b.FaceColor = 'flat';
    b.CData(1,:) = colors(i, :);
    hold on
    errorbar(i, mean_resp2, sem_resp2,'k.', 'LineWidth', 1.5, 'CapSize',20)
    scatter(i + 0.3* (rand(size(resp2_cluster{i}))-0.5), resp2_cluster{i}, 'k', 'MarkerFaceColor','k')
    % ttest2()
end
xlabel('Cluster #');
ylabel('DA response (0 - 20s norm. z-score)');
set(gcf,'position',[100,100,300,300])
%% regression
mdl = fb.correlaiton_analysis_cluster(resp, reward_reinstatement, cluster)
ylim([0, 120])
xlim([-1, 1])
ylabel('Infusion #')

mdl = fb.correlaiton_analysis_cluster(resp2, reward_reinstatement, cluster)
ylim([0, 120])
xlim([-1, 3])
ylabel('Infusion #')

%% regression
mdl = fb.correlaiton_analysis_cluster(resp, reinstatement_score, cluster)
ylim([0, 0.8])
xlim([-1, 1])
ylabel('Reinstatement Score')

mdl = fb.correlaiton_analysis_cluster(resp2, reinstatement_score, cluster)
ylim([0, 0.8])
xlim([-1, 3])
ylabel('Reinstatement Score')

%% based on cluster
psth_summary_time = mean(time_avg, 2, 'omitmissing');
cluster_id = [];
for i = 1:length(groupdata)
    cluster_id(i) = groupdata(i).cluster.cluster;
end
psth_cluster_01 = data.seeking.psth_avg(:, cluster == 1);
psth_cluster_02 = data.seeking.psth_avg(:, cluster_id == 2);
psth_cluster_03 = data.seeking.psth_avg(:, cluster_id == 3);
psth_cluster_04 = data.seeking.psth_avg(:, cluster_id == 4);
figure;
imagesc(psth_summary_time, [], [psth_cluster_01';psth_cluster_02';psth_cluster_03';psth_cluster_04'])
box off
xlabel('Time (s)')
set(gca,'YTick',[1, 2, 3, 4, 8, 12, 13, 16, 19])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gca, 'YTickLabel', {'1','# 1', '3', '4', '# 2', '12', '13', '# 3', '19'})
ylabel('Clusters')
% set(gca, 'YTickLabel', {'Rearing', 'Tremor', 'wet-dog shaking', 'Jump', 'Optogenetic Stim' })
set(gcf,'position',[100,100,800,100])

% plot pupulation dopamine psth
figure
colors = cbrewer2('div', 'RdYlBu', 4);
fb = fb_extract_doric;
h1 = fb.boundedline_plot(psth_summary_time, psth_cluster_01, colors(1,:));
hold on
h2 = fb.boundedline_plot(psth_summary_time, psth_cluster_02, colors(2,:));
h3 = fb.boundedline_plot(psth_summary_time, psth_cluster_03, colors(3,:));
h4 = fb.boundedline_plot(psth_summary_time, psth_cluster_04, colors(4,:));
ylim([-1, 2.5])
legend([h1, h2, h3, h4], {'Cluster # 1', 'Cluster # 2','Cluster # 3', 'Cluster #4'})
set(gcf,'position',[100,100,600,600])

