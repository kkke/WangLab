%% Load the data
clear; close all; clc
fb = fb_extract_doric;
load("Fentanyl_Seeking_data.mat")
%% calculate all PSTHs
events = {'infusion', 'leverInsertion', 'leverRetraction'};
pre = -20; % time before event, sec
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
