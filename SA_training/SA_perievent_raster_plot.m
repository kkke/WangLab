function reaction_t = SA_perievent_raster_plot(cue,inactiveLever, activeLever, Reward)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% get the peri-event of the lever press and reward
colors = cbrewer('div', 'RdYlBu', 4);
data.Cue = cue;
data.Back_Resp = inactiveLever; % Back means inactive lever here
data.Front_Resp = activeLever;  % Front means active lever.
data.Reward   = Reward;
for i = 1:length(data.Cue)-1
    time_range = [data.Cue(i), data.Cue(i+1)];
    perievent_back(i).times   = data.Back_Resp(find(data.Back_Resp > time_range(1) & data.Back_Resp < time_range(2))) - data.Cue(i);
    perievent_front(i).times  = data.Front_Resp(find(data.Front_Resp > time_range(1) & data.Front_Resp < time_range(2)))- data.Cue(i);
    perievent_reward(i).times = data.Reward(find(data.Reward > time_range(1) & data.Reward < time_range(2)))-data.Cue(i);
end

%plot the peri-event raster of lever pressing and reward
figure;
hold on
for i = 1:length(data.Cue)-1
    if ~isempty(perievent_front(i).times)
        h1 = plot([perievent_front(i).times; perievent_front(i).times], [i, i+1], 'color',colors(1,:));
    end
end
reaction_t = [];
for i  = 1 : length(perievent_front)
    reaction_t(i) = perievent_front(i).times(1);
end

hold on
for i = 1:length(data.Cue)-1
    if ~isempty(perievent_back(i).times)
        h3 = plot([perievent_back(i).times; perievent_back(i).times], [i, i+1], 'color', colors(4,:));
    end
end

hold on
for i = 1:length(data.Cue)-1
    h2 = plot([perievent_reward(i).times; perievent_reward(i).times], [i, i+1], 'k');
end

xlabel('Time (s)')
ylabel('Trial #')
xlim([-10,100])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
end

