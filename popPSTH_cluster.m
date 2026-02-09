function popPSTH_cluster(norm_population_psth_avg, psth_time, high_taker, low_taker, colorIndex)
colors = cbrewer2('div', 'RdYlBu', 4);
e1 = std(norm_population_psth_avg(:, high_taker),1, 2, 'omitmissing')/sqrt(length(high_taker));
h1 = boundedline(psth_time, mean(norm_population_psth_avg(:, high_taker),2, 'omitmissing'), e1, 'cmap', colors(colorIndex(1),:), 'LineWidth',1);
hold on
e2 = std(norm_population_psth_avg(:, low_taker),1, 2, 'omitmissing')/sqrt(length(low_taker));
h2 = boundedline(psth_time, mean(norm_population_psth_avg(:, low_taker),2, 'omitmissing'), e2, 'cmap', colors(colorIndex(2),:), 'LineWidth',1);
xlim([-10, 50])
hold on
ylim([-0.5, 2])
plot([0, 0], [-1, 1.5], '--', 'Color', [1, 0, 0], 'LineWidth',1)
plot([19.50, 19.50], [-1, 1.5], '--', 'Color', [0.8, 0.8, 0.8],'LineWidth',1)
plot([40.00, 40.00], [-1, 1.5], '--','Color', [0.8, 0.8, 0.8], 'LineWidth',1)
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12, 'FontName', 'Arial')
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
% set(gcf, 'Position', [10 10 250 250]);
% set(gcf,'position',[100,100,340,340])
legend([h1, h2], {'High Drug Taking', 'Low Drug Taking'}, 'Box','off')
set(gcf, 'Color', 'w')
xlabel('Time (s)', 'FontSize',14, 'FontName', 'Arial')
ylabel('Z-Score', 'FontSize', 14, 'FontName', 'Arial')