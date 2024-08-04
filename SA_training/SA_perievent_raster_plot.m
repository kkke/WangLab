function [perievent, reaction_time] = SA_perievent_raster_plot(cue,back_lever, front_lever, Reward)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% get the peri-event of the lever press and reward
colors = cbrewer('div', 'RdYlBu', 4);
data.Cue = cue;
data.Back_Resp = back_lever; 
data.Front_Resp = front_lever;  
data.Reward   = Reward;

try
    if data.Cue(1)>data.Reward(1)
        data.Cue = cue(1:end-1);
        data.Reward = Reward(2:end);
    end
catch
end
for i = 1:length(data.Cue)
    time_range = [data.Cue(i), data.Reward(i)+40];
    perievent_back(i).times   = data.Back_Resp(find(data.Back_Resp > time_range(1) & data.Back_Resp < time_range(2))) - data.Cue(i);
    perievent_front(i).times  = data.Front_Resp(find(data.Front_Resp > time_range(1) & data.Front_Resp < time_range(2)))- data.Cue(i);
    perievent_reward(i).times = data.Reward(find(data.Reward > time_range(1) & data.Reward < time_range(2)))-data.Cue(i);
end
perievent.active   = perievent_back;
perievent.inactive = perievent_front;
perievent.reward   = perievent_reward;

%plot the peri-event raster of lever pressing and reward
figure;
hold on
for i = 1:length(data.Cue)-1
    if ~isempty(perievent_front(i).times)
        h1 = plot([perievent_front(i).times; perievent_front(i).times], [i, i+1], 'color',colors(4,:));
    end
end
reaction_front = [];
reaction_back = [];
reaction_infusion = [];
for i  = 1 : length(perievent_front)
    if isempty(perievent_front(i).times)
        reaction_front(i) = NaN;
    else
    reaction_front(i) = perievent_front(i).times(1);
    end
end

for i  = 1 : length(perievent_back)
    if isempty(perievent_back(i).times)
        reaction_back(i) = NaN;
    else
    reaction_back(i) = perievent_back(i).times(1);
    end
end

for i  = 1 : length(perievent_reward)
    if isempty(perievent_reward(i).times)
        reaction_infusion(i) = NaN;
    else
    reaction_infusion(i) = perievent_reward(i).times(1);
    end
end

reaction_time.active = reaction_back;
reaction_time.inactive = reaction_front;
reaction_time.infusion = reaction_infusion;


hold on
for i = 1:length(data.Cue)-1
    if ~isempty(perievent_back(i).times)
        h3 = plot([perievent_back(i).times; perievent_back(i).times], [i, i+1], 'color', colors(1,:));
    end
end

hold on
for i = 1:length(data.Cue)-1
    if ~isempty(perievent_reward(i).times)
        h2 = plot([perievent_reward(i).times; perievent_reward(i).times], [i, i+1], 'k');
    end
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

