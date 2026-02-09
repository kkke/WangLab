%% plot the population psth
clear; clc; close all
% load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure1/Data/Cocaine_testing_summary.mat')
load('/Users/kechen/MIT Dropbox/Ke Chen/Wang Lab/Manuscripts/DA_Cocaine_Fentanyl/Figures/Figure3/data/Fentanyl_FB_taking_plot.mat')

%% plot the population PSTH and sort the responses based on counts of all infusions of that sessions
drug_baseline_taking_plots(data_plot, data_to_plot, population_psth_avg, psth_time)

figure(2)
ax = findall(gcf, 'Type', 'axes');
% Update axis range
ylim(ax(2), [20, 140])
ylabel(ax(2), 'Baseline Fentanyl Infusions')
xlim(ax(2), [-0.4, 1.2]);
xticks(ax(2), [-0.4, 0, 0.4, 0.8, 1.2])
xlim(ax(1), [-0.4, 1.2]);
xticks(ax(1), [-0.4, 0, 0.4, 0.8, 1.2])
ylim(ax(1), [20, 140])
ylabel(ax(1), 'Baseline Fentanyl Infusions')


figure(3)
ax = findall(gcf, 'Type', 'axes');
% Update axis range
ylim(ax(2), [-0.4, 1.2]);
yticks(ax(2), [-0.4, 0, 0.4, 0.8, 1.2])

ylim(ax(1), [-0.4, 1.2]);
yticks(ax(1), [-0.4, 0, 0.4, 0.8, 1.2])


figure(4)
ax = findall(gcf, 'Type', 'axes');
% Update axis range
xlim(ax(2), [0, 3]);
ylim(ax(2), [20, 120])
ylim(ax(1), [20, 120])

%%

figure;
i = 23
t = data_to_plot(2).infusion(i);
index = find(data_to_plot(2).raw_time > t-30 & data_to_plot(2).raw_time < t+50);

plot(data_to_plot(2).raw_time(index), data_to_plot(2).raw_signal(index))
hold on
plot(data_to_plot(2).raw_time (index), data_to_plot(2).raw_reference(index))
%%
hold on
plot(data_to_plot(2).time(index), data_to_plot(2).signal(index))

%

for i = 1:length(data_to_plot(2).front)

plot([data_to_plot(2).front(i),data_to_plot(2).front(i)],  [0, 6], 'r')
end

for i = 1:length(data_to_plot(2).leverRetraction)
    plot([data_to_plot(2).leverRetraction(i),data_to_plot(2).leverRetraction(i)],  [0, 6], 'y')
end
for i = 1:length(data_to_plot(2).leverInsertion)
    plot([data_to_plot(2).leverInsertion(i),data_to_plot(2).leverInsertion(i)],  [0, 6], 'y')
end

plot([data_to_plot(2).infusion(23),data_to_plot(2).infusion(23)],  [0, 6], 'g')

xlim([t-30, t+50])
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

    series = [0, 30*60; 60*60, 90*60; 120 *60, 150 *60];
    trial_matrix  = []; % the first column is the lever insertion, and the 2nd column is the infusion;

    for i = 1:size(series, 1)
        first_insertion = leverInsertion(find(leverInsertion > series(i, 1) & leverInsertion < series(i, 2)));
        first_infusion  = infusion(find(infusion > series(i, 1) & infusion < series(i, 2)));

        if first_insertion(1) > first_infusion(1)
            first_infusion(1) = [];
        else
        end
        trial_matrix = [trial_matrix; [first_insertion(1:length(first_infusion)), first_infusion]];
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
    data_to_plot(j).leverPress_trial = leverPress_trial;
    plot_tf = 0
    pre = -5;
    post = 5;
    [data_to_plot(j).psth_leverpress_time, data_to_plot(j).psth_leverpress, fig] = fb.psth_fb(data_to_plot(j).signal, ...
        data_to_plot(j).time, data_to_plot(j).first_lever_press, pre, post, plot_tf, 'Lever Press');
    ax = findall(gcf, 'Type', 'axes');
    % Update axis range
    % ylim(ax(2), [-1, 1])
end

%%
close all
fb = fb_extract_doric;

% trial_counts = arrayfun(@(x) x.behavior.reward_all, data_to_plot);

high_taker = data_plot.high_taker;
low_taker = data_plot.low_taker;

[B,sort_index] = sort(data_plot.animal_avg_taking, 'descend');
psth_leverPress = [];

psth_leverPress_time = mean(data_to_plot(1).psth_leverpress_time, 2);
% normalized to baseline
baseline_time = 5;
baseline_index = find(psth_leverPress_time>-baseline_time & psth_leverPress_time< -3);
for i = 1:length(data_to_plot)
    psth_leverPress(:, i) = mean(data_to_plot(i).psth_leverpress, 2);
    data_to_plot(i).psth_leverpress_baseline = mean(data_to_plot(i).psth_leverpress(baseline_index,:), 1);
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
ylim([-0.5, 0.5]);
set(gcf,'position',[100,100,250,250])

%%
figure;
subplot(1, 2, 1)
popPSTH_cluster(norm_population_psth_avg, psth_leverPress_time, high_taker, low_taker, [2, 3])
xlim([-5, 5])
ylim([-0.5, 0.5])

time_pre = [-2, 0];
time_post    = [0, 1];
pre_index  =  find(psth_leverPress_time> time_pre(1) & psth_leverPress_time< time_pre(2));
post_index =  find(psth_leverPress_time>time_post(1) & psth_leverPress_time< time_post(2));
value_pre  =  mean(norm_population_psth_avg(pre_index, :), 1);
value_post =  mean(norm_population_psth_avg(post_index, :), 1);

subplot(1, 2, 2)
bar_scatter_cluster_v2(value_post, high_taker, low_taker)
ylim([-1, 1])
ylabel('Z Score')
set(gcf,'position',[100,100,500,200])
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


%% plate lever press response examples for all mice
for j = 1:length(data_plot.high_taker)
    i = data_plot.high_taker(j)
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
    ylim([-1, 2])
    end