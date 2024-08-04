clear
% dataFolder = uigetfile('H:\Data\Ephys_Recording\*.mat', 'Select the Event Mat file');
load('Events.mat')
% extract the active lever
if ~isempty(Event.front_light_on)
    if isempty(Event.back_light_on)
        Event.activeLever = 'front';
        Event.inactiveLever = 'back';
    else
        Event.activeLever = 'both';
        Event.inactiveLever = [];
    end
else
    if isempty(Event.back_light_on)
        Event.activeLever = [];
        Event.inactiveLever = 'both';
    else
        Event.activeLever = 'back';
        Event.inactiveLever = 'front';
    end
end
% fix the event of lever out and drug-associative cue
cues = Event.([Event.activeLever, '_light_on']);
interval_cues = diff(cues);
% blinking cues: 1.5 s on and off
blink_events = find(interval_cues>1.4 & interval_cues< 1.6);
% during blinking, there are 12 light on.
blink_start  = blink_events(1:12:end);
lever_out    = blink_start - 1;
lever_in     = blink_start + 12;

Event.process.Lever_on = cues(lever_out );
Event.process.blink_start = cues(blink_start);
Event.process.pump_on   = Event.pump_on;
Event.process.back_lever = Event.back_press_on;
Event.process.front_lever = Event.front_press_on;
%%
spikedatafolder = cd('SpikeData')
spikefiles = dir('cluster_*.mat');
for i = 1: length(spikefiles)
    load(spikefiles(i).name)
    clusterData.event = Event;
    fprintf('Calcuate the psth for spike %d of %d\n', i, length(spikefiles))
    clusterData.psth_lever = spike2eventRasteandPSTH_NP(clusterData.spiketimes, ...
    clusterData.event.process.Lever_on, 100, -1000, 5000);
    clusterData.psth_drug = spike2eventRasteandPSTH_NP(clusterData.spiketimes, ...
    clusterData.event.process.pump_on, 100, -2000, 6000);
    clusterData.psth_activeLever = spike2eventRasteandPSTH_NP(clusterData.spiketimes, ...
    clusterData.event.process.([clusterData.event.activeLever, '_lever']), 100, -2000, 2000);
    summarydata(i) = clusterData;
end

outputfile = ['D:\Project_Master_Folder\Self-Administration\Ephys_freely_Moving',...
    '\', summarydata(1).session,'.mat'];
fprintf('Save summary files %s ...\n', summarydata(1).session)
save(outputfile, 'summarydata')
%%
k = 4
psth_plot_sa(summarydata(k).psth_lever);
psth_plot_sa(summarydata(k).psth_drug);
% psth_plot_sa(summarydata(k).psth_activeLever);
% xlim([-2, 4])

%%
clear
files = dir('*.mat');
subdata_01_index = 4:6;
subdata_02_index = 7:8;

subdata_01 = [];
subdata_02 = [];

for i = 1:length(subdata_01_index)
    load(files(subdata_01_index(i)).name);
    subdata_01 = [subdata_01, summarydata];
end

%% change the bin size to 200 ms
for i = 1:length(subdata_01)
    subdata_01(i).psth_cue = spike2eventRasteandPSTH_NP(subdata_01(i).spiketimes, subdata_01(i).event.lightCue_on, 200, -1000, 5000); 
    subdata_01(i).psth_drug = spike2eventRasteandPSTH_NP(subdata_01(i).spiketimes, subdata_01(i).event.lightCue_off, 200, -2000, 6000); 
end

for i = 1:length(subdata_01)
    psth = subdata_01(i).psth_cue;
    stats = response_test_cue(psth, -1, 2);
    subdata_01(i).stats.cue = stats;
    subdata_01(i).cue_resp = subdata_01(i).stats.cue.resp_sign;
    
end

cue_resp_increase = subdata_01(find([subdata_01.cue_resp] == 1));
cue_resp_decrease = subdata_01(find([subdata_01.cue_resp] == -1));

cue_resp = [cue_resp_increase, cue_resp_decrease];
for i = 1:length(cue_resp)
    PSTH_auROC(i,:) = psth_auROC(cue_resp(i).psth_cue.scmatrix, 1, 200);
end
figure;
imagesc(subdata_01(1).psth_cue.timepoint, [], PSTH_auROC)
xlim([-1,5])
caxis([0.35,0.65])
colormap(auROC_spike)
h = colorbar;
ylabel(h, 'auROC')
set(gca,'fontsize',12)
set(gcf,'position',[100,100,400,200])
set(gca,'YTick',[])
set(gca,'TickDir','out')
xlabel('Time (s)')


%% align to lever press
for i = 1:length(cue_resp)
    PSTH_auROC_lever(i,:) = psth_auROC(cue_resp(i).psth_drug.scmatrix, 1, 200, cue_resp(i).psth_cue.scmatrix(:, 1:5));
end
figure;
imagesc(subdata_01(1).psth_drug.timepoint, [], PSTH_auROC_lever)
xlim([-1,5])
caxis([0.35,0.65])
colormap(auROC_spike)
h = colorbar;
ylabel(h, 'auROC')
set(gca,'fontsize',12)
set(gcf,'position',[100,100,400,200])
set(gca,'YTick',[])
set(gca,'TickDir','out')
xlabel('Time (s)')
%%
psth_plot_sa(cue_resp_increase(4).psth_drug);