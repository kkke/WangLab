figure;
directory = pwd;
files = dir([pwd, '\*.mat']);
data = [];
for i = 1:length(files)
    data{i} = load(files(i).name);
end
%%
figure;
for i = 1:length(data)
    h = plot(data{i}.summarydata.Reward, '-o');
    hold on
    set(h, 'LineWidth', 1)
    set(h, 'MarkerFaceColor', 'w')
    ylabel('Infusion #')

    box off
end
xlabel('Time (s)', 'FontSize', 12)
ylabel('Infusion #')
% set(gca, 'XTickDir', 'out')
box off
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
ylim([0, 150])
rectangle('Position', [3.5, 0, 3, 140])
rectangle('Position', [9.5, 0, 3, 140])
xlim([0, 13])



%%
figure;
for i = 1:length(data)
    h = plot(data{i}.summarydata.activeLeverPress, '-o');
    hold on
    set(h, 'LineWidth', 1)
    set(h, 'MarkerFaceColor', 'w')
    box off
end
xlabel('Time (s)', 'FontSize', 12)
ylabel('Active Lever Press #')
% set(gca, 'XTickDir', 'out')
box off
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
ylim([0, 2000])
rectangle('Position', [3.5, 0, 3, 140])
rectangle('Position', [9.5, 0, 3, 140])
xlim([0, 13])

%% normalize the response
%%
figure;
for i = 1:length(data)
    h = plot(data{i}.summarydata.Reward/mean(data{i}.summarydata.Reward(1:3)), '-o');
    hold on
    set(h, 'LineWidth', 1)
    set(h, 'MarkerFaceColor', 'w')
    ylabel('Infusion #')

    box off
end
xlabel('Time (s)', 'FontSize', 12)
ylabel('Normalized Infusion #')
% set(gca, 'XTickDir', 'out')
box off
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
ylim([0, 3])
rectangle('Position', [3.5, 0, 3, 3])
rectangle('Position', [9.5, 0, 3, 3])
xlim([0, 13])

%%
%%
figure;
for i = 1:length(data)
    h = plot(data{i}.summarydata.activeLeverPress/mean(data{i}.summarydata.activeLeverPress(1:3)), '-o');
    hold on
    set(h, 'LineWidth', 1)
    set(h, 'MarkerFaceColor', 'w')
    box off
end
xlabel('Time (s)', 'FontSize', 12)
ylabel('Normalized Active Lever Press #')
% set(gca, 'XTickDir', 'out')
box off
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
ylim([0, 6])
rectangle('Position', [3.5, 0, 3, 6])
rectangle('Position', [9.5, 0, 3, 6])
xlim([0, 13])

%% average 
figure;
for i = 1:length(data)
    average_val =[];
    for j = 0:3
        average_val(j+1) = mean(data{i}.summarydata.activeLeverPress((3*j + 1):(3*j + 3)));
    end
    h = plot(average_val, '-o');
    hold on
    set(h, 'LineWidth', 1)
    set(h, 'MarkerFaceColor', 'w')
    ylabel('Infusion #')

    box off
    
end
xlabel('Time (s)', 'FontSize', 12)
ylabel('Normalized Infusion #')
% set(gca, 'XTickDir', 'out')
box off
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
ylim([0, 150])
rectangle('Position', [1.5, 0, 1, 140])
rectangle('Position', [3.5, 0, 1, 140])
xlim([0, 5])