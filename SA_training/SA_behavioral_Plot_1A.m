function SA_behavioral_Plot_1A(summarydata)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
colors = cbrewer('div', 'RdYlBu', 4);
sessionlength = size(summarydata, 1);
figure
ha = plot(summarydata.activeLeverPress , '-o', color = colors(1,:));
hold on
hi = plot(summarydata.inactiveLeverPress , '-o', color = colors(4,:));
set(ha, 'LineWidth', 1)
set(ha, 'MarkerFaceColor', 'w')
set(hi, 'LineWidth', 1)
set(hi, 'MarkerFaceColor', 'w')

legend([ha, hi], {'Active Lever','Inactive Lever'})
ylabel('Lever Press #')
xlim([0,sessionlength])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
xlabel('Session #')
title('Total Lever Press')
%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
ha = plot(summarydata.activeLeverPress_Cue , '-o', color = colors(1,:));

hold on
hi = plot(summarydata.inactiveLeverPress_Cue, '-o', color = colors(4,:));
set(ha, 'LineWidth', 1)
set(ha, 'MarkerFaceColor', 'w')
set(hi, 'LineWidth', 1)
set(hi, 'MarkerFaceColor', 'w')

legend([ha hi], {'Active Lever', 'Inactive Lever'})
ylabel('Lever Press #')
xlim([0,sessionlength])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
xlabel('Session #')
title('Futile Lever Press')

%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
h = plot(summarydata.Reward, '-o', color = colors(1,:));
set(h, 'LineWidth', 1)
set(h, 'MarkerFaceColor', 'w')
ylabel('Infusion #')
xlim([0,sessionlength])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
xlabel('Session #')
title('Drug Infusion')
end

