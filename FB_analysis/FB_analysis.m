%% load individual dataset
clear, clc
fb = fb_extract_doric;
% folder = 'H:\Data\FB_data\Dopamine\SA144\072224';
folder = 'H:\Data\FB_data\VGATGCAMP01\073124';
% folder = 'H:\Data\FB_data\Dopamine\Fentanyl\SADA13\063023'
% filename = 'SADA05_Ch2_DLS_Ch4_NAc_112123_0001';  % naming needs to be: aminalID_date_region
filename = 'VGATGCAMP01_073124_NAc_0000';  % naming needs to be: aminalID_date_region
Sessions = {'Taking', 'Punishment', 'Seeking', 'Cue','shock','Non-Contingent', 'Opto'};
session = Sessions{6};
% data = fb.load_ch2_threeSeries([folder, '\', filename]);
% data1 = fb.load_ch2_threeSeries_ployfit([folder, '\', filename]);
data = fb.load_ch2_oneSeries([folder, '\', filename]);
% data = fb.load_green_red_threeSeries([folder, '\', filename]);
% data = fb.load_green_red_oneSeries([folder, '\', filename]);
data = fb.fill_metadata(data, filename, session);
summarydata = fb.save_data(data, folder);

%% Plot PSTH
clc; close all;
i =11
events = {'infusion', 'leverInsertion', 'leverRetraction'};
% Plot PSTH aligned to drug infusion
[~,~, fig1] = fb.psth_fb(summarydata(i).signal, summarydata(i).time,summarydata(i).(events{1}), -10, 50, 1, events{1});
set(gcf,'position',[100,100,900,400])
caxis([-2, 5])
saveas(gcf, [summarydata(i).animalID, '_', summarydata(i).date, '_', summarydata(i).region, '_', ...
    summarydata(i).session, '_', events{1}, '.pdf'])
% Plot PSTH aligned to lever insertion
[~,~, fig2] = fb.psth_fb(summarydata(i).signal, summarydata(i).time,summarydata(i).(events{2}), -5, 10, 1 ,events{2});
savefig(fig2, [summarydata(i).animalID, '_', summarydata(i).date, '_', summarydata(i).region, '_', ...
    summarydata(i).session, '_', events{2}, '.fig'])
% Plot PSTH aligned to lever retraction
[~,~, fig2] = fb.psth_fb(summarydata(i).signal, summarydata(i).time,summarydata(i).(events{3}), -5, 10, 1 ,events{3});
savefig(fig2, [summarydata(i).animalID, '_', summarydata(i).date, '_', summarydata(i).region, '_', ...
    summarydata(i).session, '_', events{3}, '.fig'])
%%
%% behavioral plot
clear
load('sa97_Behavior_ThreeHoursSessions.mat')
baf = behavior_analysis_func;
baf.behavioral_shock_plot(summarydata)
sgtitle(summarydata.subject(1))
saveas(gcf, [char(summarydata.subject(1)), '.pdf'], 'pdf');
%%
leverInsertion = summarydata(i).leverInsertion;
time = summarydata(i).time;
signal = summarydata(i).signal;
front = summarydata(i).front;
back = summarydata(i).back;
infusion = summarydata(i).infusion;
figure
session = [30*60, 90*60, 150*60]; % record every 30 min
k =1
for j = 1:length(leverInsertion)-1
    % j = 1
    if leverInsertion(j+1)< session(k)
        indx = find(time > leverInsertion(j) & time < leverInsertion(j+1));
        reset_time = leverInsertion(j);
        plot(time(indx)-reset_time, signal(indx)+4*j)
        hold on
        index2 = find(back > leverInsertion(j) & back < leverInsertion(j+1));
        plot([back(index2), back(index2)]- reset_time, [-4, 4] + 4*j, 'r')
        % index3 = find(front > leverInsertion(j) & front < leverInsertion(j+1));
        % plot([front(index3), front(index3)] - reset_time, [-4, 4] + 4*j, 'r')
        index4 = find(infusion > leverInsertion(j) & infusion < leverInsertion(j+1));
        plot([infusion(index4), infusion(index4)]- reset_time, [-4, 4] + 4*j, 'g')
    else
        k = k+1
    end

end
xlabel('Time (s)')
ylabel('Trials + Z-score dF/F')
%% plot behaviors
clear
load('sa57_ThreeHoursSessions.mat')
baf = behavior_analysis_func;
baf.behavioral_shock_plot(summarydata)
id = summarydata.subject(1);
sgtitle(id)
saveas(gcf, [id + '.pdf'], 'pdf');
%% analysis of lever press responses
j =7
clear leverPress_trial
 
activeLever = summarydata(j).back;
n_activeLever = length(activeLever);
dist_lever = []
onset_lever = [];
offset_lever = [];
thresh = 2 ;
for i = 1:(n_activeLever-1)
    if i ==1
        if activeLever(i+1) > activeLever(i)+thresh
            dist_lever = [dist_lever, i];
        else
            onset_lever = [onset_lever, i];
        end


    else
        if activeLever(i+1) > activeLever(i)+thresh && activeLever(i)> activeLever(i-1)+thresh
            dist_lever = [dist_lever, i];
        elseif activeLever(i+1) > activeLever(i)+thresh && activeLever(i)< activeLever(i-1)+thresh
            offset_lever = [offset_lever, i];
        elseif activeLever(i+1) < activeLever(i)+thresh && activeLever(i)> activeLever(i-1)+thresh
            onset_lever = [onset_lever, i];
        end
    end
end

% find lever press before infusion
leverInsertion = summarydata(j).leverInsertion;
infusion = summarydata(j).infusion;
session = [30*60, 90*60, 150*60]; % record every 30 min
k = 1;
for i = 1:length(leverInsertion)
    if i<= length(infusion)
        if leverInsertion(i) < session(k) && infusion(i) < session(k)
            indx = min(find(infusion>leverInsertion(i)));
            if isempty(indx)
            else
                leverPress_trial{i} = find(activeLever>leverInsertion(i) & activeLever < infusion(indx))';
            end
        else
            k = k+1;
        end
    end

end
lever_beforeInfusion = cell2mat(leverPress_trial);
lever_beforeInfusion = lever_beforeInfusion(:);

lever_single = intersect(lever_beforeInfusion, dist_lever);
lever_bout_onset = intersect(lever_beforeInfusion, onset_lever);


% Plot PSTH aligned to drug infusion
[~,~, fig1] = fb.psth_fb(summarydata(j).signal, summarydata(j).time,activeLever(lever_single), -5, 5, 1, 'Single ActiveLever');
set(gcf,'position',[100,100,250,400])
caxis([-2, 5])


% Plot PSTH aligned to drug infusion
[~,~, fig1] = fb.psth_fb(summarydata(j).signal, summarydata(j).time,activeLever(lever_bout_onset), -5, 5, 1, 'Onset Bout ActiveLever');
set(gcf,'position',[100,100,250,400])
caxis([-2, 5])



%% Save to a master datasets
folder = 'H:\Data\FB_data\Dopamine\Cocaine';
% Get a list of all files and folders in this folder
files = dir(folder);
% Extract only the directories
subFolders = files([files.isdir]);
% Remove '.' and '..' directories
subFolders(ismember({subFolders.name},{'.','..'})) = [];
% Extract only the names of the directories
animalIDs = {subFolders.name};
% Loop through each subfolder and load the summary files
alldata={}; 
for i = 1:length(animalIDs)
    load([folder, '\',animalIDs{i}, '\summary.mat'])
    alldata{i} = summarydata;
end
save([folder,'\' , 'summarydata.mat'], 'alldata')
%% check the population psth
%drug taking, NAc
clear, clc; close all
fb = fb_extract_doric;
load('summarydata.mat')
session = {'Taking', 'Punishment', 'Seeking', 'shock', 'Non-Contingent'};
region = 'NAc';
event = {'infusion'};
pre = -5;
post =  50;
for i = 1:length(session)
    for j = 1:length(event)
        if strcmp(session{i}, 'Non-Contingent')
            avg_psth_summary.noncontingent = fb.average_psth(alldata, session{i}, event{j}, region, pre, post(j));
        else
            avg_psth_summary.(session{i}).(event{j}) = fb.average_psth(alldata, session{i}, event{j}, region, pre, post(j));

        end
    end
end
%% Plot average psth across sessions
figure
colors = cbrewer('div', 'RdYlBu', 4);
h1 = fb.boundedline_plot(avg_psth_summary.Taking.(event{1}).time, avg_psth_summary.Taking.(event{1}).avg_psth, colors(4,:));
hold on
h2 = fb.boundedline_plot(avg_psth_summary.Punishment.(event{1}).time, avg_psth_summary.Punishment.(event{1}).avg_psth, colors(1,:));
h3 = fb.boundedline_plot(avg_psth_summary.Seeking.(event{1}).time, avg_psth_summary.Seeking.(event{1}).avg_psth, colors(2,:));
h4 = fb.boundedline_plot(avg_psth_summary.noncontingent.time, avg_psth_summary.noncontingent.avg_psth, [0.5, 0.5, 0.5]);
plot([0, 0], [-1, 4], '--k', 'LineWidth', 1)
legend([h1, h2, h3, h4], {'Taking', 'Punishment', 'Reinstatement', 'Non-Contingent'})
ylim([-1, 2])

%% Plot individual difference based on behavioral clustering
group1 = [1, 2, 7, 9,10,12];
group2 = 1:length(alldata);
group2(ismember(group2, group1)) = [];
figure
colors = cbrewer('div', 'RdYlBu', 4);
h1 = fb.boundedline_plot(avg_psth_summary.Taking.(event{1}).time, avg_psth_summary.Taking.(event{1}).avg_psth(:, group1), colors(1,:));
hold on
h2 = fb.boundedline_plot(avg_psth_summary.Taking.(event{1}).time, avg_psth_summary.Taking.(event{1}).avg_psth(:, group2), colors(4,:));
ylim([-1, 2])
plot([0, 0], [-0.5, 1.5], '--k', 'LineWidth',1)
legend([h1, h2], {'Compulsive', 'Non-Compulsive'})
title('Taking')
figure;
h1 = fb.boundedline_plot(avg_psth_summary.Punishment.(event{1}).time, avg_psth_summary.Punishment.(event{1}).avg_psth(:, group1), colors(1,:));
hold on
h2 = fb.boundedline_plot(avg_psth_summary.Punishment.(event{1}).time, avg_psth_summary.Punishment.(event{1}).avg_psth(:, group2), colors(4,:));
ylim([-1, 5])
plot([0, 0], [-0.5, 3], '--k', 'LineWidth',1)
legend([h1, h2], {'Compulsive', 'Non-Compulsive'})
title('Punishment')

figure;
h1 = fb.boundedline_plot(avg_psth_summary.Punishment.(event{1}).time, avg_psth_summary.Seeking.(event{1}).avg_psth(:, group1), colors(1,:));
hold on
h2 = fb.boundedline_plot(avg_psth_summary.Punishment.(event{1}).time, avg_psth_summary.Seeking.(event{1}).avg_psth(:, group2), colors(4,:));
ylim([-1, 3])
plot([0, 0], [-0.5, 1.5], '--k', 'LineWidth',1)
legend([h1, h2], {'Compulsive', 'Non-Compulsive'})
title('Reinstatement')

%% bar plot
event = 'infusion';
time = avg_psth_summary.Punishment.(event).time;
avg_psth = avg_psth_summary.Punishment.(event).avg_psth;
pre = find(time>-5 & time < 0);
post1 = find(time> 0 & time < 10);
post2 = find(time> 10 & time < 20);

pre_avg = mean(avg_psth(pre,group1), 1, 'omitnan');
post1_avg = mean(avg_psth(post1, group1), 1, 'omitnan');
post2_avg = mean(avg_psth(post2, group1), 1, 'omitnan');
% fb.Pairline_plot([pre_avg; post1_avg]')

fb.Pairline_plot([pre_avg; post1_avg; post2_avg]')
set(gca, 'XTick', [0:3])
ylim([-0.5, 5])
set(gca, 'XTickLabel', {'', '-5 - 0s', '0 - 10s', '10 - 20 s'})
% set(gca, 'XTickLabel', {'', '-5 - 0s', '0 - 5s'})

ylabel('Average Z \Delta F/F')
title('Compulsive')

%%
time = avg_psth_summary.Punishment.(event).time;
avg_psth = avg_psth_summary.Punishment.(event).avg_psth;
pre = find(time>-5 & time < 0);
post1 = find(time> 0 & time < 10);
post2 = find(time> 10 & time < 20);
pre_avg = mean(avg_psth(pre,group2), 1, 'omitnan');
post1_avg = mean(avg_psth(post1, group2), 1, 'omitnan');
post2_avg = mean(avg_psth(post2, group2), 1, 'omitnan');
% fb.Pairline_plot([pre_avg; post1_avg]')

fb.Pairline_plot([pre_avg; post1_avg; post2_avg]')
set(gca, 'XTick', [0:3])
set(gca, 'XTickLabel', {'', '-5 - 0s', '0 - 10s', '10 - 20 s'})
% set(gca, 'XTickLabel', {'', '-5 - 0s', '0 - 5s'})

ylim([-0.5, 5])
ylabel('Average Z \Delta F/F')
title('Non-Compulsive')
%% Let's separate behavirors
i = 1;
time = summarydata(i).time;
indx = find(diff(time) >1);
time_range_index = [1, indx', length(time)];
for j = 1:3
    find(summarydata(i).infusion > time(time_range_index(j)) & summarydata(i).infusion < time(time_range_index(j+1)));
    find(summarydata(i).infusion > time(time_range_index(j)) & summarydata(i).infusion < time(time_range_index(j+1)));
    find(summarydata(i).infusion > time(time_range_index(j)) & summarydata(i).infusion < time(time_range_index(j+1)));
end

%% Trial to Trial analysis
leverInsertion = summarydata(7).leverInsertion;
infusion       = summarydata(7).infusion;
reward_time = infusion -leverInsertion(1:end-1); 

i = 7;
[psth_time, psth_signal, fig1] = fb.psth_fb(summarydata(i).signal, summarydata(i).time,summarydata(i).(events{1}), 0, 40, 1, events{1});

%% Summary analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc; close all
% Step 1: chekc the reinstatement responses
% go the dropbox summary folder
filelist = dir('*_summary.mat');
groupdata = [];
for i = 1:length(filelist)
    filename = filelist(i).name;
    load(filelist(i).name)
    sessions = {summarydata.session};
    regions = {summarydata.region};
    dates = {summarydata.date};
    seeking_index = find(strcmp('Non-Contingent', sessions) & strcmp('NAc', regions));
    % groupdata(i).filename = filename;
    % groupdata(i).session = 'Seeking';
    % groupdata(i).region = 'NAc';
    % groupdata(i).date = dates{seeking_index};
    % groupdata(i).seeking_index = seeking_index;
    groupdata = [groupdata, summarydata(seeking_index)];
end
%% calculate all PSTHs
fb = fb_extract_doric;
events = {'infusion', 'leverInsertion', 'leverRetraction'};
psth_summary =[];
psth_summary_avg =[];
for i = 1:length(groupdata)
    [psth_time,groupdata(i).psth_infusion, fig] = fb.psth_fb(groupdata(i).signal, groupdata(i).time,groupdata(i).(events{1}), -20, 50, 0, events{1});
    groupdata(i).psth_infusion_avg = mean(groupdata(i).psth_infusion, 2, 'omitmissing');
    groupdata(i).psth_infusion_time = mean(psth_time, 2, 'omitmissing');
end
%% get all the behaivors
filelist = dir('*_ThreeHoursSessions.mat');
behavioraldata = [];
for i = 1:length(filelist)
    filename = filelist(i).name;
    groupdata(i).behavior = load(filelist(i).name);
end

%% plot the behaivoral data
baf = behavior_analysis_func;
for i = 1:length(groupdata)
    dataRaw = groupdata(i).behavior.summarydata;
    training_protocol = dataRaw.training;
    recording_index = find(contains(training_protocol, 'Ephys'));
    shock_session     = find(contains(training_protocol, 'shock'));
    summarydata(i).animalID = dataRaw.subject{1};
    summarydata(i).data = dataRaw;
    summarydata(i).recording_index = recording_index;
    summarydata(i).shock_session     = shock_session;
end
[x_index, subdata] = baf.line_plot_MA_align_punishment(summarydata, 'Reward');
ylabel('Infusion #')
% print(gcf, '-dtiff', 'Infusion_individual.tiff');
baf.line_plot_MA_align_punishment(summarydata, "activeLeverPress")
% print(gcf, '-dtiff', 'leverPress_individual.tiff');

baf.line_plot_MA_align_punishment(summarydata, "activeLeverPress-Cue")


Reward = baf.avg_align_punishement(subdata, x_index, 'Reward');
activeLever = baf.avg_align_punishement(subdata, x_index, 'activeLeverPress');
inactiveLever = baf.avg_align_punishement(subdata, x_index, 'inactiveLeverPress');

% extract the summary of reward for groupdata
for i = 1:length(groupdata)
    groupdata(i).reward.infusion = mean(Reward(1:3, i));
    groupdata(i).reward.infusion_punishment = mean(Reward(4:6, i));
    groupdata(i).reward.infusion_reinstatment = Reward(7, i);

end

figure
hold on
rectangle('Position',[3.5, 0, 3, 100], 'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'none');
text(3.9, 90, 'Punishment', 'FontSize', 12, 'Color', 'r')
text(3.6, 85, '0.2 mA Shock', 'FontSize',12)
baf.line_plot_errorbar(Reward', 'k', 'Infusion #')
xlim([0, 8])
plot([0.5, 3.5], [105, 105], 'Color', [221,28,119]/255, 'LineWidth',2)
text(1, 110, 'Cocaine', 'FontSize', 14, 'Color', [221,28,119]/255, 'FontWeight','bold')
plot([6.5, 7.5], [105, 105], 'Color', [49,163,84]/255, 'LineWidth',2)
text(6.2, 110, 'Saline', 'FontSize', 14, 'Color', [49,163,84]/255, 'FontWeight','bold')
saveas(gcf, ['summary_cocaine_shock_reinstatement_Infusion.pdf'])


figure
hold on
rectangle('Position',[3.5, 0, 3, 100], 'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'none');
text(3.9, 90, 'Punishment', 'FontSize', 12, 'Color', 'r')
text(3.6, 85, '0.2 mA Shock', 'FontSize',12)
baf.line_plot_errorbar(activeLever', [215,25,28]/255, 'Lever Press #')
xlim([0, 8])
plot([0.5, 3.5], [105, 105], 'Color', [221,28,119]/255, 'LineWidth',2)
text(1, 110, 'Cocaine', 'FontSize', 14, 'Color', [221,28,119]/255, 'FontWeight','bold')
plot([6.5, 7.5], [105, 105], 'Color', [49,163,84]/255, 'LineWidth',2)
text(6.2, 110, 'Saline', 'FontSize', 14, 'Color', [49,163,84]/255, 'FontWeight','bold')
baf.line_plot_errorbar(inactiveLever', [44,123,182]/255, 'Lever Press #')
xlim([0, 8])
saveas(gcf, ['summary_Fentanyl_shock_reinstatement_leverPress.pdf'])

%% only plot the last session before shock, the last session of shock and reinstatment
index = [3,6, 7]
reward_sub = Reward(index, :);
activeLever_sub = activeLever(index, :);
inactiveLever_sub = inactiveLever(index,:);
figure
baf.line_plot_errorbar(activeLever_sub', [215,25,28]/255, 'Lever Press #')
hold on
% baf.line_plot_errorbar(inactiveLever_sub',  [44,123,182]/255, 'Lever Press #')
xlim([0, 4])
hold on
plot(activeLever_sub, 'k')

figure
baf.line_plot_errorbar(reward_sub', 'k', 'Infusion #')
hold on
% baf.line_plot_errorbar(inactiveLever_sub',  [44,123,182]/255, 'Lever Press #')
xlim([0, 4])
hold on
plot(reward_sub, 'color',[0.1, 0.1, 0.1])

reward_taking = mean(Reward(1:3, :), 1);
reward_punish = mean(Reward(4:6, :), 1);
reward_reinstatement = Reward(7, :);
figure
baf.line_plot_errorbar([reward_taking;reward_punish;reward_reinstatement]', 'k', 'Average Infusion #')
hold on
xlim([0, 4])
plot([reward_taking;reward_punish;reward_reinstatement], 'color',[0.1, 0.1, 0.1])


activeLever_taking = mean(activeLever(1:3, :), 1);
activeLever_punish = mean(activeLever(4:6, :), 1);
activeLever_reinstatement = activeLever(7, :);
figure
baf.line_plot_errorbar([activeLever_taking;activeLever_punish;activeLever_reinstatement]', [215,25,28]/255, 'Average Lever Press #')
hold on
xlim([0, 4])
plot([activeLever_taking;activeLever_punish;activeLever_reinstatement], 'color',[0.1, 0.1, 0.1])


%% try to cluster behaviors
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
cluster_id = baf.hierarchical_cluster([resistence, reinstatment]);
% figure;
% cluster_id = baf.hierarchical_cluster(reward_summary);
colors = cbrewer2('div', 'RdYlBu', 4);

figure;
scatter(resistence(cluster_id==1), reinstatment(cluster_id ==1), 'MarkerFaceColor',colors(1, :), 'MarkerEdgeColor','w')
hold on
scatter(resistence(cluster_id==2), reinstatment(cluster_id ==2), 'MarkerFaceColor',colors(2, :), 'MarkerEdgeColor','w')
scatter(resistence(cluster_id==3), reinstatment(cluster_id ==3), 'MarkerFaceColor',colors(3, :), 'MarkerEdgeColor','w')
scatter(resistence(cluster_id==4), reinstatment(cluster_id ==4), 'MarkerFaceColor',colors(4, :), 'MarkerEdgeColor','w')

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
cluster_01 = reward_summary(cluster_id == 1,:);
cluster_02 = reward_summary(cluster_id == 2,:);
cluster_03 = reward_summary(cluster_id == 3,:);
cluster_04 = reward_summary(cluster_id == 4,:);

label_id = {'Fentanyl', 'Fentanyl + Punishment', 'Saline'}
for i = 1:3
    subplot(1, 3, i)
    i = i
    mean_value_01 = mean(cluster_01(:, i));
    mean_value_02 = mean(cluster_02(:, i));
    mean_value_03 = mean(cluster_03(:, i));
    mean_value_04 = mean(cluster_04(:, i));

    sem_value_01 = std(cluster_01(:, i))/length(cluster_01(:, i));
    sem_value_02 = std(cluster_02(:, i))/length(cluster_02(:, i));
    sem_value_03 = std(cluster_03(:, i))/length(cluster_03(:, i));
    sem_value_04 = std(cluster_04(:, i))/length(cluster_04(:, i));

    b = bar([mean_value_01, mean_value_02, mean_value_03, mean_value_04]);
    b.FaceColor = 'flat';
    b.CData(1,:) = colors(1, :);
    b.CData(2,:) = colors(2, :);
    b.CData(3,:) = colors(3, :);
    b.CData(3,:) = colors(4, :);
    hold on

    errorbar([mean_value_01, mean_value_02, mean_value_03, mean_value_04], ...
        [sem_value_01, sem_value_02, sem_value_03, sem_value_04],'k.', 'LineWidth', 1.5, 'CapSize',20)
    
    scatter(1 + 0.3* (rand(size(cluster_01(:, i)))-0.5), cluster_01(:, i), 'k', 'MarkerFaceColor','k')
    scatter(2 + 0.3* (rand(size(cluster_02(:, i)))-0.5), cluster_02(:, i), 'k', 'MarkerFaceColor','k')
    scatter(3 + 0.3* (rand(size(cluster_03(:, i)))-0.5), cluster_03(:, i), 'k', 'MarkerFaceColor','k')
    scatter(4 + 0.3* (rand(size(cluster_04(:, i)))-0.5), cluster_04(:, i), 'k', 'MarkerFaceColor','k')
    xlabel('Cluster #');
    ylabel('Infusion #');
    title(label_id{i})
    % ttest2()
end
% save cluster info to the dataset
for i = 1:length(groupdata)
    groupdata(i).cluster.resistence = resistence(i);
    groupdata(i).cluster.reinstatement = reinstatment(i);
    groupdata(i).cluster.cluster       = cluster_id(i);
end
%%
%% calculate behavioral parameters for each animal
% for each session there are following parameters to consider: number of infusion, number of active pressing, number of
% inactive pressing; reaction time for pressing, reaction time for active
% pressing; inter-press interval
for i = 1:length(groupdata)
    n_session = size(groupdata(i).behavior.summarydata, 1);
    training_session = char(groupdata(i).behavior.summarydata.training(1));
    if strcmp(training_session(1), 'B') 
        activelever_label = 'back_lever';
        inactivelever_label = 'front_lever';
    elseif strcmp(training_session(1), 'F') 

        activelever_label = 'front_lever';
        inactivelever_label = 'back_lever';
    else
        error('There is something wrong')
    end

    % only calculate the parameters for reinstatement sessions
    j = n_session;
    cue = unique(groupdata(i).behavior.timestamps(j).cue);
    active_lever = groupdata(i).behavior.timestamps(j).(activelever_label);
    inactive_lever = groupdata(i).behavior.timestamps(j).(inactivelever_label);
    reward = groupdata(i).behavior.timestamps(j).reward;
    if length(cue)>1
        [reaction_active, reaction_inactive, reaction_infusion] = SA_perievent_raster_plot(cue,active_lever, inactive_lever, reward);

    else
        reaction_active = active_lever(1);
        reaction_inactive  = active_lever(1);
    end
    lever_pressing_ipi = diff(sort([active_lever, inactive_lever]));
    groupdata(i).reaction_active = reaction_active;
    groupdata(i).reaction_inactive  = reaction_inactive;
    groupdata(i).reaction_infusion =reaction_infusion;
    groupdata(i).ipi_all   = lever_pressing_ipi;
    groupdata(i).ipi_active = diff(active_lever);
    groupdata(i).ipi_inactive = diff(inactive_lever);
    

end
%% plot the average psth for each animal
psth_summary_avg =  [];
psth_summary_time = [];
figure;
for i = 1:length(groupdata)
    plot(groupdata(i).psth_infusion_time, groupdata(i).psth_infusion_avg)
    hold on
    psth_summary_avg(:, i) = groupdata(i).psth_infusion_avg;
    psth_summary_time(:, i) = groupdata(i).psth_infusion_time;
end
psth_summary_time = mean(psth_summary_time,2, 'omitmissing');
figure; 
imagesc(psth_summary_time, [], psth_summary_avg')
colormap(jet)
% calculate the average responses 
%% based on cluster
psth_cluster_01 = psth_summary_avg(:, cluster_id == 1);
psth_cluster_02 = psth_summary_avg(:, cluster_id == 2);
psth_cluster_03 = psth_summary_avg(:, cluster_id == 3);
psth_cluster_04 = psth_summary_avg(:, cluster_id == 4);
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
colors = cbrewer('div', 'RdYlBu', 4);
fb = fb_extract_doric;
h1 = fb.boundedline_plot(psth_summary_time, psth_cluster_01, colors(1,:));
hold on
h2 = fb.boundedline_plot(psth_summary_time, psth_cluster_02, colors(2,:));
h3 = fb.boundedline_plot(psth_summary_time, psth_cluster_03, colors(3,:));
h4 = fb.boundedline_plot(psth_summary_time, psth_cluster_04, colors(4,:));
ylim([-1, 2.5])
legend([h1, h2, h3, h4], {'Cluster # 1', 'Cluster # 2','Cluster # 3', 'Cluster #4'})

% Only select mice with at least 10 infusions recorded
% index = [];
% trial_counts = [];
% for i = 1: length(psth_summary)
%     if size(psth_summary{i},2)>=10
%         index = [index, i];
%        trial_counts = [trial_counts, size(psth_summary{i},2)];
%     end
% end
% 
% [trial_counts_sort, sort_index] = sort(trial_counts);
% psth_time_avg_infusion10 = psth_summary_avg(:, index(sort_index));

% Plot the average psth aligned to the infusion
% figure;
% subplot(2, 1, 1)
% fb.boundedline_plot(psth_time_avg, psth_time_avg_infusion10, [1, 0, 0])
% ylim([-1, 2])
% subplot(2, 1, 2)
% imagesc(psth_time_avg, [], psth_time_avg_infusion10')
% colormap('jet')
% clim([-1, 3])
% xlabel('Time (s)')
% ylabel('Animal #')
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% box off
% set(gcf,'position',[100,100,900,400])

%% Construct the blinking cues similar to the psth
% light off starts at 0 and lasts for 0.5 s, and light on for 1 s
% there are 13 blinks in total; after the last off, the light stays off

lights = 1 * ones(size(psth_summary_time));

for i = 1:14
    off_on(i,:) = [0, 0.5]  + 1.5 * (i-1);
end
off_on(14, 2) = 40; % a new trials starts

for i = 1:14
    indx = find(psth_summary_time>off_on(i, 1) & psth_summary_time<off_on(i, 2));
    lights(indx) = -1;
end
figure;
plot(psth_summary_time, lights, 'k')
xlabel('Time (s)')
ylabel('Lights')
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gca,'YTick',-1:2:1)
set(gca, 'YTickLabel', {'OFF', 'ON'})
ylim([-2, 2])
box off
set(gcf,'position',[100,100,900,200])

%% check one signal with the blinking signals
fb = fb_extract_doric;
% psth_cluster_03(:, any(isnan(psth_cluster_03), 1)) = [];
% [peak_cross, peak_lags, power] = fb.cross_correlation_power_analysis([psth_cluster_01, ...
%     psth_cluster_02, ...
%     psth_cluster_03], ...
%     psth_summary_time, lights);
for i = 1:length(groupdata)
    groupdata(i).reinstatment = reinstatment(i);
    groupdata(i).resistence   = resistence(i);
    groupdata(i).cluster_id   = cluster_id(i);
    if ~isempty(groupdata(i).psth_infusion)
    [groupdata(i).peak_cross, groupdata(i).peak_lags, groupdata(i).power] = ...
        fb.cross_correlation_power_analysis(groupdata(i).psth_infusion_avg, ...
        groupdata(i).psth_infusion_time, lights);
    else
        groupdata(i).peak_cross = NaN;
        groupdata(i).peak_lags  = NaN;
        groupdata(i).power      = NaN;
    end

end
%%
% check the summary of power spectrum analysis
psth_cluster_03(:, any(isnan(psth_cluster_03), 1)) = [];
[peak_cross, peak_lags, power] = fb.cross_correlation_power_analysis([psth_cluster_01, ...
    psth_cluster_02, ...
    psth_cluster_03], ...
    psth_summary_time, lights);
power_01 = power(1, 1:size(cluster_01,1));
power_02 = power(1, (size(cluster_01,1) + 1):(size(cluster_01,1) + size(cluster_02,1)));
power_03 = power(1, (size(cluster_01,1) + size(cluster_02,1) + 1):end);

% check the summary of cross-correlation
peak_cross_01 = peak_cross(1, 1:size(cluster_01,1));
peak_cross_02 = peak_cross(1, (size(cluster_01,1) + 1):(size(cluster_01,1) + size(cluster_02,1)));
peak_cross_03 = peak_cross(1, (size(cluster_01,1) + size(cluster_02,1) + 1):end);
% plot cross-correlation and power
figure
scatter(peak_cross_01,power_01,  'MarkerFaceColor',color1, 'MarkerEdgeColor','w')
hold on
scatter(peak_cross_02,power_02,  'MarkerFaceColor',color2, 'MarkerEdgeColor','w')
scatter(peak_cross_03,power_03,  'MarkerFaceColor',color3, 'MarkerEdgeColor','w')
hold on
xlabel('cross-correlation coeffiency')
ylabel('Power')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)

figure
fb.bar_plot_three(power_01, power_02, power_03);
xlabel('Cluster #');
ylabel('Power #');
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
box off
fb.anova1_three(power_01, power_02, power_03)

figure
fb.bar_plot_three(peak_cross_01, peak_cross_02, peak_cross_03);
xlabel('Cluster #');
ylabel('Power #');
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
box off
fb.anova1_three(peak_cross_01, peak_cross_02, peak_cross_03)

%%
figure;
scatter(power_01, reinstatment(cluster_id == 1),  'MarkerFaceColor',color1, 'MarkerEdgeColor','w')
hold on
scatter(power_02, reinstatment(cluster_id == 2),  'MarkerFaceColor',color2, 'MarkerEdgeColor','w')


%% check the response amplitude
time = psth_summary_time;
pre02 = find(time>-10 & time < -5);
pre01 = find(time>-5 & time < 0);
post01 = find(time> 0 & time < 5);
post02 = find(time> 5 & time < 10);
post03 = find(time> 10 & time < 15);
post04 = find(time> 15 & time < 19);

amp02_cluster01  = trapz(time(pre02), psth_cluster_01(pre02, :));
amp01_cluster01  = trapz(time(pre01), psth_cluster_01(pre01, :));
post_amp01_cluster01  = trapz(time(post01), psth_cluster_01(post01, :));
post_amp02_cluster01  = trapz(time(post02), psth_cluster_01(post02, :));
post_amp03_cluster01  = trapz(time(post03), psth_cluster_01(post03, :));
post_amp04_cluster01  = trapz(time(post04), psth_cluster_01(post04, :));

amp_cluster01 = [amp02_cluster01; amp01_cluster01; post_amp01_cluster01;...
    post_amp02_cluster01;post_amp03_cluster01;post_amp04_cluster01];

amp02_cluster02  = trapz(time(pre02), psth_cluster_02(pre02, :));
amp01_cluster02  = trapz(time(pre01), psth_cluster_02(pre01, :));
post_amp01_cluster02  = trapz(time(post01), psth_cluster_02(post01, :));
post_amp02_cluster02  = trapz(time(post02), psth_cluster_02(post02, :));
post_amp03_cluster02  = trapz(time(post03), psth_cluster_02(post03, :));
post_amp04_cluster02  = trapz(time(post04), psth_cluster_02(post04, :));

amp_cluster02 = [amp02_cluster02; amp01_cluster02; post_amp01_cluster02;...
    post_amp02_cluster02;post_amp03_cluster02;post_amp04_cluster02];

amp02_cluster03  = trapz(time(pre02), psth_cluster_03(pre02, :));
amp01_cluster03  = trapz(time(pre01), psth_cluster_03(pre01, :));
post_amp01_cluster03  = trapz(time(post01), psth_cluster_03(post01, :));
post_amp02_cluster03  = trapz(time(post02), psth_cluster_03(post02, :));
post_amp03_cluster03  = trapz(time(post03), psth_cluster_03(post03, :));
post_amp04_cluster03  = trapz(time(post04), psth_cluster_03(post04, :));

amp_cluster03 = [amp02_cluster03; amp01_cluster03; post_amp01_cluster03;...
    post_amp02_cluster03;post_amp03_cluster03;post_amp04_cluster03];

figure;

baf.line_plot_errorbar (amp_cluster01', [215,25,28]/255,'AUC Z-score')
hold on
baf.line_plot_errorbar (amp_cluster02', [253,174,97]/255,'AUC Z-score')
baf.line_plot_errorbar (amp_cluster03', [44,123,182]/255,'AUC Z-score')
xlim([0, 7])
xticks([1, 2, 3, 4, 5, 6])
xticklabels({'(-10, -5)','(-5, 0)','(0 - 5)', '(5, 10)', '(10, 15)', '(15, 20)'})
xlabel('Time relative to Infusion (s)')

figure;

baf.line_plot_errorbar((amp_cluster01(2:end, :) - amp_cluster01(2,:))', [215,25,28]/255,' Normalized AUC Z-score')
hold on
baf.line_plot_errorbar ((amp_cluster02(2:end, :) - amp_cluster02(2,:))', [253,174,97]/255,'Normalized AUC Z-score')
baf.line_plot_errorbar ((amp_cluster03(2:end, :) - amp_cluster03(2,:))', [44,123,182]/255,'Normalized AUC Z-score')
xlim([0, 6])
xticks([1, 2, 3, 4, 5])
xticklabels({'(-5, 0)', '(0 - 5)', '(5, 10)', '(10, 15)', '(15, 20)'})
xlabel('Time relative to Infusion (s)')

% get the bar plot showing the changes
figure
delt_amp_cluster01 = amp_cluster01(3, :) - amp_cluster01(2,:);
delt_amp_cluster02 = amp_cluster02(3, :) - amp_cluster02(2,:);
delt_amp_cluster03 = amp_cluster03(3, :) - amp_cluster03(2,:);

fb.bar_plot_three(delt_amp_cluster01, delt_amp_cluster02, delt_amp_cluster03)
xlabel('Cluster #');
ylabel('Normalized Delta AUC');

% get the bar plot showing the dacay
figure
decay_amp_cluster01 = amp_cluster01(4, :)./amp_cluster01(3, :);
decay_amp_cluster02 = amp_cluster02(4, :)./amp_cluster02(3, :);
decay_amp_cluster03 = amp_cluster03(4, :)./amp_cluster03(3, :);

fb.bar_plot_three(decay_amp_cluster01, decay_amp_cluster02, decay_amp_cluster03)
xlabel('Cluster #');
ylabel('Decay from the peak');
% anova test

fb.anova1_three(decay_amp_cluster01, decay_amp_cluster02, decay_amp_cluster03)
fb.anova1_three(delt_amp_cluster01, delt_amp_cluster02, delt_amp_cluster03)

% let's try to get the baseline activity


%% Let's apply this analysis to each trial
fb = fb_extract_doric;
for i = 1:length(groupdata)
    if ~isempty(groupdata(i).psth_infusion)
    [groupdata(i).trial.peak_cross, groupdata(i).trial.peak_lags, groupdata(i).trial.power, groupdata(i).trial.all_power, groupdata(i).trial.all_f] = fb.cross_correlation_power_analysis(groupdata(i).psth_infusion, ...
        psth_summary_time, lights);
    end
end

% calculate response amplitude and baseline for each trial
time = psth_summary_time;
pre02 = find(time>-10 & time < -5);
pre01 = find(time>-5 & time < 0);
post01 = find(time> 0 & time < 5);
for i = 1:length(groupdata)
    if ~isempty(groupdata(i).psth_infusion)
        groupdata(i).trial.pre_amp01  = trapz(time(pre01), groupdata(i).psth_infusion(pre01, :));
        groupdata(i).trial.post_amp01  = trapz(time(post01), groupdata(i).psth_infusion(post01, :));
        groupdata(i).trial.delta_amp  = groupdata(i).trial.post_amp01 - groupdata(i).trial.pre_amp01 ;
    end
end

%%
power = groupdata(16).trial.power';
pre_amp = groupdata(16).trial.pre_amp01';
post_amp = groupdata(16).trial.post_amp01';
delta_amp = groupdata(16).trial.delta_amp';
data = table(power, pre_amp, post_amp, delta_amp);
figure;
corrplot(data)
%%
%% analysis of lever press responses
% for each session there are following parameters to consider: number of infusion, number of active pressing, number of
% inactive pressing; reaction time for pressing, reaction time for active
% pressing; inter-press interval
fb = fb_extract_doric;
for j = 1:length(groupdata);
    training_session = char(groupdata(j).behavior.summarydata.training(1));
    if strcmp(training_session(1), 'B')
        activelever_label = 'back';
        inactivelever_label = 'front';
    elseif strcmp(training_session(1), 'F')

        activelever_label = 'front';
        inactivelever_label = 'back';
    else
        error('There is something wrong')
    end

    activeLever = groupdata(j).(activelever_label);
    inactiveLever = groupdata(j).(inactivelever_label);
    n_activeLever = length(activeLever);
    dist_lever = []
    onset_lever = [];
    offset_lever = [];
    thresh = 2 ;
    for i = 1:(n_activeLever-1)
        if i ==1
            if activeLever(i+1) > activeLever(i)+thresh
                dist_lever = [dist_lever, i];
            else
                onset_lever = [onset_lever, i];
            end


        else
            if activeLever(i+1) > activeLever(i)+thresh && activeLever(i)> activeLever(i-1)+thresh
                dist_lever = [dist_lever, i];
            elseif activeLever(i+1) > activeLever(i)+thresh && activeLever(i)< activeLever(i-1)+thresh
                offset_lever = [offset_lever, i];
            elseif activeLever(i+1) < activeLever(i)+thresh && activeLever(i)> activeLever(i-1)+thresh
                onset_lever = [onset_lever, i];
            end
        end
    end

    % find lever press before infusion
    leverInsertion = groupdata(j).leverInsertion;
    infusion = groupdata(j).infusion;
    session = [0,30*60;...
        60*60, 90*60; 120*60, 150*60]; % record every 30 min
    data_perSession = []
    for k = 1:size(session, 1)
        data_perSession(k).leverInsertion = leverInsertion(find(leverInsertion>session(k, 1) & leverInsertion<session(k, 2)));
        data_perSession(k).infusion = infusion(find(infusion>session(k, 1) & infusion<session(k, 2)));
        data_perSession(k).activeLever = activeLever(find(activeLever>session(k, 1) & activeLever<session(k, 2)));
        data_perSession(k).inactiveLever = inactiveLever(find(inactiveLever>session(k, 1) & inactiveLever<session(k, 2)))
    % lets only analyze data for a full trial structure, lever insertion,
    % lever press, infusion and retraction
        if length(data_perSession(k).leverInsertion) > length(data_perSession(k).infusion)
            data_perSession(k).leverInsertion_c = data_perSession(k).leverInsertion(1:end-1);
            data_perSession(k).infusion_c       = data_perSession(k).infusion;
        elseif length(data_perSession(k).leverInsertion) < length(data_perSession(k).infusion)
            data_perSession(k).leverInsertion_c = data_perSession(k).leverInsertion;
            data_perSession(k).infusion_c       = data_perSession(k).infusion(2:end);
        elseif length(data_perSession(k).leverInsertion) == length(data_perSession(k).infusion)
            try
                if data_perSession(k).leverInsertion(1) < data_perSession(k).infusion(1)
                    data_perSession(k).leverInsertion_c = data_perSession(k).leverInsertion;
                    data_perSession(k).infusion_c       = data_perSession(k).infusion;
                else
                    data_perSession(k).leverInsertion_c = data_perSession(k).leverInsertion(1:end-1);
                    data_perSession(k).infusion_c       = data_perSession(k).infusion(2:end);
                end
            catch
            end
        end
        if ~isempty(groupdata(j).infusion) && ~ isempty(data_perSession(k).infusion_c)
            [data_perSession(k).infusion_time, data_perSession(k).psth_infusion, fig] = fb.psth_fb(groupdata(j).signal, groupdata(j).time, data_perSession(k).infusion_c, -20, 50, 1, 'Infusion');
        end

    end

    groupdata(j).data_perSession = data_perSession;
    %     k = 1;
    %     m = 1;
    %     for i = 1:length(infusion)
    % 
    %         if leverInsertion(m) < session(k) && infusion(i) < session(k)
    %             indx = min(find(infusion>leverInsertion(m)));
    %             if isempty(indx)
    %             else
    %                 leverPress_trial{i} = find(activeLever>leverInsertion(m) & activeLever < infusion(indx) + 20)';
    %             end
    %             m = m+1;
    %         else
    %             k = k+1;
    %         end
    % 
    % 
    %     end
    % end
    % lever_beforeInfusion = cell2mat(leverPress_trial);

    % first_lever_press =[];
    % lever_count = [];
    % for i = 1:length(leverPress_trial)
    %     if ~isempty(leverPress_trial{i})
    %         first_lever_press(i) = leverPress_trial{i}(1);
    %         lever_count(i)       = length(leverPress_trial{i});
    %     else
    %         first_lever_press(i) = NaN;
    %         lever_count(i)       = NaN;
    %     end
    % end

    % first_lever_press(isnan(first_lever_press)) = [];
    % for i = 1:length(first_lever_press)
    %     if ~isnan(first_lever_press(i))
    %         groupdata(j).first_lever_press_timing(i) = activeLever(first_lever_press(i));
    %     else
    %         groupdata(j).first_lever_press_timing(i) = NaN;
    %     end
    % 
    % end
    % groupdata(j).lever_count_per_trial = lever_count;
    % for i = 1:length(groupdata)
    %     data_for_psth(i).signal = groupdata(i).signal;
    %     data_for_psth(i).time   = groupdata(i).time;
    % end
    % save('cocaine_reinstatement_fb_signal_time.mat', 'data_for_psth')

   
    % lever_beforeInfusion = lever_beforeInfusion(:);
    % lever_single = intersect(lever_beforeInfusion, dist_lever);
    % lever_bout_onset = intersect(lever_beforeInfusion, onset_lever);
    % groupdata(j).lever_single = activeLever(lever_single);
    % groupdata(j).lever_bout_onset = activeLever(lever_bout_onset);
end
%% Let's check the change of dopamine dynamics across trials
for j = 1:length(groupdata)
    for k = 1:length(groupdata(j).data_perSession)
        if isempty(groupdata(j).data_perSession(k).infusion_c)
            groupdata(j).data_perSession(k).perievent = [];
            groupdata(j).data_perSession(k).reaction_time = [];
        else
        [groupdata(j).data_perSession(k).perievent, groupdata(j).data_perSession(k).reaction_time] = SA_perievent_raster_plot(groupdata(j).data_perSession(k).leverInsertion_c', ...
            groupdata(j).data_perSession(k).activeLever(:)', groupdata(j).data_perSession(k).inactiveLever(:)', ...
            groupdata(j).data_perSession(k).infusion_c');
        end
    end
end
%% Plot PSTH aligned to drug infusion
for j = 1:length(groupdata)
    if ~isempty(groupdata(j).lever_single)
    [~,~, fig1] = fb.psth_fb(data_for_psth(j).signal, data_for_psth(j).time,groupdata(j).first_lever_press_timing, -5, 5, 1, '1st Lever Press');
    set(gcf,'position',[100,100,250,400])
    caxis([-2, 5])

    % [~,~, fig1] = fb.psth_fb(data_for_psth(j).signal, data_for_psth(j).time,groupdata(j).lever_single, -5, 5, 1, 'Single Lever Press');
    % set(gcf,'position',[100,100,250,400])
    % caxis([-2, 5])

    % [~,~, fig1] = fb.psth_fb(data_for_psth(j).signal, data_for_psth(j).time,groupdata(j).lever_bout_onset, -5, 5, 1, 'Onset Bout ActiveLever');
    % set(gcf,'position',[100,100,250,400])
    % caxis([-2, 5])
    end
end
%%
% calculate the area under the curve
for i = 1:length(groupdata)
    for k = 1:3
        if ~isempty(groupdata(i).data_perSession(k).infusion_c)
            time = groupdata(i).data_perSession(k).infusion_time;
            psth = groupdata(i).data_perSession(k).psth_infusion;
            for j = 1:size(time, 2)
                if isnan(time(1, j))
                    groupdata(i).data_perSession(k).pre_amp01(j) = NaN;
                    groupdata(i).data_perSession(k).post_amp01(j) = NaN;
                else

                    pre01 = find(time(:, j)>-5 & time(:, j) < 0);
                    post01 = find(time(:,j)> 0 & time(:, j) < 5);
                    groupdata(i).data_perSession(k).pre_amp01(j)  = trapz(time(pre01, j), psth(pre01, j));
                    groupdata(i).data_perSession(k).post_amp01(j)  = trapz(time(post01, j), psth(post01, j));
                end
                groupdata(i).data_perSession(k).delta_amp(j)  = groupdata(i).data_perSession(k).post_amp01(j) - groupdata(i).data_perSession(k).pre_amp01(j);
            end
        end
    end
end
%%
for i = 1: 18
    figure;
    color1 = [215,25,28]/255;
    color2 = [253,174,97]/255;
    color3 = [44,123,182]/255;
    hold on
    try
        scatter(groupdata(i).data_perSession(1).delta_amp, groupdata(i).data_perSession(1).reaction_time.infusion, ...
            'MarkerFaceColor', color1, 'MarkerEdgeColor', 'w')
    catch
    end
    try
        scatter(groupdata(i).data_perSession(2).delta_amp, groupdata(i).data_perSession(2).reaction_time.infusion, ...
            'MarkerFaceColor', color2, 'MarkerEdgeColor', 'w')
    catch
    end
    try
        scatter(groupdata(i).data_perSession(3).delta_amp, groupdata(i).data_perSession(3).reaction_time.infusion, ...
            'MarkerFaceColor',color3, 'MarkerEdgeColor', 'w')
    catch
    end
end
%%
for i = 1:18
    figure;
    color1 = [215,25,28]/255;
    color2 = [253,174,97]/255;
    color3 = [44,123,182]/255;
    hold on
    try
        scatter(groupdata(i).data_perSession(1).delta_amp, groupdata(i).data_perSession(1).reaction_time.active, ...
            'MarkerFaceColor', color1, 'MarkerEdgeColor', 'w')
    catch
    end
    try
        scatter(groupdata(i).data_perSession(2).delta_amp, groupdata(i).data_perSession(2).reaction_time.active, ...
            'MarkerFaceColor', color2, 'MarkerEdgeColor', 'w')
    catch
    end
    try
        scatter(groupdata(i).data_perSession(3).delta_amp, groupdata(i).data_perSession(3).reaction_time.active, ...
            'MarkerFaceColor',color3, 'MarkerEdgeColor', 'w')
    catch
    end
end
%%
%%
for i = 1:18
    figure;
    color1 = [215,25,28]/255;
    color2 = [253,174,97]/255;
    color3 = [44,123,182]/255;
    hold on
    try
        scatter(groupdata(i).data_perSession(1).delta_amp, groupdata(i).data_perSession(1).reaction_time.infusion - ...
            groupdata(i).data_perSession(1).reaction_time.active, ...
            'MarkerFaceColor', color1, 'MarkerEdgeColor', 'w')
    catch
    end
    try
        scatter(groupdata(i).data_perSession(2).delta_amp, groupdata(i).data_perSession(2).reaction_time.infusion - ...
            groupdata(i).data_perSession(2).reaction_time.active, ...
            'MarkerFaceColor', color2, 'MarkerEdgeColor', 'w')
    catch
    end
    try
        scatter(groupdata(i).data_perSession(3).delta_amp, groupdata(i).data_perSession(3).reaction_time.infusion - ...
            groupdata(i).data_perSession(3).reaction_time.active, ...
            'MarkerFaceColor',color3, 'MarkerEdgeColor', 'w')
    catch
    end
end

%%
%%
for i = 1:18
    % figure;
    color1 = [215,25,28]/255;
    color2 = [253,174,97]/255;
    color3 = [44,123,182]/255;
    hold on
    lever_counts = [];
    for k = 1:3
        try
            lever = groupdata(i).data_perSession(k).perievent.active;
            inactivelever = groupdata(i).data_perSession(k).perievent.inactive;
            for j = 1:length(lever)
                groupdata(i).data_perSession(k).activelever_counts(j) = length(lever(j).times);
                if isempty(inactivelever(j).times)
                    groupdata(i).data_perSession(k).inactivelever_counts(j) = 0;
                else
                    groupdata(i).data_perSession(k).inactivelever_counts(j) = length(inactivelever(j).times);
                end
            end
        catch
        end
    end
    % scatter(groupdata(i).data_perSession(1).delta_amp, lever_counts, ...
    %     'MarkerFaceColor', color1, 'MarkerEdgeColor', 'w')

end



%% find the leverInsertion responoses
% Let's check the change of dopamine dynamics across trials aligned to
% lever Insertion
for j = 1:length(groupdata)
    for k = 1:length(groupdata(j).data_perSession)
        if ~isempty(groupdata(j).data_perSession(k).leverInsertion) && ~ isempty(groupdata(j).data_perSession(k).leverInsertion_c)
            [groupdata(j).data_perSession(k).lever_time, groupdata(j).data_perSession(k).psth_leverInsertion, fig] = fb.psth_fb(groupdata(j).signal, groupdata(j).time, groupdata(j).data_perSession(k).leverInsertion_c, -20, 20, 1, 'Lever Insertion');
        end
    end
end


% Plot PSTH aligned to drug infusion
% [~,~, fig1] = fb.psth_fb(summarydata(j).signal, summarydata(j).time,activeLever(lever_bout_onset), -5, 5, 1, 'Onset Bout ActiveLever');
% set(gcf,'position',[100,100,250,400])
% caxis([-2, 5])

%% start summary plot for trial-tiral analysis
% 1. how responses change over time
figure
j = 2;
k = 3;
delta_amp = groupdata(j).data_perSession(k).delta_amp(:);
infusion_time = groupdata(j).data_perSession(k).reaction_time.infusion(:);
activeLever = groupdata(j).data_perSession(k).activelever_counts(:);
inactiveLever = groupdata(j).data_perSession(k).inactivelever_counts(:);
data = table(delta_amp, infusion_time, activeLever, inactiveLever);
corrplot(data)
%% let's plot the change of response over trials
figure
for j = 1:length(groupdata)
    try
        figure(j)
        for k = 1:3
            subplot(1,3,k)
            plot(groupdata(j).data_perSession(k).delta_amp(:));
            ylim([-2, 12])
            ylabel('Delta AUC')
            xlabel('Trial #')
            title(['Sessions', ' ', num2str(k)] )
        end
    catch
    end
end
%
animalID = [1, 2, 4, 5, 7, 8, 13, 15, 16, 18]; % these are the animal that have data recorded in all three sessions
variance= [];
amplitude = [];
trial_counts = [];
for i = 1:length(animalID)
    for k = 1:3
        amp = groupdata(animalID(i)).data_perSession(k).delta_amp(:);
        nan_idex = find(isnan(amp));
        
        if ~isempty(nan_idex)
            amp(nan_idex) = [];
        end
        amplitude(i, k) = mean(amp);
        variance(i, k)  = std(amp);
        trial_counts(i, k) = length(amp);
    end
end

figure
colors = cbrewer('div', 'RdYlBu', 10)
for i = 1:size(amplitude, 1)
    scatter(trial_counts(i,:), amplitude(i, :), 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', 'w')
    hold on
    plot(trial_counts(i,:), amplitude(i, :), 'color', colors(i,:))
end
xlabel('trial counts per Session')
ylabel('average delta AUC')

% only look at the first 30 min session
animalID = [1, 2, 4, 5,6, 7, 8, 13, 15, 16, 18]; % these are the animal that have data recorded in all three sessions
figure
colors = cbrewer('div', 'RdYlBu', 10)
for i = 1:length(animalID)
    amp = groupdata(animalID(i)).data_perSession(1).delta_amp(:);
    amp(isnan(amp)) = [];
    data_for_plot(i).animalID = animalID(i);
    data_for_plot(i).names    = groupdata(animalID(i)).animalID;
    data_for_plot(i).amp = mean(amp);
    data_for_plot(i).trial = length(amp);
    scatter(length(amp), mean(amp), 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'w')
    hold on
    % plot(trial_counts(i,:), amplitude(i, :), 'color', colors(i,:))
end
xlabel('trial counts per Session')
ylabel('average delta AUC')

mdl = fitlm(trial_counts(:), amplitude(:));
figure
plot(mdl)
ylabel('average delta AUC')
xlabel('Trial Counts')
mdl
coefficients = [];

animalID = [1, 2, 3, 4, 5,6, 7, 8,9,10,11,12 13,14, 15, 16, 17,18]; % these are the animal that have data recorded in all three sessions
for i = 1:length(animalID)
        amp = groupdata(animalID(i)).data_perSession(1).delta_amp(:);
        amp(isnan(amp)) = [];
        x = 1:length(amp);
        y = amp;
        amplitude01{i} = amp;
        mdl = fitlm(x, y);
        figure(i)
        plot(mdl)
        ylabel('average delta AUC')
        xlabel('Trial Counts')
        coefficients(:, i) = mdl.Coefficients.Estimate;

end

fano = variance.^2 ./amplitude;
%% let's see the baseline activity: did not see any things pop out
%#1 activity in the inter-trial interval
i = 4
k =1
% figure; plot(groupdata(i).data_perSession(k).lever_time, groupdata(i).data_perSession(k).psth_leverInsertion)
% figure; plot(groupdata(i).data_perSession(k).lever_time(:,2), groupdata(i).data_perSession(k).psth_leverInsertion(:,2))
figure; imagesc(mean(groupdata(i).data_perSession(k).lever_time,2, 'omitmissing'), [], groupdata(i).data_perSession(k).psth_leverInsertion')
colormap(jet)
% sort based on reaction time
reaction_time = groupdata(i).data_perSession(k).reaction_time.infusion;
[B, I] = sort(reaction_time);
figure; imagesc(mean(groupdata(i).data_perSession(k).lever_time,2, 'omitmissing'), [], groupdata(i).data_perSession(k).psth_leverInsertion(:,I)')
colormap(jet)
%#2 activity from the insertion of lever to the drug infusion
%% let analyze the punishment session

%% make some master plot script
load('H:\Dropbox\Dropbox\Wang Lab\LabMeeting\Cocaine SA summary\Photometry_Data\Taking_Analysis\cocaine_taking_fb_small_file.mat')

%% plot the raw psth data across trials 
fb = fb_extract_doric;
time_avg = [];
psth_avg = [];
for i= 1:length(groupdata)
    [time_avg(:, i), psth_avg(:, i)] = fb.groupplot_psth_individual_infusion(groupdata, i);
    
end
set(gcf,'position',[100,100,600,600])

%% plot psth across mice
fb.groupplot_psth_avg(time_avg, psth_avg)
set(gcf,'position',[100,100,600,600])

%% sort the psth acoording to the responses
resp = [];
baseline = [];
for i = 1:length(groupdata)
    resp_index = find(time_avg(:, i) >0 & time_avg(:,i) < 1);
    resp2_index = find(time_avg(:, i)>0 & time_avg(:, i)< 20);
    baseline_index = find(time_avg(:, i)>-1 & time_avg(:, i)< 0);
    baseline(i) = mean(psth_avg(baseline_index, i));
    resp(i) = mean(psth_avg(resp_index, i) - baseline(i));
    resp2(i) = mean(psth_avg(resp2_index, i)-baseline(i));
end

% figure; scatter(resp, resistence)
% hold on
% scatter(resp(cluster_id==1), resistence(cluster_id ==1), 'MarkerFaceColor',[215,25,28]/255, 'MarkerEdgeColor','w')
% hold on
% scatter(resp(cluster_id==2), resistence(cluster_id ==2), 'MarkerFaceColor',[253,174,97]/255, 'MarkerEdgeColor','w')
% scatter(resp(cluster_id==3), resistence(cluster_id ==3), 'MarkerFaceColor',[44,123,182]/255, 'MarkerEdgeColor','w')
% ylim([0, 0.8])
% xlim([-1, 2.5])
% xlabel('Dopamine')
% ylabel('Resistence Score')
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf,'position',[100,100,400,400])
% 
% %
% mdl = fitlm(resp, resistence);
% figure
% h1 = plot(mdl)
% ylim([0, 0.8])
% xlim([-1, 2.5])
% xlabel('Dopamine')
% ylabel('Resistence Score')
% box off
% set(gca,'TickDir','out')
% set(gca,'fontsize',12)
% set(gca,'TickLengt', [0.015 0.015]);
% set(gca, 'LineWidth',1)
% set(gcf,'position',[100,100,400,400])

%% figure; scatter(resp, resp2)
[B, I] = sort(resp, 'ascend');

% soerted population psth,and normalized z-score
sort_psth_avg = psth_avg(:, I) - baseline(I);
sort_time_avg = time_avg(:, I);
fb.groupplot_psth_avg(sort_time_avg, sort_psth_avg)
set(gcf,'position',[100,100,600,600])
%%
% data.punishment.unsort_psth_avg = psth_avg;
data.punishment.sort = I;
data.punishment.resp_index = resp_index;
data.punishment.psth_avg = psth_avg -baseline;
data.punishment.resp = resp;
data.punishment.cluster = cluster_id;
data.punishment.resistence = resistence;
data.punishment.time_avg = time_avg;
data.punishment.psth_avg_nonnorm = psth_avg;

data.taking.psth_avg = psth_avg-baseline;
data.taking.time_avg = time_avg;
data.taking.resp = resp;
data.taking.resp2 = resp2;
data.taking.psth_avg_nonnorm = psth_avg;
%% find the behaivoral for the taking and punishment session
for i = 1:length(groupdata)
    date = groupdata(i).date;
    key = date(1:4)
    for j = 1:size(groupdata(i).behavior.summarydata, 1)
       if contains(groupdata(i).behavior.summarydata.date{j}, key)
           disp(num2str(j))
           break
       end
    end
    groupdata(i).infusion_count = groupdata(i).behavior.summarydata.Reward(j);
    groupdata(i).active = groupdata(i).behavior.summarydata.activeLeverPress(j);
end

data.taking.unsort_infusion = [groupdata.infusion_count];
data.taking.unsort_active = [groupdata.active];


data.punishment.unsort_infusion = [groupdata.infusion_count];
data.punishment.unsort_active = [groupdata.active];
%%
mdl = fb.correlaiton_analysis_cluster(data.punishment.resp, data.punishment.unsort_infusion, data.punishment.cluster)
ylim([0, 120])
xlim([-1, 3])

mdl = fb.correlaiton_analysis_cluster(data.punishment.resp, data.punishment.resistence, data.punishment.cluster)
xlim([-1, 3])
%%
data.diff.psth_avg = data.punishment.psth_avg - data.taking.psth_avg;

I = data.punishment.sort;
data.diff.infusion = data.punishment.unsort_infusion - data.taking.unsort_infusion;
data.diff.active = data.punishment.unsort_active - data.taking.unsort_active;
fb.groupplot_psth_avg(sort_time_avg, data.diff.psth_avg(:, I))

resp_index = data.punishment.resp_index;
figure;
% scatter(mean(data.diff.sorted_psth_avg(resp_index, :)), data.diff.sorted_infusion)
% mdl = fitlm(mean(data.diff.sorted_psth_avg(resp_index, :)), data.diff.sorted_infusion);
% figure
% h1 = plot(mdl)
% ylabel('Delta Infusion')
% xlabel('Delta Dopamine (0-1 s)')
% mdl
mdl = fb.correlaiton_analysis_cluster(mean(data.diff.psth_avg(resp_index, :)), data.diff.infusion, data.punishment.cluster)
ylim([-80, 80])
xlim([-2, 2])


mdl = fb.correlaiton_analysis_cluster(mean(data.diff.psth_avg(resp_index, :)), data.punishment.resistence, data.punishment.cluster)
% ylim([-120, 60])
xlim([-2, 2])

mdl = fb.correlaiton_analysis_cluster(mean(data.diff.psth_avg(resp_index, :)), data.diff.active, data.punishment.cluster)
ylim([-800, 1000])
xlim([-2, 2])

%% population psth based on clusterID
%% based on cluster
cluster = data.punishment.cluster;
clusterID = unique(cluster);

% plot pupulation dopamine psth
figure
colors = cbrewer('div', 'RdYlBu', 4);
fb = fb_extract_doric;
time = mean(data.taking.time_avg, 2);
for i = 1:length(clusterID)
    cluster_index = find(cluster == i);
    psth_cluster = data.taking.psth_avg(:, cluster_index);
    h(i) = fb.boundedline_plot(time, psth_cluster, colors(i,:));
end
set(gcf,'position',[100,100,500,300])
ylim([-1, 2.5])
xlim([-10, 50])
% legend([h(1), h(2), h3, h4], {'Cluster # 1', 'Cluster # 2','Cluster # 3', 'Cluster #4'})
%% plot the resp based on cluster
figure
colors = cbrewer('div', 'RdYlBu', 4);
for i = 1:length(clusterID)
    cluster_index = find(cluster == i);
    resp_cluster{i} = data.punishment.resp(:, cluster_index)';
    mean_resp = mean(resp_cluster{i});
    sem_resp = std(resp_cluster{i})/sqrt(length(resp_cluster{i}));
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

%% Perform stats
[~, ~, stats] = anova1(data.punishment.resp', data.punishment.cluster)
[c,~,~,gnames] = multcompare(stats);

%%
%% plot the resp based on cluster
figure
colors = cbrewer('div', 'RdYlBu', 4);
resp = [];
resp2 = [];
for i = 1:length(data.punishment.cluster)
    psth_avg = data.punishment.psth_avg;
    time_avg = data.punishment.time_avg;
    resp_index = find(time_avg(:, i) >0 & time_avg(:,i) < 1);
    resp2_index = find(time_avg(:, i)>0 & time_avg(:, i)< 20);
    baseline_index = find(time_avg(:, i)>-1 & time_avg(:, i)< 0);
    baseline(i) = mean(psth_avg(baseline_index, i));
    resp(i) = mean(psth_avg(resp_index, i) - baseline(i));
    resp2(i) = mean(psth_avg(resp2_index, i)-baseline(i));
end
data.punishment.resp2 = resp2;

for i = 1:length(clusterID)
    cluster_index = find(cluster == i);
    resp_cluster{i} = resp2(cluster_index)';
    mean_resp = mean(resp_cluster{i});
    sem_resp = std(resp_cluster{i})/sqrt(length(resp_cluster{i}));
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
set(gcf,'position',[100,100,300,300]);

%% Perform stats
[~, ~, stats] = anova1(resp2,cluster)

[c,~,~,gnames] = multcompare(stats);
%%
mdl = fb.correlaiton_analysis_cluster(data.punishment.resp, data.punishment.unsort_infusion, data.punishment.cluster)
ylim([0, 140])
xlim([-1, 5])

%%
mdl = fb.correlaiton_analysis_cluster(resp2, data.punishment.resistence, data.punishment.cluster)
ylim([0, 0.6])
xlim([-1, 5])

%%

data.diff.infusion = data.punishment.unsort_infusion - data.taking.unsort_infusion;
data.diff.active = data.punishment.unsort_active - data.taking.unsort_active;
data.diff.resp2 = data.punishment.resp2 - data.taking.resp2;
data.diff.resp = data.punishment.resp - data.taking.resp;
%%
mdl = fb.correlaiton_analysis_cluster(data.diff.resp2, data.diff.infusion, data.punishment.cluster)
ylim([-100, 80])
xlim([-1, 4])
%%
mdl = fb.correlaiton_analysis_cluster(data.diff.resp2, data.punishment.resistence, data.punishment.cluster)
ylim([0, 0.6])
xlim([-1, 4])