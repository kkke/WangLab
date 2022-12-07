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
save('LeverPress_summary.mat', 'data')
%% find the autoshaping session
for i = 1:length(data)
    training_protocol = data{i}.training;
    autoshaping_index = find(contains(training_protocol, 'KC_Auto Shaping'));
    shaping_6h        = find(contains(training_protocol, '6h_FR1_KC'));
    PR_session        = find(contains(training_protocol, 'PR_Self-Admin'));
    shock_session     = find(contains(training_protocol, 'shock'));
    summarydata(i).animalID = data{i}.subject{i};
    summarydata(i).data = data{i};
    summarydata(i).autoshaping_index = autoshaping_index;
    summarydata(i).shaping_6h        = shaping_6h;
    summarydata(i).PR_session        = PR_session;
    summarydata(i).shock_session     = shock_session;
end
%% for sapap3 foot shock plotting

subdata{1} = data_sum{2}(32:end, :);
subdata{2} = data_sum{3}(31:end, :);
subdata{3} = data_sum{4}(31:end,:);
subdata{4} = data_sum{1}(34:end,:);
colors = cbrewer('div', 'RdYlBu', 4);
figure
for i = 1 : length(subdata)
    h(i) = plot(subdata{i}.Reward , '-o', color = colors(i,:));
    hold on
    set(h(i), 'LineWidth', 1)
    set(h(i), 'MarkerFaceColor', 'w')
end
legend([h(1), h(2), h(3), h(4)], {'SSA45', 'SSA46', 'SSA47', 'SSA40'})
ylabel('Infusion #')
set(gca,'XTick',0:2:20)
xlim([0,20])
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
%% reorganize data for plotting; 3 weeks training
subdata{1}= data_sum{1}(6:17, :);
subdata{2} = data_sum{2}(5:16, :);
subdata{3} = data_sum{3}(6:17,:);
subdata{4} = data_sum{4}(4:15,:);
subdata{5} = data_sum{5}(4:15,:);
subdata{6} = data_sum{6}(4:15,:);
control{1} = data_sum{7}(4:15,:);

activeLever = [];
inactiveLever = [];
reward = [];
for i = 1:length(subdata)
    activeLever = [activeLever, subdata{i}.activeLeverPress];
    inactiveLever = [inactiveLever, subdata{i}.inactiveLeverPress];
    reward = [reward, subdata{i}.Reward];
end
figure
line_errorbar_drc(activeLever', inactiveLever')
ylim([0,300])
figure
line_errorbar_drc(control{1}.activeLeverPress', control{1}.inactiveLeverPress')
ylim([0,300])
%% plot the Infusion count
figure;
line_errorbar_drc(reward', control{1}.Reward', 'Cocaine', 'Saline')
ylabel('Infusion #')
ylim([0,80])

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
