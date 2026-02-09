function plot_example_mouse(psth_time, data_to_plot, i)
figure;
tiledlayout("vertical", 'TileSpacing', 'compact', 'Padding', 'compact')
nexttile
%%%
data_to_plot(i).norm_psth_infusion = movmean(data_to_plot(i).norm_psth_infusion, 13);
%%%

imagesc(psth_time',[], data_to_plot(i).norm_psth_infusion') % cocaine 19; fentanyl 23
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
xlim([-10, 20])
set(gca, 'XTick', [], 'XTickLabel', []);
box off
title('High Drug Taking')

nexttile
x = mean(psth_time, 2, 'omitnan');
y = mean(data_to_plot(i).norm_psth_infusion, 2, 'omitnan');
e = std(data_to_plot(i).norm_psth_infusion,1, 2, 'omitmissing')/sqrt(size(data_to_plot(i).norm_psth_infusion, 2));
boundedline(x, y, e, '-k');
xlabel('Time (s)','FontName', 'Arial')
ylabel('Z-Score','FontName', 'Arial')
xlim([-10, 50])
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
xlim([-10, 20])