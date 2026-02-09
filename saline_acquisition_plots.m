% In your summary folder, summarize all data into a single file
clear; clc
% go the data folder
% cd('C:\Users\KeChen\MIT Dropbox\Ke Chen\Wang Lab\Manuscripts\DA_Cocaine_Fentanyl\Figures\Figure1\Data\Cocaine_Acquisition')
cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/raw_data/Saline_Acquisition')
files = dir('*Acquisition_data.mat');
% contruct a summary dictionary containing all data 
summary_acquisition = [];
for i = 1:length(files)
    load(files(i).name)
    summary_acquisition(i).animalID = upper(summarydata.subject{1});
    summary_acquisition(i).data = summarydata;
    summary_acquisition(i).FR_value = unique(summarydata.FR);
    summary_acquisition(i).FR1 = find(summarydata.FR == 1);
    summary_acquisition(i).FR2 = find(summarydata.FR == 2);
    summary_acquisition(i).FR4 = find(summarydata.FR == 4);
    % add information about patency: SA81, SA110 and SA150 lost patency, tested before perfusion
    if strcmp(summary_acquisition(i).animalID, 'SA81')| strcmp(summary_acquisition(i).animalID, 'SA110') | strcmp(summary_acquisition(i).animalID, 'SA150')
        summary_acquisition(i).patency = false;
    else
        summary_acquisition(i).patency = true;
    end
end
% cd('C:\Users\KeChen\MIT Dropbox\Ke Chen\Wang Lab\Manuscripts\DA_Cocaine_Fentanyl\Figures\Figure1\Data')
cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data')
save('Saline_acquisition_summary.mat', 'summary_acquisition')
%% plot the lever press and infusion counts
% clear; close all; clc;
cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data')
baf = behavior_analysis_func;
% cd('C:\Users\KeChen\MIT Dropbox\Ke Chen\Wang Lab\Manuscripts\DA_Cocaine_Fentanyl\Figures\Figure1\Data\')
% load('C:\Users\KeChen\MIT Dropbox\Ke Chen\Wang Lab\Manuscripts\DA_Cocaine_Fentanyl\Figures\Figure1\Data\Cocaine_acquisition_summary.mat')
% cd('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/')
% load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_acquisition_summary.mat')
summary_acquisition = summary_acquisition([summary_acquisition.patency]);

data_plot = [];
data_plot.FR = summary_acquisition(1).data.FR;
% only plot the 7 sessions of FR1, 2 sessions of FR2 and 10 sessions of FR4
for i = 1:length(summary_acquisition)
    FR2 = summary_acquisition(i).FR2;
    index_to_plot = (FR2(1) - 7) : (FR2(2) + 10);  % only plot the 7 sessions of FR1, 2 sessions of FR2 and 10 sessions of FR4
    if size(summary_acquisition(i).data, 1) < 19
        start = (FR2(1) - 7); last = size(summary_acquisition(i).data, 1);
        data_plot.activeLever(:, i) = [summary_acquisition(i).data.activeLeverPress(start:last); NaN];
        data_plot.inactiveLever(:, i) = [summary_acquisition(i).data.inactiveLeverPress(start:last); NaN];
        data_plot.infusion(:,i)       = [summary_acquisition(i).data.Reward(start:last); NaN];
    else
        data_plot.activeLever(:, i) = summary_acquisition(i).data.activeLeverPress(index_to_plot);
        data_plot.inactiveLever(:, i) = summary_acquisition(i).data.inactiveLeverPress(index_to_plot);
        data_plot.infusion(:,i)       = summary_acquisition(i).data.Reward(index_to_plot);
        % data.activeLever_cue(:, i) =  dataRaw.("activeLeverPress-Cue");
        % data.inactiveLever_cue(:, i) =  dataRaw.("inactiveLeverPress-Cue");
    end
end
% plot the active and inactive lever press
figure
subplot(1, 2, 1)
baf.FR_plot(summary_acquisition(1).data, 800)
baf.line_plot_MA_avg(data_plot.activeLever', data_plot.inactiveLever')
xlabel('Training Sessions')
set(gcf,'position',[100,100,500,250])
ylim([0, 1000])
% saveas(gcf, 'Cocaine_Acquisition_LeverPress.pdf');
% plot the infusion counts
subplot(1,2, 2)
baf.FR_plot(summary_acquisition(1).data, 100)
ylim([0, 150])
baf.line_plot_errorbar(data_plot.infusion','k', 'Infusions')
xlabel('Training Sessions')
set(gcf,'position',[500,100,500,200])
% saveas(gcf, 'Cocaine_Acquisition_Infusion.pdf');

%% figure
figure
baf.FR_plot(summary_acquisition(1).data, 1)
total_lever = data_plot.activeLever'+ data_plot.inactiveLever';
ratio_active = data_plot.activeLever'./total_lever;
baf.line_plot_errorbar(ratio_active,'m', 'Infusions')
xlabel('Training Sessions')
set(gcf,'position',[500,100,200,800])
xlim([10, 19])

