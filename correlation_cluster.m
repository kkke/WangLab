function correlation_cluster(value_sustained, counts, high_taker, low_taker, colorIndex)
% figure
if isempty(find(isnan(value_sustained)))
    mdl = fitlm(value_sustained, counts)
else
    warning('some data have nan')
    include =~isnan(value_sustained);
    mdl = fitlm(value_sustained(include), counts(include))
end
hold on
h1 = plot(mdl);
% format the correlation graph
h1(1).Color = [0.8, 0.8, 0.8];
h1(1).Marker = 'o';
h1(1).MarkerFaceColor = [0.8,0.8,0.8];
h1(2).Color = [0, 0, 0];
h1(2).LineWidth = 1;
h1(3).Color = [0,0,0];
title('')
% 
hold on
colors = cbrewer2('div', 'RdYlBu', 4);
scatter(value_sustained(high_taker), counts(high_taker), 'MarkerFaceColor',colors(colorIndex(1),:), 'MarkerEdgeColor',colors(colorIndex(1),:))
scatter(value_sustained(low_taker), counts(low_taker), 'MarkerFaceColor',colors(colorIndex(2),:), 'MarkerEdgeColor',colors(colorIndex(2),:))
ylim([30, 120])
xlim([0, 1.6])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,250,250])
legend('off')
xlabel('Sustained DA (Z-Score 1-19.5 s)', 'FontSize', 14)
ylabel('Baseline Cocaine Infusions', 'FontSize', 14)