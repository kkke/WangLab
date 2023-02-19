function [psth_time,psth_signal] = psth_fb(data,time, event, pre, post)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%
% data = Signal_concat;
% time = Time_concat;
% event = DIO.infusion;
% pre = -5; % in secs
% post= 5; % in secs
sample_rate = 1/mean(diff(time(1:1000)));
sample_size = floor((post-pre) * sample_rate);
index = [];
psth_signal = zeros(sample_size, length(event));
psth_time   = zeros(sample_size, length(event));
for i = 1:length(event)
    index = find(time> event(i) + pre & time < event(i) + post);
    if length(index)< sample_size
    else
        psth_time(:, i) = time(index(1:sample_size)) -  event(i);
        psth_signal(:,i) = data(index(1:sample_size));
    end
end

figure;
subplot(2,1,1)
plot(mean(psth_time, 2), mean(psth_signal, 2), 'k')
hold on
x = mean(psth_time, 2);
y = mean(psth_signal, 2);
e = std(psth_signal,1, 2)/sqrt(size(psth_signal, 2));
boundedline(x, y, e, '-k');
xlabel('Time (s)')
ylabel('\Delta F/F')
xlim([min(mean(psth_time, 2)), max(mean(psth_time, 2))])
ylim([-0.1, 0.1])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,300,400])
subplot(2, 1, 2)
imagesc(mean(psth_time, 2),[] ,psth_signal')
% colorbar
xlabel('Time (s)')
ylabel('Trials')
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,300,400])
colormap('jet')
caxis([-0.1, 0.2])
box off
end

