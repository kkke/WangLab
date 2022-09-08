function psth_plot_sa(unit)
figure
CT=cbrewer('div', 'RdYlBu', 6); % for nice color
colorIdx = [2,6];
h1 = subplot(2,1,1);
set(h1, 'Position', [.15 0.55 .7 .35]);
for i = 1:length(unit.spikeraster)
    if ~isempty(unit.spikeraster(i).times)
        scatter(unit.spikeraster(i).times, i*ones(size(unit.spikeraster(i).times)), 6, '.','k')
        hold on
        for j = 1:length(unit.spikeraster(i).times)
            plot([unit.spikeraster(i).times(j), unit.spikeraster(i).times(j)], [i-1,i], 'k', 'LineWidth',1)
        end
    end
end

hold off
% ylim([0,length(spike.raster)])
axis off
box off
ylabel('Trial #')
% title(['Neuron ', num2str(neuron_num)])

h2 = subplot(2,1,2);
set(h2, 'Position', [.15 0.2 .7 .35]);
hold on
plot(unit.timepoint,unit.FR_avg, 'k', 'LineWidth', 1) % box smooth
ylabel('Firing rate (Hz)')
xlabel('Time (ms)')
ylim([0,max(unit.FR_avg)/0.8])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,200,500,400])
hold off
% CT=cbrewer('div', 'RdYlBu', 6); % for nice color
% e = errorbar(mean(data,2),err, '-s','MarkerSize',6,'MarkerFaceColor', CT(6,:), 'Color',CT(6,:), 'LineWidth',1);
