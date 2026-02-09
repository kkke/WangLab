%% plot the population psth
clear; clc; close all
% load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_testing_summary.mat')
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure4/data/Fentanyl_FB_Punishment_plot.mat')

%% plot the data
drug_punishment_plots(data_plot, data_to_plot, population_psth_avg, psth_time)
%%
figure(1)
ax = findall(gcf, 'Type', 'axes');
ylim(ax(1), [-0.5, 1.5])

figure(2)
ax = findall(gcf, 'Type', 'axes');
% Update axis range
ylim(ax(4), [-1, 3])
ylim(ax(3), [-1, 3])
ylim(ax(2), [0, 100])
xlim(ax(2), [-0.4, 2.2]);
xticks(ax(2), [-0.4, 0, 1, 2.0])
xlim(ax(1), [-2, 4]);
xticks(ax(1), [-2, 0, 2, 4])
ylim(ax(1), [0, 100])

figure(3)
ax = findall(gcf, 'Type', 'axes');
% Update axis range
ylim(ax(2), [-2, 4]);
yticks(ax(2), [-2, 0, 2, 4])

ylim(ax(1), [-0.4, 2.2]);
yticks(ax(1), [-0.4, 0, 1, 2.0])


figure(4)
ax = findall(gcf, 'Type', 'axes');
% Update axis range
xlim(ax(2), [0, 5]);
xlim(ax(1), [0, 5]);

figure(5)
ax = findall(gcf, 'Type', 'axes');
% Update axis range
ylim(ax(2), [0, 5]);
ylim(ax(1), [0, 5]);
%%
%% analysis of lever press responses
% for each session there are following parameters to consider: number of infusion, number of active pressing, number of
% inactive pressing; reaction time for pressing, reaction time for active
% pressing; inter-press interval

fb = fb_extract_doric;
for j = 1:length(data_to_plot)
    training_session = char(data_to_plot(j).behavior.data.training(1));
    if strcmp(training_session(1), 'B')
        activelever_label = 'back';
        inactivelever_label = 'front';
    elseif strcmp(training_session(1), 'F')

        activelever_label = 'front';
        inactivelever_label = 'back';
    else
        error('There is something wrong')
    end

    activeLever = data_to_plot(j).(activelever_label);
    inactiveLever = data_to_plot(j).(inactivelever_label);
    % find lever press before infusion
    leverInsertion = data_to_plot(j).leverInsertion;
    infusion = data_to_plot(j).infusion;


    leverInsertion = reshape(leverInsertion, [], 1);
    infusion       = reshape(infusion, [], 1);
    activeLever = unique([activeLever(:); infusion(:)]); % fix the error, that some lever press at infusion not registered
    series = [0, 30*60; 60*60, 90*60; 120 *60, 150 *60];
    trial_matrix  = []; % the first column is the lever insertion, and the 2nd column is the infusion;

    for i = 1:size(series, 1)
        first_insertion = leverInsertion(find(leverInsertion > series(i, 1) & leverInsertion < series(i, 2)));
        first_infusion  = infusion(find(infusion > series(i, 1) & infusion < series(i, 2)));
        if isempty(first_infusion) || isempty(first_infusion)
        elseif first_insertion(1) > first_infusion(1)
            first_infusion(1) = [];
            trial_matrix = [trial_matrix; [first_insertion(1:length(first_infusion)), first_infusion]];
        else
            trial_matrix = [trial_matrix; [first_insertion(1:length(first_infusion)), first_infusion]];

        end
    end


    leverPress_trial = [];

    for i = 1:size(trial_matrix, 1)
        indx = find(activeLever > trial_matrix(i, 1) & activeLever <= trial_matrix(i,2));
        if length(indx) >4
            indx =  indx(end-3: end);
        end
        leverPress_trial(:, i)= activeLever(indx); % only get the leverPress before infusion
    end

    data_to_plot(j).first_lever_press = leverPress_trial(1,:);
    data_to_plot(j).leverIPI = diff(leverPress_trial, 1, 1);
    data_to_plot(j).leverPress_trial = leverPress_trial;


    plot_tf = 0
    pre = -5;
    post = 5;
    % add condition that the lever press interval is less than 2 s, then it
    % is removed
    [r, c] = find(data_to_plot(j).leverIPI < 2);
    leverPress_trial(r+1, c) =  NaN;
    for i = 1:size(leverPress_trial, 2)
        if isnan(leverPress_trial(4, i))   % make sure the 3rd lever Press is not too close to the infusion.
            leverPress_trial(3, i) = NaN;
        end
    end
    %%%%%%%%%%%%%
    leverPress_analysis_1stTrial  = reshape(leverPress_trial(1:3, 1), [], 1);
    leverPress_analysis_1stTrial(isnan(leverPress_analysis_1stTrial))  = [];
    leverPress_analysis = reshape(leverPress_trial(1:3, 2:end), [], 1);
    leverPress_analysis(isnan(leverPress_analysis)) = [];

    [data_to_plot(j).psth_leverpress_time, data_to_plot(j).psth_leverpress, fig] = fb.psth_fb(data_to_plot(j).signal, ...
        data_to_plot(j).time, leverPress_analysis, pre, post, plot_tf, 'Lever Press');
    ax = findall(gcf, 'Type', 'axes');

    [data_to_plot(j).psth_leverpress_time_1st, data_to_plot(j).psth_leverpress_1st, fig] = fb.psth_fb(data_to_plot(j).signal, ...
        data_to_plot(j).time, leverPress_analysis_1stTrial, pre, post, plot_tf, 'Lever Press');
    ax = findall(gcf, 'Type', 'axes');

    % Update axis range
    % ylim(ax(2), [-1, 1])
end

%%
close all
fb = fb_extract_doric;

% trial_counts = arrayfun(@(x) x.behavior.reward_all, data_to_plot);

high_taker = data_plot.high_resistance;
low_taker = data_plot.low_resistance;

[B,sort_index] = sort(data_plot.animal_avg_punishment, 'descend');

%%
psth_leverPress = [];
psth_leverPress_time = data_to_plot(1).psth_leverpress_time(:, 1);
% normalized to baseline
baseline_time = 5;
baseline_index = find(psth_leverPress_time>- baseline_time & psth_leverPress_time< -3);

%get the first trials response

psth_leverPress_1st = [];
for i = 1:length(data_to_plot)
    if size(data_to_plot(i).psth_leverpress_1st, 2) ==1
    psth_leverPress_1st(:, i) = data_to_plot(i).psth_leverpress_1st;
    else
        psth_leverPress_1st(:, i) = mean(data_to_plot(i).psth_leverpress_1st, 2);
    end
    data_to_plot(i).psth_leverpress_baseline_1st = mean(data_to_plot(i).psth_leverpress_1st(baseline_index,:),1);
end
psth_leverPress_time = mean(data_to_plot(1).psth_leverpress_time, 2);
norm_population_psth_avg_1st = psth_leverPress_1st - mean(psth_leverPress_1st(baseline_index,:));
fb.groupplot_psth_avg(psth_leverPress_time, norm_population_psth_avg_1st(:, sort_index)); % sorted based one infusion counts
ax = findall(gcf, 'Type', 'axes');
% Update y-axis labels
ylabel(ax(2), 'Animals');
xlim(ax(2), [-5, 5]);
xlim(ax(1), [-5, 5]);
ylim([-1, 1]);
set(gcf,'position',[100,100,250,250])


% get the rest lever Press responses
for i = 1:length(data_to_plot)
    psth_leverPress(:, i) = mean(data_to_plot(i).psth_leverpress(:,1:end), 2);
    data_to_plot(i).psth_leverpress_baseline = mean(data_to_plot(i).psth_leverpress(baseline_index,1:end), 1);
end

baseline = mean(psth_leverPress(baseline_index,:));
norm_population_psth_avg = psth_leverPress - baseline;
% plot sorted normalized population psth
fb.groupplot_psth_avg(psth_leverPress_time, norm_population_psth_avg(:, sort_index)); % sorted based one infusion counts
ax = findall(gcf, 'Type', 'axes');
% Update y-axis labels
ylabel(ax(2), 'Animals');
xlim(ax(2), [-5, 5]);
xlim(ax(1), [-5, 5]);
ylim([-1, 0.5]);
set(gcf,'position',[100,100,250,250])

%%
figure;
subplot(1, 2, 1)
popPSTH_cluster(norm_population_psth_avg, psth_leverPress_time, high_taker, low_taker, [1, 4])
xlim([-5, 5])
ylim([-1, 1])

time_pre = [-2, 0];
time_post    = [0, 2];
pre_index  =  find(psth_leverPress_time> time_pre(1) & psth_leverPress_time< time_pre(2));
post_index =  find(psth_leverPress_time>time_post(1) & psth_leverPress_time< time_post(2));
value_pre  =  mean(norm_population_psth_avg(pre_index, :), 1);
value_post =  mean(norm_population_psth_avg(post_index, :), 1);

subplot(1, 2, 2)
bar_scatter_cluster_punishment_v2(value_post, high_taker, low_taker)
ylim([-2, 1])
ylabel('Z Score')
set(gcf,'position',[100,100,500,200])
%%
%% the the raster of lever press per trial
leverpress_rate = [];
for j = 1:length(data_to_plot)
    colors = cbrewer2('div', 'RdYlBu', 6);
    cue = data_to_plot(j).leverInsertion;
    training_session = char(data_to_plot(j).behavior.data.training(1));
    if strcmp(training_session(1), 'B')
        activelever_label = 'back';
        inactivelever_label = 'front';
    elseif strcmp(training_session(1), 'F')

        activelever_label = 'front';
        inactivelever_label = 'back';
    else
        error('There is something wrong')
    end

    activeLever = data_to_plot(j).(activelever_label);

    reward     = data_to_plot(j).infusion;
    figure
    perievent = [];
    % get the peri-event of the lever press and reward
    bin = 1;
    edges = -5:bin:50;
    n = zeros(length(data_to_plot(j).first_lever_press), length(edges)-1);
    for i = 1:length(data_to_plot(j).first_lever_press)
        time_range = [-5 , 50] + data_to_plot(j).first_lever_press(i);
        perievent(i).cue                 = cue(find(cue > time_range(1) & cue < time_range(2)))- data_to_plot(j).first_lever_press(i);
        perievent(i).activeLever_times   = activeLever(find(activeLever > time_range(1) & activeLever < time_range(2)))- data_to_plot(j).first_lever_press(i);
        perievent(i).reward_times = reward(find(reward > time_range(1) & reward < time_range(2)))- data_to_plot(j).first_lever_press(i);
        n(i, :) = histcounts(perievent(i).activeLever_times(:), edges);
        
        if ~isempty(perievent(i).activeLever_times)
            h1 = plot([perievent(i).activeLever_times(:)'; perievent(i).activeLever_times(:)'], [i, i+1], 'color',colors(1,:));
            hold on
        end
        if ~isempty(perievent(i).reward_times)
            h2 = plot([perievent(i).reward_times(:)'; perievent(i).reward_times(:)'], [i, i+1], 'k');
        end
        if ~isempty(perievent(i).cue)
            h1 = plot([perievent(i).cue(:)'; perievent(i).cue(:)'], [i, i+1], 'g');
            hold on
        end
        xlim([-5, 5])
    end
    data_to_plot(j).leverPress_matrix = n;
    data_to_plot(j).leverPress_rate   = (sum(n)/bin)/length(data_to_plot(j).first_lever_press);
    leverpress_rate(:, j) = data_to_plot(j).leverPress_rate';
end
%% plot the lever press rate for 
time_bin_center =  (edges(1:end-1) + edges(2:end)) / 2;
figure;
popPSTH_cluster(leverpress_rate, time_bin_center, high_taker, low_taker, [2, 3])
xlim([-2, 10])
ylim([0, 2])
ylabel('Lever Press Rate (Hz)')
set(gcf,'position',[100,100,250,200])
%% example mice
for j = 1:length(data_plot.low_resistance)
    i = data_plot.low_resistance(j)
    figure;
    tiledlayout("vertical", 'TileSpacing', 'compact', 'Padding', 'compact')
    nexttile
    imagesc(psth_leverPress_time',[], (data_to_plot(i).psth_leverpress - data_to_plot(i).psth_leverpress_baseline)') % cocaine 19; fentanyl 23
    colormap(jet)
    xlabel('')
    ylabel('Trials')
    box off
    set(gca,'TickDir','out')
    set(gca,'fontsize',12)
    set(gca,'TickLengt', [0.015 0.015]);
    set(gca, 'LineWidth',1)
    set(gcf,'position',[100,100,340,170])
    clim([-2, 5])
    xlim([-5, 5])
    set(gca, 'XTick', [], 'XTickLabel', []);
    box off
    title('High Drug Taking')

    nexttile
    x = mean(psth_leverPress_time, 2, 'omitnan');
    y = mean(data_to_plot(i).psth_leverpress - data_to_plot(i).psth_leverpress_baseline, 2, 'omitnan');
    e = std(data_to_plot(i).psth_leverpress - data_to_plot(i).psth_leverpress_baseline,1, 2, 'omitmissing')/sqrt(size(data_to_plot(i).psth_leverpress, 2));
    boundedline(x, y, e, '-k');
    xlabel('Time (s)','FontName', 'Arial')
    ylabel('Z-Score','FontName', 'Arial')
    hold on
    ylim([-0.5, 2.5])
    plot([0, 0], [-1, 1], 'r--')
    plot([19.50, 19.50], [-1, 1], 'k--')
    plot([40.00, 40.00], [-1, 1], 'k--')
    box off
    set(gca,'TickDir','out')
    set(gca,'fontsize',12, 'FontName', 'Arial')
    set(gca,'TickLengt', [0.015 0.015]);
    set(gca, 'LineWidth',1)
    set(gcf,'position',[100,100,250,200])
    xlim([-5, 5])
    ylim([-2, 2])
    end