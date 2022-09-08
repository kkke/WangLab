clear
output = 'D:\Project_Master_Folder\Self-Administration\Head-fixed-SA\SA38'
load('Events.mat')
spikefiles = dir('cluster_*.mat');
for i = 1: length(spikefiles)
    load(spikefiles(i).name)
    clusterData.event = Event;
    fprintf('Calcuate the psth for spike %d of %d\n', i, length(spikefiles))
    clusterData.psth_cue = spike2eventRasteandPSTH_NP(clusterData.spiketimes, ...
    clusterData.event.lightCue_on, 100, -1000, 5000);
    clusterData.psth_drug = spike2eventRasteandPSTH_NP(clusterData.spiketimes, ...
    clusterData.event.lightCue_off, 100, -2000, 6000);
    summarydata(i) = clusterData;
end
outputfile = [output, '\', summarydata(1).session,'.mat'];
fprintf('Save summary files %s ...\n', summarydata(1).session)
save(outputfile, 'summarydata')
%%
k = 16
psth_plot_sa(summarydata(k).psth_cue);
psth_plot_sa(summarydata(k).psth_drug);
% xlim([-2, 4])