% load data
clear; close all; clc
% datafolder = 'D:\Project_Master_Folder\Self-Administration\data'
datafolder = pwd;
files = dir([datafolder, '\*.csv'])

cd(datafolder)
for i = 1:length(files)
    data_sum{i} = readtable(files(i).name);
end
%% refill some information
for j = 1:length(data_sum)
    for i = 1: size(data_sum{j},1)
        data_sum{j}.genotype{i} = 'Hets';
    end
end
%% save data
data = data_sum;
% save('LeverPress_summary.mat', 'data')
%% find the autoshaping, PR, and shock session
for i = 1:length(data)
    training_protocol = data{i}.training;
    autoshaping_index = find(contains(training_protocol, 'KC_Auto Shaping'));
    shaping_6h        = find(contains(training_protocol, '6h_FR1_KC'));
    PR_session        = find(contains(training_protocol, 'PR_Self-Admin'));
    shock_session     = find(contains(training_protocol, 'shock'));
    summarydata(i).animalID = data{i}.subject{i};
    summarydata(i).genotype = data{i}.genotype{1};
    summarydata(i).data = data{i};
    summarydata(i).autoshaping_index = autoshaping_index;
    summarydata(i).shaping_6h        = shaping_6h;
    summarydata(i).PR_session        = PR_session;
    summarydata(i).shock_session     = shock_session;
end
%% plot PR ratio test: last PR ratio met and totoal active and inactive lever
% Load PR_ratio.txt with Import Data module
for i = 1:length(summarydata)
    pr_session = summarydata(i).data(summarydata(i).PR_session,:);
    reward_pr_session = pr_session.Reward;
end
%% save the summary data

save('LeverPress_summary.mat', 'summarydata')
%% plot the data drug infusion;
colors = cbrewer('div', 'RdYlBu', 6);

figure
legend_handles = [];
legend_labels  = {};
for i = 1 : length(summarydata)
    start_index = max(summarydata(i).shaping_6h)+1;
    end_index = summarydata(i).PR_session -1 ;
    subdata_training = summarydata(i).data(start_index:end_index,:);
    h(i) = plot(subdata_training.Reward , '-o', color = colors(i,:));
    hold on
    set(h(i), 'LineWidth', 1)
    set(h(i), 'MarkerFaceColor', 'w')
    legend_handles = [legend_handles, h(i)];
    legend_labels  = {legend_labels{:}, subdata_training.subject{1}};
end
legend(legend_handles, legend_labels)

ylabel('Infusion #')
xlabel('Session #')
set(gca,'XTick',0:2:31)
xlim([0,31])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,600,400])
%% plot active and inacive lever press for each individual mouse: Training session
colors = cbrewer('div', 'RdYlBu', 6);
for i = 1 : length(summarydata)
    subplot(2, 3, i)
    start_index = max(summarydata(i).shaping_6h)+1;
    end_index = summarydata(i).PR_session -1 ;
    subdata_training = summarydata(i).data(start_index:end_index,:);
    h(1) = plot(subdata_training.activeLeverPress , '-o', color = colors(1,:));
    hold on
    h(2) = plot(subdata_training.inactiveLeverPress , '-o', color = colors(6,:))
    set(h(1), 'LineWidth', 1)
    set(h(1), 'MarkerFaceColor', 'w')
    set(h(2), 'LineWidth', 1)
    set(h(2), 'MarkerFaceColor', 'w')
    title(subdata_training.subject{1})
    legend([h(1), h(2)], {'Active', 'Inactive'})
    ylabel('Lever Press #')
    xlabel('Training Session')
    set(gca,'XTick',0:2:31)
    xlim([0,31])
    ylim([0, 900])
    box off
    set(gca,'TickDir','out')
    set(gca,'fontsize',12)
    set(gca,'TickLengt', [0.015 0.015]);
    set(gca, 'LineWidth',1)    
end
set(gcf,'position',[100,100,1200,700])



%% Convert to output type
PRratio1 = table2array(PRratio1);
%% plot the Infusion during footshock session
colors = cbrewer('div', 'RdYlBu', 6);
figure
rectangle('Position', [2.5, 0, 12, 150], 'FaceColor', [0.5,0.5, 0.5, 0.5], 'EdgeColor', 'none')
hold on
legend_handles = [];
legend_labels  = {};
for i = 1 : length(summarydata)
    start_index = min(summarydata(i).shock_session)-2;
    end_index = max(summarydata(i).shock_session);
    subdata_training = summarydata(i).data(start_index:end_index,:);
    h(i) = plot(subdata_training.Reward , '-o', color = colors(i,:));
    hold on
    set(h(i), 'LineWidth', 1)
    set(h(i), 'MarkerFaceColor', 'w')
    legend_handles = [legend_handles, h(i)];
    legend_labels  = {legend_labels{:}, subdata_training.subject{1}};
end
legend(legend_handles, legend_labels)

ylabel('Infusion #')
xlabel('Session #')
set(gca,'XTick',0:2:15)
xlim([0,15])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])

%% plot the Lever Pressing during the footshock session
colors = cbrewer('div', 'RdYlBu', 6);
figure
hold on
for i = 1 : length(summarydata)
    subplot(2, 3, i)
    rectangle('Position', [2.5, 0, 12, 600], 'FaceColor', [0.5,0.5, 0.5, 0.5], 'EdgeColor', 'none')
    hold on
    start_index = min(summarydata(i).shock_session)-2;
    end_index = max(summarydata(i).shock_session);
    subdata_training = summarydata(i).data(start_index:end_index,:);
    h(1) = plot(subdata_training.activeLeverPress , '-o', color = colors(1,:));
    hold on
    h(2) = plot(subdata_training.inactiveLeverPress , '-o', color = colors(6,:))
    set(h(1), 'LineWidth', 1)
    set(h(1), 'MarkerFaceColor', 'w')
    set(h(2), 'LineWidth', 1)
    set(h(2), 'MarkerFaceColor', 'w')
    title(subdata_training.subject{1})
    legend([h(1), h(2)], {'Active', 'Inactive'})
    ylabel('Lever Press #')
    xlabel('Training Session')
    set(gca,'XTick',0:2:15)
    xlim([0,15])
%     ylim([0, 600])
    box off
    set(gca,'TickDir','out')
    set(gca,'fontsize',12)
    set(gca,'TickLengt', [0.015 0.015]);
    set(gca, 'LineWidth',1) 
end
set(gcf,'position',[100,100,1200,700])
%% plot the Lever Pressing before footshock, last seesion of footshock and Reinstatement
% Let's summarize the data
% 1st acquisition phase (27 sessions)
figure
legend_handles = [];
legend_labels  = {};
data_acquisition = [];
for i = 1 : length(summarydata)
    start_index = max(summarydata(i).shaping_6h)+1;
    end_index = start_index + 27-1;
    data_acquistion{i} = summarydata(i).data(start_index:end_index,:);
    h(i) = plot(data_acquistion{i}.Reward , '-o', color = colors(i,:));
    hold on
    set(h(i), 'LineWidth', 1)
    set(h(i), 'MarkerFaceColor', 'w')
    legend_handles = [legend_handles, h(i)];
    legend_labels  = {legend_labels{:}, data_acquistion{i}.subject{1}};
end
legend(legend_handles, legend_labels)
ylabel('Infusion #')
xlabel('Session #')
set(gca,'XTick',0:2:31)
xlim([0,31])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,600,400])

%summaryplot
acquisition_activeLever = [];
acquisition_inactiveLever =[];
acquisition_reward =[];
for i = 1:length(data_acquistion)
    acquisition_activeLever = [acquisition_activeLever, data_acquistion{i}.activeLeverPress];
    acquisition_inactiveLever = [acquisition_inactiveLever, data_acquistion{i}.inactiveLeverPress];
    acquisition_reward = [acquisition_reward, data_acquistion{i}.Reward];
end
figure
line_errorbar_drc(acquisition_activeLever', acquisition_inactiveLever')
ylim([0,400])
xlim([0, 28])

%2nd lever press during footshock
colors = cbrewer('div', 'RdYlBu', 6);
figure
hold on
for i = 1 : length(summarydata)
    subplot(2, 3, i)
    rectangle('Position', [2.5, 0, 12, 600], 'FaceColor', [0.5,0.5, 0.5, 0.5], 'EdgeColor', 'none')
    hold on
    start_index = min(summarydata(i).shock_session)-2;
    end_index = max(summarydata(i).shock_session);
    shock_training{i} = summarydata(i).data(start_index:end_index,:);
    h(1) = plot(shock_training{i}.activeLeverPress , '-o', color = colors(1,:));
    hold on
    h(2) = plot(shock_training{i}.inactiveLeverPress , '-o', color = colors(6,:))
    set(h(1), 'LineWidth', 1)
    set(h(1), 'MarkerFaceColor', 'w')
    set(h(2), 'LineWidth', 1)
    set(h(2), 'MarkerFaceColor', 'w')
    title(shock_training{i}.subject{1})
    legend([h(1), h(2)], {'Active', 'Inactive'})
    ylabel('Lever Press #')
    xlabel('Training Session')
    set(gca,'XTick',0:2:15)
    xlim([0,15])
%     ylim([0, 600])
    box off
    set(gca,'TickDir','out')
    set(gca,'fontsize',12)
    set(gca,'TickLengt', [0.015 0.015]);
    set(gca, 'LineWidth',1) 
end
set(gcf,'position',[100,100,1200,700])


%summaryplot
shock_activeLever = [];
shock_inactiveLever =[];
shock_reward =[];
for i = 1:length(data_acquistion)
    shock_activeLever = [shock_activeLever, shock_training{i}.activeLeverPress];
    shock_inactiveLever = [shock_inactiveLever, shock_training{i}.inactiveLeverPress];
    shock_reward = [shock_reward, shock_training{i}.Reward];
end
% first group averaged
n_avg = size(shock_activeLever, 1)/2;
for i = 1:n_avg
    index = (i-1)*2 + 1;
    avg_shock_activeLever(i,:) = (shock_activeLever(index,:) + shock_activeLever(index+1,:))/2;
    avg_shock_inactiveLever(i,:) = (shock_inactiveLever(index,:) + shock_inactiveLever(index+1,:))/2;
    avg_shock_reward(i,:) = (shock_reward(index,:) + shock_reward(index+1,:))/2;
end

currentIntensity = [0:0.05:0.3];
% figure
% plot(currentIntensity, avg_shock_activeLever)
figure;
h =  plot(currentIntensity, avg_shock_activeLever./avg_shock_activeLever(1,:), '-o', color = colors(1,:))
set(h, 'LineWidth', 1)
set(h, 'MarkerFaceColor', 'w')
xlabel('Current Intensity (mA)')
ylabel('Normalized Lever Press')    
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)

%% save important plotting variables
hets.data_acquisition = data_acquisition;
hets.shock_training   = shock_training;
hets.currentIntensity = currentIntensity;
hets.avg_shock_activeLever = avg_shock_activeLever;
hets.avg_shock_inactivelever = avg_shock_inactiveLever;
hets.avg_shock_reward        = avg_shock_reward;
save('hets_plots.mat', 'hets')
