
Fs = 30000; %sampling rate in Hz
%loads in the channel map (if needed)
if exist(fullfile(analdir,  'spike_clusters.npy')) ~=0
    %phy has been opened for this file already
    clu = readNPY(fullfile(analdir,  'spike_clusters.npy'));
else
    %because spike_templates is the same as spike_clusters prior to manual
    %curation
    clu = readNPY(fullfile(analdir,  'spike_templates.npy'));
end

ss = readNPY(fullfile(analdir,  'spike_times.npy'));
st = double(ss)/Fs;

if  exist(fullfile(analdir,  'cluster_group.tsv')) ~=0
    %manual curation has already been carried out
    [cids, cgs] = readClusterGroupsCSV(fullfile(analdir,  'cluster_group.tsv'));
else
    %manual curation has not been carried out, so unique(clu) represents
    %the direct output of kilosort
    cids = unique(clu); %all clusters
    
    %label these as -1: unsorted
    cgs = zeros(1,length(cids)).*-1; 
end
