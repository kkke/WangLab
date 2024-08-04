%% plot the dose response curve for fentanyl
% start new concentration from 10/13/22; extract data from 10/05/22
index = zeros(length(data_sum),1);
for i = 1:length(data_sum)
       index (i) = find(data_sum{i}.date == 20221005);
       subdata{i} = data_sum{i}(index(i):end, :);
end
colors = cbrewer('div', 'RdYlBu', 4);
plot_variable = {'Reward', 'activeLeverPress', 'inactiveLeverPress'}
figure
for j = 1:length(plot_variable)
    subplot(1,3,j)
    for i = 1 : length(subdata)
        h(i) = plot(subdata{i}.(plot_variable{j}) , '-o', color = colors(i,:));
        hold on
        set(h(i), 'LineWidth', 1)
        set(h(i), 'MarkerFaceColor', 'w')
    end
    legend([h(1), h(2), h(3)], {'SSA41', 'SSA44', 'SSA48'})
    ylabel(plot_variable{j})
    set(gca,'XTick',0:5:25)
    xlim([0,26])
    box off
    set(gca,'TickDir','out')
    set(gca,'fontsize',12)
    set(gca,'TickLengt', [0.015 0.015]);
    set(gca, 'LineWidth',1)
end
set(gcf,'position',[100,100,1200,400])

%% plot the summarized data

figure
avg_data = []
for j = 1:length(plot_variable)
    subplot(1,3,j)
    for i = 1:length(subdata)
        temp = subdata{i}.(plot_variable{j});
        for k = 1: 5 % test five different concentration
            index_pre = (k-1)*5 + 1;
            index_post = k*5;
            temp_avg(k) = mean(temp(index_pre:index_post));
        end
        avg_data{i}.(plot_variable{j}) = temp_avg;
        h(i) = plot(avg_data{i}.(plot_variable{j}) , '-o', color = colors(i,:));
        hold on
        set(h(i), 'LineWidth', 1)
        set(h(i), 'MarkerFaceColor', 'w')
    end
    clear temp_avg
    legend([h(1), h(2), h(3)], {'SSA41', 'SSA44', 'SSA48'})
    ylabel(plot_variable{j})
    set(gca,'XTick',0:1:6)
    xlim([0,6])
    box off
    set(gca,'TickDir','out')
    set(gca,'fontsize',12)
    set(gca,'TickLengt', [0.015 0.015]);
    set(gca, 'LineWidth',1)
end
set(gcf,'position',[100,100,1200,400])
%% filling the concentration information
% concentration unit: ug/kg/infusion
concentration = [3, 5, 10, 1, 0.5];
concentration_repeats = repmat(concentration, 5, 1);
concentration_fill = concentration_repeats(:);
for i = 1:length(data_sum)
    subdata{i}.concentration = concentration_fill;
    avg_data{i}.concentration = concentration;
end
%%
figure
for j = 1:length(plot_variable)
    [B, I] = sort(avg_data{1}.concentration);
    group_data =[];
    P(j) = subplot(1,3,j)
    for i = 1:length(avg_data)
        h(i) = semilogx(B,avg_data{i}.(plot_variable{j})(I) , '-o', color = colors(i,:));
        group_data = [group_data; avg_data{i}.(plot_variable{j})(I)];
        hold on
        set(h(i), 'LineWidth', 1)
        set(h(i), 'MarkerFaceColor', 'w')
    end
    semilogx(B, mean(group_data, 1), '-o')
    clear temp_avg
    legend([h(1), h(2), h(3)], {'SSA41', 'SSA44', 'SSA48'})
    ylabel(plot_variable{j})
    set(gca,'XTick',B)
    xlim([0,12])
    box off
    set(gca,'TickDir','out')
    set(gca,'fontsize',12)
    set(gca,'TickLengt', [0.015 0.015]);
    set(gca, 'LineWidth',1)
    xlabel('Fentanyl (ug/kg/infusion)')
    title(plot_variable{j})
end
set(P(1),'Ylim', [0, 60])
set(P(2),'Ylim', [0, 500])
set(P(3), 'Ylim', [0, 150])
set(gcf,'position',[100,100,1200,300]) 

save('data_for_concentration.mat', 'subdata', 'data_sum', 'avg_data', 'colors', 'concentration')