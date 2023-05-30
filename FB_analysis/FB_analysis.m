%% load individual dataset
clear, clc
fb = fb_extract_doric;
folder = 'H:\Data\FB_data\Dopamine\SA81\053023';
filename = 'SA81_053023_DLS_0000';  % naming needs to be: aminalID_date_region
Sessions = {'Taking', 'Punishment', 'Seeking', 'Non-Contingent'};
session = Sessions{1};
data = fb.load_ch2_threeSeries([folder, '\', filename]);
% data = fb.load_ch2_oneSeries([folder, '\', filename]);
% data = fb.load_green_red_threeSeries([folder, '\', filename]);
% data = fb.load_green_red_oneSeries([folder, '\', filename]);
data = fb.fill_metadata(data, filename, session);
summarydata = fb.save_data(data, folder);

%% Plot PSTH
clc; close all;
i = 2
events = {'infusion', 'leverInsertion', 'leverRetraction'};
% Plot PSTH aligned to drug infusion
[~,~, fig1] = fb.psth_fb(summarydata(i).signal, summarydata(i).time,summarydata(i).(events{1}), -5, 50, events{1});
savefig(fig1, [summarydata(i).animalID, '_', summarydata(i).date, '_', summarydata(i).region, '_', ...
    summarydata(i).session, '_', events{1}, '.fig'])
% Plot PSTH aligned to lever insertion
[~,~, fig2] = fb.psth_fb(summarydata(i).signal, summarydata(i).time,summarydata(i).(events{2}), -5, 10, events{2});
savefig(fig2, [summarydata(i).animalID, '_', summarydata(i).date, '_', summarydata(i).region, '_', ...
    summarydata(i).session, '_', events{2}, '.fig'])

%% Save to a master datasets

