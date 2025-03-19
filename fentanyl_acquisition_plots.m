% In your summary folder, summarize all data into a single file
clear; close all;clc
% go the data folder
cd('C:\Users\KeChen\MIT Dropbox\Ke Chen\Wang Lab\Manuscripts\DA_Cocaine_Fentanyl\Figures\Figure1\Data\Fentanyl_Acquisition')

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
end
cd('C:\Users\KeChen\MIT Dropbox\Ke Chen\Wang Lab\Manuscripts\DA_Cocaine_Fentanyl\Figures\Figure1\Data')
save('Fentanyl_acquisition_summary.mat', 'summary_acquisition')
%% plot the lever press and infusion counts
clear; close all; clc;
baf = behavior_analysis_func;
load('C:\Users\KeChen\MIT Dropbox\Ke Chen\Wang Lab\Manuscripts\DA_Cocaine_Fentanyl\Figures\Figure1\Data\Fentanyl_acquisition_summary.mat')
data_plot = [];
data_plot.FR = summary_acquisition(1).data.FR;
% only plot the 9 sessions of FR1, 2 sessions of FR2 and 10 sessions of FR4
for i = 1:length(summary_acquisition)
    FR2 = summary_acquisition(i).FR2;
    if FR2(1)> 9 && length(FR2) == 2
        index_to_plot = (FR2(1) - 9) : (FR2(2) + 10);  % only plot the 7 sessions of FR1, 2 sessions of FR2 and 10 sessions of FR4
        data_plot.activeLever(:, i)   = summary_acquisition(i).data.activeLeverPress(index_to_plot);
        data_plot.inactiveLever(:, i) = summary_acquisition(i).data.inactiveLeverPress(index_to_plot);
        data_plot.infusion(:,i)       = summary_acquisition(i).data.Reward(index_to_plot);
    elseif FR2(1)<=9 && length(FR2) ==2
        % if the FR1 session is less than 1, add NaN before the first data
        % point
        index_to_plot = [summary_acquisition(i).FR1; summary_acquisition(i).FR2; summary_acquisition(i).FR4(1:10)];
        data_plot.activeLever(:, i)   = [NaN(1,10-FR2(1)); summary_acquisition(i).data.activeLeverPress(index_to_plot)];
        data_plot.inactiveLever(:, i) = [NaN(1,10-FR2(1)); summary_acquisition(i).data.inactiveLeverPress(index_to_plot)];
        data_plot.infusion(:,i)       = [NaN(1,10-FR2(1)); summary_acquisition(i).data.Reward(index_to_plot)];
    elseif FR2(1)> 9 && length(FR2) == 1
        % missing one FR2 sessions, add NaN to the 2nd FR2
        index_to_plot = (FR2(1) - 9) : (FR2(1) + 10);
        position_to_add_nan = 11; % add NaN at position 11
        activeLever   = summary_acquisition(i).data.activeLeverPress(index_to_plot);
        data_plot.activeLever(:, i) = [activeLever(1:position_to_add_nan-1); NaN; activeLever(position_to_add_nan:end)];

        inactiveLever = summary_acquisition(i).data.inactiveLeverPress(index_to_plot);
        data_plot.inactiveLever(:, i) = [inactiveLever(1:position_to_add_nan-1); NaN; inactiveLever(position_to_add_nan:end)];

        infusion      = summary_acquisition(i).data.Reward(index_to_plot);
        data_plot.infusion(:,i)  = [infusion(1:position_to_add_nan-1); NaN; infusion(position_to_add_nan:end)];
    end
    % data.activeLever_cue(:, i) =  dataRaw.("activeLeverPress-Cue");
    % data.inactiveLever_cue(:, i) =  dataRaw.("inactiveLeverPress-Cue");
end
% plot the active and inactive lever press
figure
baf.FR_plot(summary_acquisition(1).data, 900)
baf.line_plot_MA_avg(data_plot.activeLever', data_plot.inactiveLever')
saveas(gcf, 'Fentanyl_Acquisition_LeverPress.pdf');
% plot the infusion counts
figure;
baf.FR_plot(summary_acquisition(1).data, 100)
ylim([0, 140])
baf.line_plot_errorbar(data_plot.infusion','k', 'Infusion #')
saveas(gcf, 'Fentanyl_Acquisition_Infusion.pdf');
