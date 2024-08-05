%% Load the data
clear; close all; clc
fb = fb_extract_doric;
load("Fentanyl_Seeking_data.mat")
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
[groupdata, cluster] = behavior_analysis_cluster(groupdata);
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
ylabel('DA response (norm. z-score)');
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
    scatter(i + 0.3* (rand(size(resp2_cluster{i}))-0.5), resp_cluster{i}, 'k', 'MarkerFaceColor','k')
    % ttest2()
end
xlabel('Cluster #');
ylabel('DA response (norm. z-score)');
set(gcf,'position',[100,100,300,300])
