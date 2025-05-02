function population_psth_fp_sorted(psth_time, population_psth_avg, sort_index, trial_counts)
fb = fb_extract_doric;
baseline_time = 10;
baseline_index = find(psth_time>-baseline_time & psth_time< 0);
baseline = mean(population_psth_avg(baseline_index,:));
norm_population_psth_avg = population_psth_avg - baseline;
% plot sorted normalized population psth
fb.groupplot_psth_avg(psth_time, norm_population_psth_avg(:, sort_index)); % sorted based one infusion counts
set(gcf,'position',[100,100,340,340])
%% correlation analysis- sustained 
time_sustained = [0, 19.5];
time_phasic    = [0, 1];
phasic_index = find(psth_time>0& psth_time< 1);
sustained_index = find(psth_time>0 & psth_time< 19.5);
value_sustained = mean(norm_population_psth_avg(sustained_index, :), 1);
value_phasic    = mean(norm_population_psth_avg(phasic_index, :), 1);
mdl = fb.correlaiton_analysis_cluster(value_sustained, trial_counts, []);
xlim([0, 1.5])
xlabel('Average Sustained DA')
ylim([30, 100])
ylabel('Infusion Counts')
set(gcf,'position',[100,100,340,340])
%% correlation analysis- phasic 
mdl = fb.correlaiton_analysis_cluster(value_phasic, trial_counts, []);
xlim([-1, 1])
xlabel('Average Phasic DA')
ylim([30, 100])
ylabel('Infusion Counts')
set(gcf,'position',[100,100,340,340])