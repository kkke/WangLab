%% load all the files 
clear; close all; clc
directory = pwd;
files = dir('*.csv');
data = [];
for i = 1:length(files)
    temp = readtable(files(i).name);
    data = [data; temp];
end
data = renamevars(data, 'Var1', 'animalID');

m_morphine_naloxone = strcmp(data.gender, 'm') & strcmp(data.treatment, 'morphine-naloxone');
m_morphine_saline   = strcmp(data.gender, 'm') & strcmp(data.treatment, 'morphine-saline');
m_saline_naloxone   = strcmp(data.gender, 'm') & strcmp(data.treatment, 'saline-naloxone');

data_morphine_naloxone = data(m_morphine_naloxone, 4:end);
data_morphine_saline = data(m_morphine_saline, 4:end);
data_saline_naloxone = data(m_saline_naloxone, 4:end);

data_m = [table2array(data_morphine_naloxone); table2array(data_morphine_saline); table2array(data_saline_naloxone)];
%%
index_info = readtable('brain_index_info.csv', 'NumHeaderLines', 1);
index_info = renamevars(index_info, ["Var1", "Var2"], ["brain_region", "Counts"]);
figure; imagesc(data_m')
colormap(jet)
index = cumsum(index_info.Counts)
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
xlim([0, 10])
colors = cbrewer('div', 'RdYlBu', 9);
hold on
for i = 1:length(index)
    if i == 1
        rectangle('Position',[0, 0, 0.5, index(i)], 'FaceColor', colors(i,:))
    else
        rectangle('Position',[0, index(i-1), 0.5, index(i)-index(i-1)], 'FaceColor', colors(i,:))
    end
end
set(gca,'XTick',[])
set(gca,'YTick',[])
h = colorbar;
ylabel(h, 'cFos Density (counts/mm^3)')
caxis([0, 40000])
set(gcf,'position',[100,100,300,800])
%% get the female data
f_morphine_naloxone = strcmp(data.gender, 'f') & strcmp(data.treatment, 'morphine-naloxone');
f_morphine_saline   = strcmp(data.gender, 'f') & strcmp(data.treatment, 'morphine-saline');
f_saline_naloxone   = strcmp(data.gender, 'f') & strcmp(data.treatment, 'saline-naloxone');

data_morphine_naloxone_f = data(f_morphine_naloxone, 4:end);
data_morphine_saline_f = data(f_morphine_saline, 4:end);
data_saline_naloxone_f = data(f_saline_naloxone, 4:end);

data_f = [table2array(data_morphine_naloxone_f); table2array(data_morphine_saline_f); table2array(data_saline_naloxone_f)];
%% plot the female data
index_info = readtable('brain_index_info.csv', 'NumHeaderLines', 1);
index_info = renamevars(index_info, ["Var1", "Var2"], ["brain_region", "Counts"]);
figure; imagesc(data_f')
colormap(jet)
index = cumsum(index_info.Counts)
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
xlim([0, 10])
colors = cbrewer('div', 'RdYlBu', 9);
hold on
for i = 1:length(index)
    if i == 1
        rectangle('Position',[0, 0, 0.5, index(i)], 'FaceColor', colors(i,:))
    else
        rectangle('Position',[0, index(i-1), 0.5, index(i)-index(i-1)], 'FaceColor', colors(i,:))
    end
end
set(gca,'XTick',[])
set(gca,'YTick',[])
h = colorbar;
ylabel(h, 'cFos Density (counts/mm^3)')
set(gca,'fontsize',12)
caxis([0, 40000])
set(gcf,'position',[100,100,300,800])

%% plot for individual brain regions
figure
for i = 1: size(data_morphine_naloxone, 1)
    plot(data_morphine_naloxone{i,:}, 'o', 'color', colors(1,:))
    hold on
end
xlim([1, 17])

for i = 1: size(data_morphine_saline, 1)
    plot(data_morphine_saline{i,:}, 'o', 'color', colors(9,:))
    hold on
end
xlim([1, 17])

line_errorbar_drc