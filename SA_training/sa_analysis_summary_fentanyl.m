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
%% save data
data = data_sum;
% save('LeverPress_summary.mat', 'data')
%% find the autoshaping, PR, and shock session
for i = 1:length(data)
    training_protocol = data{i}.training;
    autoshaping_index = find(contains(training_protocol, 'KC_Auto Shaping'));
    shaping_6h        = find(contains(training_protocol, '6h_FR1_KC'));
    concentration_3   = find(data{i}.Concentration ==3);
    summarydata(i).animalID = data{i}.subject{i};
    summarydata(i).data = data{i};
    summarydata(i).autoshaping_index = autoshaping_index;
    summarydata(i).shaping_6h        = shaping_6h;
    summarydata(i).concentration_3   = concentration_3; 
end
%% save the summary data
save('LeverPress_fentanyl_summary.mat', 'summarydata')

%% plot the data drug infusion;
colors = cbrewer('div', 'RdYlBu', 6);

figure
legend_handles = [];
legend_labels  = {};
for i = 1 : length(summarydata)
    start_index = max(summarydata(i).shaping_6h)+1;
    end_index = max(summarydata(i).concentration_3);
    subdata_training = summarydata(i).data(start_index:end_index,:);
    h(i) = plot(subdata_training.Reward , '-o', color = colors(i,:));
    hold on
    set(h(i), 'LineWidth', 1)
    set(h(i), 'MarkerFaceColor', 'w')
    legend_handles = [legend_handles, h(i)];
    legend_labels  = {legend_labels{:}, subdata_training.subject{1}};
end
legend(legend_handles, legend_labels)

ylabel('Fentanyl Infusion #')
xlabel('Session #')
set(gca,'XTick',0:2:31)
ylim([0, 50])
xlim([0,31])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
%%
figure
colors = cbrewer('div', 'RdYlBu', 6);
for i = 1 : length(summarydata)
    subplot(1, 3, i)
    start_index = max(summarydata(i).shaping_6h)+1;
    end_index = max(summarydata(i).concentration_3);
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
    ylabel('Lever Press For Fentanyl #')
    xlabel('Training Session')
    set(gca,'XTick',0:2:31)
    xlim([0,31])
    ylim([0, 400])
    box off
    set(gca,'TickDir','out')
    set(gca,'fontsize',12)
    set(gca,'TickLengt', [0.015 0.015]);
    set(gca, 'LineWidth',1)    
end
set(gcf,'position',[100,100,1200,300])

%% plot the Infusion count


%% reorganize data for plotting; 6 weeks training
clear subdata
subdata{1} = data_sum{8}(4:end, :);
subdata{2} = data_sum{9}(4:end, :);
subdata{3} = data_sum{10}(4:end, :);
activeLever = [];
inactiveLever = [];
reward = [];
for i = 1:length(subdata)
    activeLever = [activeLever, subdata{i}.activeLeverPress];
    inactiveLever = [inactiveLever, subdata{i}.inactiveLeverPress];
    reward = [reward, subdata{i}.Reward];
end

colors = cbrewer('div', 'RdYlBu', 6);
figure
h1 = plot(activeLever(:,1), '-o', color = colors(1,:));
hold on
h2 = plot(activeLever(:,2), '-o', color = colors(2,:));

h3 = plot(inactiveLever(:, 1), '-o', color = colors(6,:));
h4 = plot(inactiveLever(:, 2), '-o', color = colors(5,:));

set(h1, 'LineWidth', 1)
set(h1, 'MarkerFaceColor', 'w')
set(h2, 'LineWidth', 1)
set(h2, 'MarkerFaceColor', 'w')
set(h3, 'LineWidth', 1)
set(h3, 'MarkerFaceColor', 'w')
set(h4, 'LineWidth', 1)
set(h4, 'MarkerFaceColor', 'w')
% legend([h1, h2], {'Active Lever', 'Inactive Lever'})
ylabel('Lever Press #')
set(gca,'XTick',0:5:30)
xlim([0,30])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,600,400])
legend([h1, h2, h3, h4], {'Active Lever Mouse#1', 'Active Lever Mouse#1', ...
    'Inactive Lever Mouse#1', 'Inactive Lever Mouse#1',})
xlabel('Session #')

xlim([0, 12])
ylim([0, 300])
set(gcf,'position',[100,100,400,400])
%% plot infusion count
figure
h1 = plot(reward(:,1), '-o', color = colors(1,:));
hold on
h2 = plot(reward(:,2), '-o', color = colors(2,:));


set(h1, 'LineWidth', 1)
set(h1, 'MarkerFaceColor', 'w')
set(h2, 'LineWidth', 1)
set(h2, 'MarkerFaceColor', 'w')

% legend([h1, h2], {'Active Lever', 'Inactive Lever'})
ylabel('Infusion #')
set(gca,'XTick',0:5:30)
xlim([0,30])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
legend([h1, h2], {'Mouse#1', 'Mouse#2'})
xlabel('Session #')

%% plot Active lever press during time out
activeLever_Cue = [];

for i = 1:length(subdata)
    activeLever_Cue = [activeLever_Cue, subdata{i}.activeLeverPress_Cue];
end

figure
h1 = plot(activeLever_Cue(:,1), '-o', color = colors(1,:));
hold on
h2 = plot(activeLever_Cue(:,2), '-o', color = colors(2,:));


set(h1, 'LineWidth', 1)
set(h1, 'MarkerFaceColor', 'w')
set(h2, 'LineWidth', 1)
set(h2, 'MarkerFaceColor', 'w')

% legend([h1, h2], {'Active Lever', 'Inactive Lever'})
ylabel('Active Lever Press # During Timeout')
set(gca,'XTick',0:5:30)
xlim([0,30])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
legend([h1, h2], {'Mouse#1', 'Mouse#2'})
xlabel('Session #')
