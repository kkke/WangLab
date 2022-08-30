[file, path] = uigetfile('H:/Data/Ephys_Recording/*.npy');
analdir = path;

Fs = 30000; %sampling rate in Hz

%% loads in the channel map (if needed)
if exist(fullfile(analdir,  'spike_clusters.npy')) ~=0
    %phy has been opened for this file already
    clu = readNPY(fullfile(analdir,  'spike_clusters.npy'));
else
    %because spike_templates is the same as spike_clusters prior to manual
    %curation
    clu = readNPY(fullfile(analdir,  'spike_templates.npy'));
end
%%
ss = readNPY(fullfile(analdir,  'spike_times.npy'));
st = double(ss)/Fs;
% load the cluster labels
[cids, cgs] = readClusterGroupsCSV(fullfile(analdir,  'cluster_group.tsv'));

%cluster quality(0=noise, 1=MUA, 2=Good, 3=unsorted)
goodClusters = cids(cgs==2);
allClusters = cids;

%%
for i=1:length(goodClusters)
    %for each goodCluster find their location in the clu vector, then the
    %st vector
    
    %good cluster i is cluster number "clus_id"
    clus_id = goodClusters(i);
    clus_rating = cgs(find(cids==clus_id));
    
    spikes = st(find(clu == clus_id));
    nSpikes = length(spikes);
%     idx = find(clusterID == clus_id+1);
    
%     %check isi is the same
%     spike_hist = histcounts(spikes.*1000,0:1:spikes(end).*1000);
%     test = xcorr(spike_hist,spike_hist,25);
%     test(26) = 0;
%     figure; bar(-25:1:25,test);

%     isoDist = isoDistances(idx); %clus_id is zero-indexed
%     isiViol = (isiV(idx) ./ nSpikes) .*100; %as a percentage
    
%     [templates, templateMinIndex] = get_mean_spatiotemporal_template(analdir, clus_id);
    [templates, templateMinIndex] = get_mean_spatiotemporal_template_ks2(analdir, clus_id);
    
    clusterData = [];
    clusterData.nSpikes = nSpikes;
%         clusterData.run(j).isi_perc = isiViol;


   clusterData.clusterID = clus_id;
   clusterData.clusterRating = clus_rating;  
   %if it is a merged cluster, this represents the average
   clusterData.spatiotemporalTemplate = templates;
   %channel on which the minimum template was found
   clusterData.templateMin = templateMinIndex;
   clusterData.spiketimes = spikes;
   disp(sprintf('...saving spiking data for cluster %d/%d',i,length(goodClusters)));    
   cd(analdir)
   if exist('SpikeData', 'dir') ~=0
   else
       mkdir SpikeData
   end
   filename = [analdir '/SpikeData/', sprintf('cluster_%d',clus_id) '.mat'];
   save(filename,'clusterData');    
end
