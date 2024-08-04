function SA_behavioral_Plot_1A(summarydata)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
colors = cbrewer('div', 'RdYlBu', 4);
sessionlength = size(summarydata, 1);


figure
high = 1400;
fr1 = find(dataRaw.FR ==1); 
rectangle('position', [fr1(1), 1, fr1(end)-fr1(1), high], 'FaceColor', [colors(4,:),0.3], 'EdgeColor', 'none')
text(fr1(1), high + 40, 'FR1')
fr2 = find(dataRaw.FR ==2);
rectangle('position', [fr2(1), 1, fr2(end)-fr2(1), high], 'FaceColor', [colors(4,:),0.5], 'EdgeColor', 'none')
text(fr2(1), high + 40, 'FR2')
fr4 = find(dataRaw.FR ==4);
rectangle('position', [fr4(1), 1, fr4(end)-fr4(1), high], 'FaceColor', [colors(4,:),0.7], 'EdgeColor', 'none')
text(fr4(1), high + 40, 'FR4')
hold on
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
set(gcf,'position',[100,100,400,300])
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

