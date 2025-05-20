% In your summary folder, summarize all data into a single file
clear; clc
% go the data folder
cd("/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/raw_data/Cocaine_ThreeHoursSessions")
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
    % add information about patency: SA81, SA110 and SA150 lost patency, tested before perfusion
    if strcmp(summary_testing(i).animalID, 'sa81')| strcmp(summary_testing(i).animalID, 'sa110') | strcmp(summary_testing(i).animalID, 'SA150')
        summary_testing(i).patency = false;
    else
        summary_testing(i).patency = true;
    end

end
cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data')
save('Cocaine_testing_summary.mat', 'summary_testing')
%% plot the lever press and infusion counts
% clear; close all; clc;
baf = behavior_analysis_func;
% cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data')
% load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_testing_summary.mat')
summary_testing = summary_testing([summary_testing.patency]);
% plot the data drug infusion;
data_plot = [];
% only plot the 3 sessions of baseline, 3 sessions of punishments and 1
% sessions of Saline
for i = 1:length(summary_testing)
    shock_session = summary_testing(i).shock_session;
    index_to_plot = (shock_session(1) - 3) : (shock_session(end) + 1);  % only plot the 3 sessions of baseline, 3 sessions of punishement and 1 sessions of Saline
    if max(summary_testing(i).recording_index) < max(shock_session) % no reinstatement session
        data_plot.activeLever(:, i)   = [summary_testing(i).data.activeLeverPress(index_to_plot(1:end-1)); NaN];
        data_plot.inactiveLever(:, i) = [summary_testing(i).data.inactiveLeverPress(index_to_plot(1:end-1)); NaN];
        data_plot.infusion(:,i)       = [summary_testing(i).data.Reward(index_to_plot(1:end-1)); NaN];
    else
        data_plot.activeLever(:, i)   = summary_testing(i).data.activeLeverPress(index_to_plot);
        data_plot.inactiveLever(:, i) = summary_testing(i).data.inactiveLeverPress(index_to_plot);
        data_plot.infusion(:,i)       = summary_testing(i).data.Reward(index_to_plot);
    end
end

save('Cocaine_testing_summary.mat', 'summary_testing', 'data_plot')

%% plot the active and inactive lever press
cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1')
figure
subplot(1, 2, 1)
rectangle('Position',[3.5, 1, 3, 600], 'FaceColor', [0, 0, 0], 'EdgeColor', 'none','FaceAlpha', 0.1);
hold on
baf.line_plot_MA_avg(data_plot.activeLever', data_plot.inactiveLever')
xlabel('Testing Sessions')
xlim([0, 8])
set(gcf,'position',[100,100,500,250])
text(3.7, 580, 'Punishment', 'FontSize', 12, 'Color', 'r')
text(3.6, 530, '0.2 mA Shock', 'FontSize',12)
ylim([0, 800])
hold on
plot([0.8, 6.5], [625, 625], 'Color', [221,28,119]/255, 'LineWidth',2)
text(3, 655, 'Cocaine', 'FontSize', 12, 'Color', [221,28,119]/255, 'FontWeight','bold')
plot([6.5, 7.5], [625, 625], 'Color', [49,163,84]/255, 'LineWidth',2)
text(6.5, 655, 'Saline', 'FontSize', 12, 'Color', [49,163,84]/255, 'FontWeight','bold')
hold on 
legend('off')
% saveas(gcf, 'Cocaine_Testing_LeverPress.pdf');
%% plot the infusion counts
subplot(1, 2, 2)
rectangle('Position',[3.5, 1, 3, 90], 'FaceColor', [0, 0, 0], 'EdgeColor', 'none', 'FaceAlpha', 0.1);
hold on
baf.line_plot_errorbar(data_plot.infusion','k', 'Infusions')
xlabel('Testing Sessions')
hold on
% plot(data_plot.infusion, 'Color', [0.8, 0.8, 0.8])
xlim([0, 8])
% format figure

set(gcf,'position',[500,100,500,250])
text(3.7, 87, 'Punishment', 'FontSize', 12, 'Color', 'r')
text(3.6, 80, '0.2 mA Shock', 'FontSize',12)
ylim([0, 120])
hold on
plot([0.8, 6.5], [95, 95], 'Color', [221,28,119]/255, 'LineWidth',2)
text(3, 100, 'Cocaine', 'FontSize', 12, 'Color', [221,28,119]/255, 'FontWeight','bold')
plot([6.5, 7.5], [95, 95], 'Color', [49,163,84]/255, 'LineWidth',2)
text(6.5, 100, 'Saline', 'FontSize', 12, 'Color', [49,163,84]/255, 'FontWeight','bold')
hold on
%
% saveas(gcf, 'Cocaine_testing_Infusion.pdf');
