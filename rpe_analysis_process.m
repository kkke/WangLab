function data = rpe_analysis_process(data_directory)
T = readtable([data_directory, '/Fluorescence.csv']);
data.time = T.TimeStamp/1000;
data.F470 = T.CH1_470;
data.F410 = T.CH1_410;
events = T.Markings;
idx_sound = find(contains(events, "Input1*2*0;"));
idx_water = find(contains(events, "Input2*2*0;")); % the Fiber photometry systems somehow has some contamination of Input2*2*0 into "Input1*2*0;
diff_sound_water = setdiff(idx_water, idx_sound);
data.sound_ts = data.time(idx_sound);
data.water_ts = data.time(diff_sound_water);

cs_plus = NaN;
% extract the CS+
for i = 1:length(data.water_ts)
    % find all A that are within 3 sec after B(i)
    candidates = data.sound_ts(data.sound_ts >= data.water_ts(i)-3 & data.sound_ts <= data.water_ts(i));
    if ~isempty(candidates)
        cs_plus(i) = candidates(1);  % take first one
    end
end
cs_minus = setdiff(data.sound_ts, cs_plus);
data.cs_plus = cs_plus(~isnan(cs_plus));
data.cs_minus = cs_minus(~isnan(cs_minus));
save('raw_data.mat', 'data')
%% plot the raw data
figure;
plot(data.time, data.F470, 'g')
hold on
plot(data.time, data.F410, 'k')
for i = 1:length(data.sound_ts)
    plot([data.sound_ts(i),data.sound_ts(i)], [200, 400], 'r')
end

for i = 1:length(data.water_ts)
    plot([data.water_ts(i),data.water_ts(i)], [200, 400], 'm')
end
set(gcf, 'Position', [100 100 900 300]);  % [left bottom width height]
xlabel('Time(s)')
ylabel('Fluorescent Intensity')

%% Correct baseline drift
win = length(find(data.time<=60)) % 60 s windown   
n= length(data.F470);
F0  = nan(size(data.F470));
half = floor(win/2);
for i = 1:n
    i1 = max(1, i-half);
    i2 = min(n, i+half);
    data.F0(i) = prctile(data.F470(i1:i2), 10);
end
data.dFF = (data.F470 - data.F0')./data.F0';
plot(data.time, data.F0);

figure;
plot(data.time, data.dFF)
%% Plot the PSTH
fb = fb_extract_doric;
[data.psth_time, data.psth_csplus, ~]  = fb.psth_fb(data.dFF, data.time, data.cs_plus, -2, 8, 0, 'CS+');
[data.psth_time, data.psth_csminus, ~] = fb.psth_fb(data.dFF, data.time, data.cs_minus, -2, 8, 0, 'CS+');
colors = cbrewer2('div', 'RdYlBu', 4);
figure;
rectangle('Position',[0, 0, 1, 0.2], 'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'none')
hold on 
plot([1.5, 1.5], [0, 0.2], '-k', 'LineWidth',1)
psth_time = mean(data.psth_time, 2);
e1 = std(data.psth_csplus,1, 2, 'omitmissing')/sqrt(size(data.psth_csplus,2));
h1 = boundedline(psth_time, mean(data.psth_csplus, 2, 'omitmissing'), e1, 'cmap', colors(1,:), 'LineWidth',1);
hold on
e2 = std(data.psth_csminus,1, 2, 'omitmissing')/sqrt(size(data.psth_csminus,2));
h2 = boundedline(psth_time, mean(data.psth_csminus, 2, 'omitmissing'), e2, 'cmap', colors(4,:), 'LineWidth',1);
ylim([0, 0.2])
set(gcf, 'Position', [100 100 300 300]);  % [left bottom width height]
legend([h1, h2], {'CS+', 'CS-'})
ylabel('dF/F')
xlabel('Time (s)')
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
set(gcf,'position',[100,100,250,250])
xlim([-2, 8])
save('process_data.mat', 'data')


