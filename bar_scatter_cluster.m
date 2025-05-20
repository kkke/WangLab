function bar_scatter_cluster(fano_value, high_taker, low_taker, clusterID)
baf = behavior_analysis_func;
figure
colors = cbrewer2('div', 'RdYlBu', 4);
data_bar = {fano_value(high_taker),fano_value(low_taker) };
for i = 1:length(data_bar)
    mean_value = mean(data_bar{i});
    sem_value = std(data_bar{i})./sqrt(length(data_bar{i}));
    b = bar(i, mean_value);
    b.FaceColor = 'flat';
    switch i 
        case 1
    b.CData(1,:) = colors(2, :);
        case 2
    b.CData(1,:) = colors(3, :);
    end
    b.FaceAlpha = 0.4;
    hold on
    errorbar(i, mean_value, sem_value,'k.', 'LineWidth', 1, 'CapSize',10)
end
for i = 1:4
    switch i
        case 1

            scatter(i + 0.3* (rand(size(fano_value(find(clusterID == i))))-0.5), fano_value(find(clusterID == i)), 'MarkerEdgeColor', 'none', 'MarkerFaceColor',colors(2,:))
        case 2
            scatter(i + 0.3* (rand(size(fano_value(find(clusterID == i))))-0.5), fano_value(find(clusterID == i)), 'MarkerEdgeColor', 'none', 'MarkerFaceColor',colors(3,:))
        case 3
            scatter(1 + 0.3* (rand(size(fano_value(find(clusterID == i))))-0.5), fano_value(find(clusterID == i)), 'MarkerEdgeColor', 'none', 'MarkerFaceColor',colors(2,:))
        case 4
            scatter(2 + 0.3* (rand(size(fano_value(find(clusterID == i))))-0.5), fano_value(find(clusterID == i)), 'MarkerEdgeColor', 'none', 'MarkerFaceColor',colors(3,:))

    end
end
xlabel('Drug Taking', 'FontSize', 14);
ylabel('Infusion #');
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,150,250])
% set(gca,'XTick',[1, 2, 3, 4])
xticks([1 2]);
xticklabels({'High', 'Low'});
ylabel('Fano Factor')
ylim([0, 5])

[h,p] = ttest2(data_bar{1}, data_bar{2})