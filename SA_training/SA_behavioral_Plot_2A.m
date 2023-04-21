function SA_behavioral_Plot_2A(data_sum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
colors = cbrewer('div', 'RdYlBu', 4);

figure
for i = 1 : length(data_sum)
    ha(i) = plot(data_sum{i}.activeLeverPress , '-o', color = colors(i,:));
    
    hold on
    hi(i) = plot(data_sum{i}.inactiveLeverPress , '-o', color = colors(5-i,:));
    set(ha(i), 'LineWidth', 1)
    set(ha(i), 'MarkerFaceColor', 'w')
    set(hi(i), 'LineWidth', 1)
    set(hi(i), 'MarkerFaceColor', 'w')
end
legend([ha(1), hi(1), ha(2), hi(2)], {'Mouse #1 Active Lever', ...
    'Mouse #1 Inactive Lever', 'Mouse #2 Active Lever', 'Mouse #2 Inactive Lever'})
ylabel('Lever Press #')
xlim([0,8])
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
for i = 1 : length(data_sum)
    ha(i) = plot(data_sum{i}.activeLeverPress_Cue , '-o', color = colors(i,:));
    
    hold on
    hi(i) = plot(data_sum{i}.inactiveLeverPress_Cue, '-o', color = colors(5-i,:));
    set(ha(i), 'LineWidth', 1)
    set(ha(i), 'MarkerFaceColor', 'w')
    set(hi(i), 'LineWidth', 1)
    set(hi(i), 'MarkerFaceColor', 'w')
end
legend([ha(1), hi(1), ha(2), hi(2)], {'Mouse #1 Active Lever', ...
    'Mouse #1 Inactive Lever', 'Mouse #2 Active Lever', 'Mouse #2 Inactive Lever'})
ylabel('Lever Press #')
xlim([0,8])
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
for i = 1 : length(data_sum)
    ha(i) = plot(data_sum{i}.Reward, '-o', color = colors(i,:));
    
    hold on
  
    set(ha(i), 'LineWidth', 1)
    set(ha(i), 'MarkerFaceColor', 'w')

end
legend([ha(1),  ha(2)], {'Mouse #1', ...
    'Mouse #2 '})
ylabel('Infusion #')
xlim([0,8])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,400])
xlabel('Session #')
title('Drug Infusion')
end

