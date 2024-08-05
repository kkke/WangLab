function groupdata = behavior_analysis_summary(groupdata)

% plot behaioral across sessions for individual anminals
baf = behavior_analysis_func;
summarydata = [];
for i = 1:length(groupdata)
    dataRaw = groupdata(i).behavior.summarydata;
    training_protocol = dataRaw.training;
    recording_index = find(contains(training_protocol, 'Ephys'));
    shock_session     = find(contains(training_protocol, 'shock'));
    summarydata(i).animalID = dataRaw.subject{1};
    summarydata(i).data = dataRaw;
    summarydata(i).recording_index = recording_index;
    summarydata(i).shock_session     = shock_session;
end

[x_index, subdata] = baf.line_plot_MA_align_punishment(summarydata, 'Reward');
ylabel('Infusion #')
% print(gcf, '-dtiff', 'Infusion_individual.tiff');
baf.line_plot_MA_align_punishment(summarydata, "activeLeverPress")
ylim([0, 1000])
% print(gcf, '-dtiff', 'leverPress_individual.tiff');

baf.line_plot_MA_align_punishment(summarydata, "activeLeverPress-Cue")
ylim([0, 800])
%% plot average across mice
% get reward, activelever with 3 taking, 3 punishment and 1 reinstatement
Reward = baf.avg_align_punishement(subdata, x_index, 'Reward'); 
activeLever = baf.avg_align_punishement(subdata, x_index, 'activeLeverPress');
inactiveLever = baf.avg_align_punishement(subdata, x_index, 'inactiveLeverPress');

% extract the summary of reward for groupdata
for i = 1:length(groupdata)
    groupdata(i).reward.infusion = mean(Reward(1:3, i));
    groupdata(i).reward.infusion_punishment = mean(Reward(4:6, i));
    groupdata(i).reward.infusion_reinstatment = Reward(7, i);

end

% plot the average infusion across different sessions
figure
hold on
rectangle('Position',[3.5, 0, 3, 100], 'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'none');
text(3.9, 90, 'Punishment', 'FontSize', 12, 'Color', 'r')
text(3.6, 85, '0.2 mA Shock', 'FontSize',12)
baf.line_plot_errorbar(Reward', 'k', 'Infusion #')
xlim([0, 8])
plot([0.5, 3.5], [105, 105], 'Color', [221,28,119]/255, 'LineWidth',2)
text(1, 110, 'Cocaine', 'FontSize', 14, 'Color', [221,28,119]/255, 'FontWeight','bold')
plot([6.5, 7.5], [105, 105], 'Color', [49,163,84]/255, 'LineWidth',2)
text(6.2, 110, 'Saline', 'FontSize', 14, 'Color', [49,163,84]/255, 'FontWeight','bold')
% saveas(gcf, ['summary_cocaine_shock_reinstatement_Infusion.pdf'])

% plot the average active/inactive lever press
figure
hold on
rectangle('Position',[3.5, 0, 3, 100], 'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'none');
text(3.9, 90, 'Punishment', 'FontSize', 12, 'Color', 'r')
text(3.6, 85, '0.2 mA Shock', 'FontSize',12)
baf.line_plot_errorbar(activeLever', [215,25,28]/255, 'Lever Press #')
xlim([0, 8])
plot([0.5, 3.5], [105, 105], 'Color', [221,28,119]/255, 'LineWidth',2)
text(1, 110, 'Cocaine', 'FontSize', 14, 'Color', [221,28,119]/255, 'FontWeight','bold')
plot([6.5, 7.5], [105, 105], 'Color', [49,163,84]/255, 'LineWidth',2)
text(6.2, 110, 'Saline', 'FontSize', 14, 'Color', [49,163,84]/255, 'FontWeight','bold')
baf.line_plot_errorbar(inactiveLever', [44,123,182]/255, 'Lever Press #')
xlim([0, 8])
% saveas(gcf, ['summary_Fentanyl_shock_reinstatement_leverPress.pdf'])

%% only plot the last session before shock, the last session of shock and reinstatment
index = [3,6, 7]
reward_sub = Reward(index, :);
activeLever_sub = activeLever(index, :);
inactiveLever_sub = inactiveLever(index,:);

% active lever 
figure
baf.line_plot_errorbar(activeLever_sub', [215,25,28]/255, 'Lever Press #')
hold on
% baf.line_plot_errorbar(inactiveLever_sub',  [44,123,182]/255, 'Lever Press #')
ylim([0, 1500])
xlim([0, 4])
hold on
plot(activeLever_sub, 'k')

% infusion counts
figure
baf.line_plot_errorbar(reward_sub', 'k', 'Infusion #')
hold on
% baf.line_plot_errorbar(inactiveLever_sub',  [44,123,182]/255, 'Lever Press #')
xlim([0, 4])
hold on
plot(reward_sub, 'color',[0.1, 0.1, 0.1])

% average infusion
reward_taking = mean(Reward(1:3, :), 1);
reward_punish = mean(Reward(4:6, :), 1);
reward_reinstatement = Reward(7, :);
figure
baf.line_plot_errorbar([reward_taking;reward_punish;reward_reinstatement]', 'k', 'Average Infusion #')
hold on
xlim([0, 4])
plot([reward_taking;reward_punish;reward_reinstatement], 'color',[0.1, 0.1, 0.1])

% average active Lever
activeLever_taking = mean(activeLever(1:3, :), 1);
activeLever_punish = mean(activeLever(4:6, :), 1);
activeLever_reinstatement = activeLever(7, :);
figure
baf.line_plot_errorbar([activeLever_taking;activeLever_punish;activeLever_reinstatement]', [215,25,28]/255, 'Average Lever Press #')
hold on
xlim([0, 4])
plot([activeLever_taking;activeLever_punish;activeLever_reinstatement], 'color',[0.1, 0.1, 0.1])
ylim([0, 1000])