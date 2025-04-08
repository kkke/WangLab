clear;clc;close all
folder = 'H:\Data\FB_data\Dopamine\DAT_ChRmine_06\110724\';
file = 'DATChRmine06_110724_NAc_0002';
filename = [folder, file];

data_str = '/DataAcquisition/FPConsole/Signals/';
series = {'Series0001', 'Series0002','Series0003',};
i = 1;
dio01 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO01']);
dio02 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO02']);
dio03 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO03']);
dio04 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO04']);
% Convert TTL signals to events

dio_time = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/Time']);
[~, data(i).infusion] = detectEdges(dio02, dio_time);

data(i).raw_reference = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT01-LockIn/Values']);
data(i).raw_signal = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Values']);
data(i).raw_time = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Time']);

%% plot the data
i = 1
fb = fb_extract_doric;
[psth_t,psth_s, fig1] = fb.psth_fb(data(i).raw_signal, data(i).raw_time, data(i).infusion, -2, 4, 0, 'Stimulation');
[psth_tr,psth_ref, fig1] = fb.psth_fb(data(i).raw_reference, data(i).raw_time, data(i).infusion, -2, 4, 0, 'Stimulation');

figure;
rectangle('Position', [0, 0.4, 1 0.7], 'EdgeColor', 'w', 'FaceColor',[1, 1, 1]*0.7)
hold on
plot([-1, -1], [1, 1.1], 'Color','k', 'LineWidth',1)
% Add vertical text to the graph 
text(-1.2, 1.05, '0.1 Volt', 'Rotation', 90, 'FontSize', 12, 'HorizontalAlignment', 'center');
text(1.5, 1, '4W Stim', 'FontSize', 12, 'HorizontalAlignment', 'center')
scale = 0.2;
for i = 1:size(psth_s, 2)
    plot(psth_t(:, i), psth_s(:,i) + i *scale, LineWidth=1);
end
for i = 1:size(psth_ref, 2)
    plot(psth_tr(:, i), psth_ref(:,i) + i *scale + 0.3, 'LineWidth', 1,'Color', [1, 1, 1]*0.5);
end
set(gca, 'YColor', 'none'); 
set(gca, 'YTick', []);
xlabel('Time (s)', 'FontSize', 12)
% set(gca, 'XTickDir', 'out')
box off
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,400,300])

%% mask the stimulation
rectangle('Position', [-0.05, 0.4, 1.1 1], 'EdgeColor', 'w', 'FaceColor','w')
