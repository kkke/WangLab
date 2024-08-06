classdef fb_extract_doric
    methods
        function data = load_pickle(folder)
            % Load pikle files
            Session = {'Taking', 'Punishment', 'Seeking', 'Non-Contingent'};
            data = [];
            for j = 1:length(Session)
                filenames = dir([folder, '/', Session{j}, '/*.mat']);
                for i = 1:length(filenames)
                    filename = filenames(i).name;
                    filename_split =  split(filename, '_');
                    animalID = filename_split{1};
                    date     = filename_split{2};
                    region   = filename_split{3}(1:end-4);
                    tempdata = extract_pkl([folder, '/', Session{j}, '/', filename], animalID, date, Session{j}, region);
                    data = [data, tempdata];
                end
            end
        end

        function all_data = load_ch2_threeSeries_ployfit(obj, filename)
            % Extract data from .doric files
            data = [];
            all_data = [];
            data_str = '/DataAcquisition/FPConsole/Signals/';
            series = {'Series0001', 'Series0002', 'Series0003'};
            for i = 1:length(series)
                % Load Digital Input
                dio01 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO01']);
                dio02 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO02']);
                dio03 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO03']);
                dio04 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO04']);
                % Convert TTL signals to events

                dio_time = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/Time']);
                [~, data(i).infusion] = detectEdges(dio02, dio_time);
                [~, data(i).front]    = detectEdges(dio03, dio_time);
                [~, data(i).back]     = detectEdges(dio04, dio_time);
                [data(i).leverRetraction, data(i).leverInsertion] = detectEdges(dio01, dio_time);
                % Load data from Channel 2
                data(i).raw_reference = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT01-LockIn/Values']);
                data(i).raw_signal = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Values']);
                data(i).raw_time = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Time']);
                % Processed data
                data(i).smooth_signal   = movmean(data(i).raw_signal, 60 * 100);
                data(i).smooth_reference = movmean(data(i).raw_reference, 60 * 100);
                data(i).signal = data(i).raw_signal - data(i).smooth_signal;
                data(i).reference = data(i).raw_reference - data(i).smooth_reference;
                data(i).signal = (data(i).signal - median(data(i).signal))/std(data(i).signal);
                data(i).reference = (data(i).reference - median(data(i).reference))/std(data(i).reference);
                figure;
                subplot(3, 1, 2)
                scatter(data(i).reference, data(i).signal, '.')
                p = polyfit(data(i).reference, data(i).signal, 1);
                data(i).reference = movmean(polyval(p, data(i).reference), 60);
                data(i).signal        = data(i).signal - data(i).reference;
                subplot(3, 1, 1)
                plot(data(i).raw_time, data(i).raw_signal, 'k')
                hold on
                plot(data(i).raw_time, data(i).smooth_signal, 'r')
                plot(data(i).raw_time, data(i).raw_reference, 'k')
                plot(data(i).raw_time, data(i).smooth_reference, 'r')
                subplot(3, 1, 3)
                plot(data(i).raw_time, data(i).signal, 'r')
                hold on
                plot(data(i).raw_time, data(i).reference, 'k')


            end
            % reduce the dimension of data
            for i = 1:length(data)
                if i ==1
                    all_data = data(i);
                else
                    fn = fieldnames(all_data);
                    for j = 1:length(fn)
                        all_data.(fn{j}) = [all_data.(fn{j}); data(i).(fn{j})];
                    end
                end
            end
        end


        function all_data = load_ch2_threeSeries(obj, filename)
            % Extract data from .doric files
            data = [];
            all_data = [];
            data_str = '/DataAcquisition/FPConsole/Signals/';
            series = {'Series0001', 'Series0002','Series0003'};
            for i = 1:length(series)
                % Load Digital Input
                dio01 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO01']);
                dio02 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO02']);
                dio03 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO03']);
                dio04 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO04']);
                % Convert TTL signals to events

                dio_time = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/Time']);
                [~, data(i).infusion] = detectEdges(dio02, dio_time);
                [~, data(i).front]    = detectEdges(dio03, dio_time);
                [~, data(i).back]     = detectEdges(dio04, dio_time);
                [data(i).leverRetraction, data(i).leverInsertion] = detectEdges(dio01, dio_time);
                % Load data from Channel 2
                data(i).raw_reference = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT01-LockIn/Values']);
                data(i).raw_signal = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Values']);
                data(i).raw_time = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Time']);
                %%% Load Processed data
                data(i).signal = h5read([filename, '_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN02xAOUT02-LockIn/Values']);
                data(i).time = h5read([filename, '_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN02xAOUT02-LockIn/Time']);
                % perform moving average with 0.1 s
                % sr = 1/(data(i).time(2) - data(i).time(1));
                % k = ceil(sr * 0.1);
                % data(i).signal = movmean(data(i).signal, k);
                %
                % Load data from Channel 4
                % data(i).raw_reference = h5read([filename, '.doric'], [data_str, series{i}, '/AIN04xAOUT01-LockIn/Values']);
                % data(i).raw_signal = h5read([filename, '.doric'], [data_str, series{i}, '/AIN04xAOUT02-LockIn/Values']);
                %
                % % data(i).raw_time = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Time']);
                % % Load Processed data
                % data(i).signal = h5read([filename, '_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN04xAOUT02-LockIn/Values']);
                % data(i).time = h5read([filename, '_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN04xAOUT02-LockIn/Time']);

            end
            % reduce the dimension of data
            for i = 1:length(data)
                if i ==1
                    all_data = data(i);
                else
                    fn = fieldnames(all_data);
                    for j = 1:length(fn)
                        all_data.(fn{j}) = [all_data.(fn{j}); data(i).(fn{j})];
                    end
                end
            end
        end

        function all_data = load_ch2_oneSeries(obj, filename)


            % Extract data from .doric files
            data = [];
            all_data = [];
            data_str = '/DataAcquisition/FPConsole/Signals/';
            series = {'Series0001'};
            for i = 1:length(series)
                % Load Digital Input
                dio01 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO01']);
                dio02 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO02']);
                dio03 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO03']);
                dio04 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO04']);
                % Convert TTL signals to events

                dio_time = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/Time']);
                [~, data(i).infusion] = detectEdges(dio02, dio_time);
                [~, data(i).front]    = detectEdges(dio03, dio_time);
                [~, data(i).back]     = detectEdges(dio04, dio_time);
                [data(i).leverRetraction, data(i).leverInsertion] = detectEdges(dio01, dio_time);
                % Load data from Channel 2
                data(i).raw_reference = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT01-LockIn/Values']);
                data(i).raw_signal = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Values']);
                data(i).raw_time   = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Time']);
                % Load Processed data
                data(i).signal = h5read([filename, '_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN02xAOUT02-LockIn/Values']);
                data(i).time = h5read([filename, '_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN02xAOUT02-LockIn/Time']);
            end
            % reduce the dimension of data
            for i = 1:length(data)
                if i ==1
                    all_data = data(i);
                else
                    fn = fieldnames(all_data);
                    for j = 1:length(fn)
                        all_data.(fn{j}) = [all_data.(fn{j}); data(i).(fn{j})];
                    end
                end
            end
        end

        function all_data = load_green_red_threeSeries(obj, filename)

            % Extract data from .doric files
            data = [];
            all_data = [];
            data_str = '/DataAcquisition/FPConsole/Signals/';
            series = {'Series0001', 'Series0002', 'Series0003'};
            for i = 1:length(series)
                % Load Digital Input
                dio01 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO01']);
                dio02 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO02']);
                dio03 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO03']);
                dio04 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO04']);
                % Convert TTL signals to events

                dio_time = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/Time']);
                [~, data(i).infusion] = detectEdges(dio02, dio_time);
                [~, data(i).front]    = detectEdges(dio03, dio_time);
                [~, data(i).back]     = detectEdges(dio04, dio_time);
                [data(i).leverRetraction, data(i).leverInsertion] = detectEdges(dio01, dio_time);
                % Load data from Channel 2
                data(i).raw_reference = h5read([filename, '.doric'], [data_str, series{i}, '/AIN01xAOUT03-LockIn/Values']);
                data(i).raw_signal = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Values']);

                % Load Processed data
                data(i).signal = h5read([filename, '_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN02xAOUT02-LockIn/Values']);
                data(i).time = h5read([filename, '_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN02xAOUT02-LockIn/Time']);
            end
            % reduce the dimension of data
            for i = 1:length(data)
                if i ==1
                    all_data = data(i);
                else
                    fn = fieldnames(all_data);
                    for j = 1:length(fn)
                        all_data.(fn{j}) = [all_data.(fn{j}); data(i).(fn{j})];
                    end
                end
            end
        end

        function all_data = load_green_red_oneSeries(obj, filename)

            % Extract data from .doric files
            data = [];
            all_data = [];
            data_str = '/DataAcquisition/FPConsole/Signals/';
            series = {'Series0001'};
            for i = 1:length(series)
                % Load Digital Input
                dio01 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO01']);
                dio02 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO02']);
                dio03 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO03']);
                dio04 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO04']);
                % Convert TTL signals to events

                dio_time = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/Time']);
                [~, data(i).infusion] = detectEdges(dio02, dio_time);
                [~, data(i).front]    = detectEdges(dio03, dio_time);
                [~, data(i).back]     = detectEdges(dio04, dio_time);
                [data(i).leverRetraction, data(i).leverInsertion] = detectEdges(dio01, dio_time);
                % Load data from Channel 2
                data(i).raw_reference = h5read([filename, '.doric'], [data_str, series{i}, '/AIN01xAOUT03-LockIn/Values']);
                data(i).raw_signal = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Values']);

                % Load Processed data
                data(i).signal = h5read([filename, '_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN02xAOUT02-LockIn/Values']);
                data(i).time = h5read([filename, '_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN02xAOUT02-LockIn/Time']);
            end
            % reduce the dimension of data
            for i = 1:length(data)
                if i ==1
                    all_data = data(i);
                else
                    fn = fieldnames(all_data);
                    for j = 1:length(fn)
                        all_data.(fn{j}) = [all_data.(fn{j}); data(i).(fn{j})];
                    end
                end
            end
        end


        function data = fill_metadata(obj, data, filename, session)
            filename_split =  split(filename, '_');
            animalID = filename_split{1};
            date     = filename_split{2};
            region   = filename_split{3};
            data.animalID = animalID;
            data.date     = date;
            data.session  = session;
            data.region   = region;

        end

        function summarydata = save_data(obj, data, folder)
            cd(folder)
            cd ..
            switch exist('summary.mat')
                case 0
                    disp('Summary file not exist, Create a new one')
                    summarydata = data;
                    save('summary.mat', 'summarydata')
                case 2
                    clear summarydata
                    disp('Summary file already exists, Load the summary file and fill in more data')
                    load('summary.mat')
                    summarydata = [summarydata, data];
                    save('summary.mat', "summarydata")
            end
        end

        function all_data = load_oneSeries_green_red(obj, filename)

            % Extract data from .doric files
            data = [];
            all_data = [];
            data_str = '/DataAcquisition/FPConsole/Signals/';
            series = {'Series0001'};
            for i = 1:length(series)
                % Load Digital Input
                dio01 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO01']);
                dio02 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO02']);
                dio03 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO03']);
                dio04 = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/DIO04']);
                % Convert TTL signals to events

                dio_time = h5read([filename, '.doric'], [data_str, series{i}, '/', '/DigitalIO/Time']);
                [~, data(i).infusion] = detectEdges(dio02, dio_time);
                [~, data(i).front]    = detectEdges(dio03, dio_time);
                [~, data(i).back]     = detectEdges(dio04, dio_time);
                [data(i).leverRetraction, data(i).leverInsertion] = detectEdges(dio01, dio_time);
                % Load data from Channel 2
                data(i).raw_reference = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT01-LockIn/Values']);
                data(i).raw_signal465 = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Values']);
                data(i).raw_signal560 = h5read([filename, '.doric'], [data_str, series{i}, '/AIN01xAOUT03-LockIn/Values']);

                data(i).raw_time   = h5read([filename, '.doric'], [data_str, series{i}, '/AIN02xAOUT02-LockIn/Time']);
                % Load Processed data
                data(i).GCaMPsignal = h5read([filename, '_GCaMP_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN02xAOUT02-LockIn/Values']);
                data(i).GCaMPtime = h5read([filename, '_GCaMP_DFF.doric'], ['/DataProcessed/FPConsole/DFFSignals/', series{i}, '/AIN02xAOUT02-LockIn/Time']);
                data(i).rDAsignal = h5read([filename, '_rDA_DFF1.doric'], ['/DataProcessed/FPConsole/DFFSignals1/', series{i}, '/AIN01xAOUT03-LockIn/Values']);
                data(i).rDAtime = h5read([filename, '_rDA_DFF1.doric'], ['/DataProcessed/FPConsole/DFFSignals1/', series{i}, '/AIN01xAOUT03-LockIn/Time']);

            end
            all_data = data;
        end

        function [psth_time,psth_signal, fig] = psth_fb(obj, data,time, event, pre, post, plot_var, fig_title)
            %UNTITLED4 Summary of this function goes here
            %   Detailed explanation goes here
            %
            % data = Signal_concat;
            % time = Time_concat;
            % event = DIO.infusion;
            % pre = -5; % in secs
            % post= 5; % in secs
            sample_rate = 1/mean(diff(time(2000:5000)));
            sample_size = floor((post-pre) * sample_rate);
            index = [];
            psth_signal = zeros(sample_size, length(event));
            psth_time   = zeros(sample_size, length(event));
            if isempty(event)
                % psth_signal = NaN;
                % psth_time   = NaN;
                fig = [];
            else
                for i = 1:length(event)
                    index = find(time> event(i) + pre & time < event(i) + post);
                    if length(index)< sample_size
                        psth_time(:, i) = NaN;
                        psth_signal(:,i) = NaN;
                    else
                        psth_time(:, i) = time(index(1:sample_size)) -  event(i);
                        psth_signal(:,i) = data(index(1:sample_size));
                    end
                end
                % Remove NaN column
                idx = ~any(isnan(psth_signal), 1);
                psth_signal = psth_signal(:, idx);
                idx2 = ~any(isnan(psth_time), 1);
                psth_time    = psth_time(:, idx2);
                if plot_var ==1
                    fig = figure;
                    subplot(2,1,1)
                    plot(mean(psth_time, 2, 'omitnan'), mean(psth_signal, 2, 'omitnan'), 'k')
                    hold on
                    x = mean(psth_time, 2, 'omitnan');
                    y = mean(psth_signal, 2, 'omitnan');
                    e = std(psth_signal,1, 2, 'omitmissing')/sqrt(size(psth_signal, 2));
                    boundedline(x, y, e, '-k');
                    xlabel('Time (s)')
                    ylabel('Z \Delta F/F')
                    xlim([min(mean(psth_time, 2, 'omitnan')), max(mean(psth_time, 2, 'omitnan'))])
                    % ylim([-0.1, 0.1])
                    ylim([-1, 1])
                    plot([0, 0], [-1, 1], 'r--')
                    plot([19.50, 19.50], [-1, 1], '--')
                    plot([40.00, 40.00], [-1, 1], '--')
                    % title(fig_title)

                    box off
                    set(gca,'TickDir','out')
                    set(gca,'fontsize',12)
                    set(gca,'TickLengt', [0.015 0.015]);
                    set(gca, 'LineWidth',1)
                    set(gcf,'position',[100,100,300,400])
                    subplot(2, 1, 2)
                    imagesc(mean(psth_time, 2, 'omitnan'),[] ,psth_signal')
                    % colorbar
                    xlabel('Time (s)')
                    ylabel('Trials')
                    set(gca,'TickDir','out')
                    set(gca,'fontsize',12)
                    set(gca,'TickLengt', [0.015 0.015]);
                    set(gca, 'LineWidth',1)
                    set(gcf,'position',[100,100,600,600])
                    colormap('jet')
                    clim([-2, 5])
                    box off
                else
                    fig = [];
                end
            end

        end

        function Pairline_plot(obj, a)
            figure;
            colors = cbrewer('div', 'RdYlBu', 4);

            bar(1,mean(a(:,1), 'omitnan'),'EdgeColor',[0 0 0],'FaceColor',[0.5, 0.5, 0.5],'LineWidth',1);
            hold on
            bar(2,mean(a(:,2), 'omitnan'),'EdgeColor',[0 0 0],'FaceColor',colors(3,:),'LineWidth',1);
            if size(a, 2) ==3
                bar(3,mean(a(:,3), 'omitnan'),'EdgeColor',[0 0 0],'FaceColor',colors(4,:),'LineWidth',1);
            end
            plot(a','-o','Color','k', 'LineWidth',1)
            hold on
            set(gca,'XTick',0:4)
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.01 0.01]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,600,400,400])
            % ylim([0.4,1])
            % name = {'','No stimulation','Light stimulation',''}
            % set(gca,'xticklabel',name)
            [h, p,~,stats] = ttest(a(:,1),a(:,2))
            % title('Control group')
        end

        function h = boundedline_plot(obj, psth_time, psth_signal, colors)
            h = plot(psth_time, mean(psth_signal, 2, 'omitnan'), 'Color', colors, 'LineWidth', 1);
            hold on
            x = psth_time;
            y = mean(psth_signal, 2, 'omitnan');
            e = std(psth_signal,1, 2, 'omitmissing')/sqrt(size(psth_signal, 2));
            boundedline(x, y, e, 'cmap', colors);
            xlabel('Time (s)')
            ylabel('Z \Delta F/F')
            xlim([min(mean(psth_time, 2, 'omitnan')), max(mean(psth_time, 2, 'omitnan'))])
            % ylim([-0.1, 0.1])
            ylim([-1, 1.5])
            plot([0, 0], [-1, 1.5], 'r--')
            plot([19.50, 19.50], [-1, 1.5], '--')
            plot([40.00, 40.00], [-1, 1.5], '--')
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.01 0.01]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,600,900,200])
        end

        function avg_psth_summary = average_psth(obj, alldata, session, event , region, pre, post)
            psth_time = {};
            psth_signal = {};
            for j = 1:length(alldata)
                data = alldata{j};
                idx = find(strcmp({data.session}, session) & strcmp({data.region}, region));

                for i = 1:length(idx)
                    [psth_time{j}, psth_signal{j}, ~] = obj.psth_fb(data(idx(i)).signal, data(idx(i)).time, data(idx(i)).(event), pre, post, 0, event) ;
                    % title([data(idx(i)).animalID, '-', data(idx(i)).date, ...
                    %     '-', data(idx(i)).session,'-', data(idx(i)).region])
                end
            end
            figure
            time = mean(psth_time{end}, 2);
            avg_psth = [];
            data_length = size(psth_signal{end}, 1);
            for i = 1:length(psth_signal)
                if size(psth_signal{i}, 1) == data_length;
                    avg_psth(:, i)= mean(psth_signal{i}, 2);
                elseif isempty(psth_signal{i})
                    avg_psth(:,i) = NaN(data_length, 1);
                else
                    avg_psth(:,i) = [mean(psth_signal{i}, 2);NaN];
                end
                hold on
                if ~isnan(avg_psth(1,i))
                    plot(time, avg_psth(:, i), 'Color', [0.5, 0.5, 0.5 ,0.2])
                    hold on
                end
            end
            hold on
            plot(time, mean(avg_psth, 2, 'omitnan'), 'Color','k', 'LineWidth',1)
            xlabel('Time')
            ylabel('Z \Delta F/F')
            plot([0, 0], [-1, 1.5], '--', 'Color','r', 'LineWidth',1)
            plot([19.50, 19.50], [-1, 1.5], '--', 'Color', [0.9290 0.6940 0.1250])
            plot([40.00, 40.00], [-1, 1.5], '--', 'Color', [0.4940 0.1840 0.5560])
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,900,200])
            xlim([-5, 50])

            %%
            pre = find(time>-5 & time < 0);
            post1 = find(time> 0 & time < 10);
            post2 = find(time> 10 & time < 20);
            pre_avg = mean(avg_psth(pre,:), 1, 'omitnan');
            post1_avg = mean(avg_psth(post1, :), 1, 'omitnan');
            post2_avg = mean(avg_psth(post2, :), 1, 'omitnan');
            obj.Pairline_plot([pre_avg; post1_avg; post2_avg]')
            set(gca, 'XTick', [0:4])
            set(gca, 'XTickLabel', {'', '-5 - 0s', '0 - 10s', '10 - 20s'})
            ylabel('Average Z \Delta F/F')
            avg_psth_summary.avg_psth = avg_psth;
            avg_psth_summary.time     = time;
            avg_psth_summary.psth.signal     = psth_signal;
            avg_psth_summary.psth.time       = psth_time;
        end

        function [peak_cross, peak_lags, power, all_power, all_f] = cross_correlation_power_analysis(obj, psth_time_avg_infusion10, psth_time_avg, lights)
            for i = 1:size(psth_time_avg_infusion10, 2)
                % figure;
                indx = find(psth_time_avg >0 & psth_time_avg < 20);
                control_indx = find(psth_time_avg >20 & psth_time_avg < 40);
                % subplot(2,2, 1)
                % h1 = plot(psth_time_avg(indx),psth_time_avg_infusion10(indx, i))
                % hold on
                % h2 = plot(psth_time_avg(indx), lights(indx))
                % xlabel('Time (s)')
                % ylabel('Signal')
                % legend([h1, h2], {'Dopamine Signal', 'Lights' })
                % set(gca,'TickDir','out')
                % set(gca,'fontsize',12)
                % set(gca,'TickLengt', [0.015 0.015]);
                % set(gca, 'LineWidth',1)
                % box off
                % subplot(2, 2, 2)
                [r, lags] = xcorr(psth_time_avg_infusion10(indx, i) - mean(psth_time_avg_infusion10(indx, i)), lights(indx) - mean(lights(indx)));
                % plot(lags*mean(diff(psth_time_avg)), r)
                % xlim([-1.5, 1.5])
                % ylim([-400, 400])
                % set(gca,'TickDir','out')
                % set(gca,'fontsize',12)
                % set(gca,'TickLengt', [0.015 0.015]);
                % set(gca, 'LineWidth',1)
                % xlabel('Lags (s)')
                % ylabel('Cross-Correlation')
                % box off
                [peak_cross(i), cross_index] = max(r)
                peak_lags(i) = lags(cross_index) * mean(diff(psth_time_avg));

                % subplot(2, 2, 3)
                [r, lags] = xcorr(psth_time_avg_infusion10(indx, i) - mean(psth_time_avg_infusion10(indx, i)), 'normalized');
                % plot(lags*mean(diff(psth_time_avg)), r)
                % set(gca,'TickDir','out')
                % set(gca,'fontsize',12)
                % set(gca,'TickLengt', [0.015 0.015]);
                % set(gca, 'LineWidth',1)
                % xlabel('Lags (s)')
                % ylabel('Auto-Correlation')
                % box off

                % subplot(2, 2, 4)
                fs = 1/mean(diff(psth_time_avg));
                [p,f] = pspectrum(psth_time_avg_infusion10(indx, i) - mean(psth_time_avg_infusion10(indx, i)), fs);
                % plot(f, p)
                % xlabel('Frequency (Hz)')
                % ylabel('Power Spectrum')
                % ylim([0, 0.1])
                % xlim([0, 3])
                % set(gca,'TickDir','out')
                % set(gca,'fontsize',12)
                % set(gca,'TickLengt', [0.015 0.015]);
                % set(gca, 'LineWidth',1)
                % set(gcf,'position',[100,100,800,800])

                % the blinking  is at 1/1.5 (0.667 Hz)
                % only extract the power around this peak frequency:
                freq_to_extract = find(f>0.633 & f< 0.7);
                power(i) = max(p(freq_to_extract));
                all_power{i} = p;
                all_f{i}     = f;

            end

        end

        function bar_plot_three(obj, data1, data2, data3)

            delt_amp_cluster01 = data1;
            delt_amp_cluster02 = data2;
            delt_amp_cluster03 = data3;

            mean_value_01 = mean(delt_amp_cluster01);
            mean_value_02 = mean(delt_amp_cluster02);
            mean_value_03 = mean(delt_amp_cluster03);

            sem_value_01 = std(delt_amp_cluster01)/sqrt(length(delt_amp_cluster01));
            sem_value_02 = std(delt_amp_cluster01)/sqrt(length(delt_amp_cluster01));
            sem_value_03 = std(delt_amp_cluster01)/sqrt(length(delt_amp_cluster01));

            b = bar([mean_value_01, mean_value_02, mean_value_03]);
            b.FaceColor = 'flat';
            b.CData(1,:) = [215,25,28]/255;
            b.CData(2,:) = [253,174,97]/255;
            b.CData(3,:) = [44,123,182]/255;

            hold on

            errorbar([mean_value_01, mean_value_02, mean_value_03], ...
                [sem_value_01, sem_value_02, sem_value_03],'k.', 'LineWidth', 1.5, 'CapSize',20)

            scatter(1 + 0.3* (rand(size(delt_amp_cluster01))-0.5), delt_amp_cluster01, 'k', 'MarkerFaceColor','k')
            scatter(2 + 0.3* (rand(size(delt_amp_cluster02))-0.5), delt_amp_cluster02, 'k', 'MarkerFaceColor','k')
            scatter(3 + 0.3* (rand(size(delt_amp_cluster03))-0.5), delt_amp_cluster03, 'k', 'MarkerFaceColor','k')



        end
        function anova1_three(obj, data1, data2, data3)
            data = [data1, data2, data3];
            group = [ones(size(data1)), 2*ones(size(data2)), 3*ones(size(data3))];
            [p, tbl, stats] = anova1(data, group);
            % Perform the post-hoc test
            [c, m, h, gnames] = multcompare(stats);

        end

        %%%%%%%%%%%%%%%%%%%%% function of master plots for groupdata%%%%%%%%%%%
        function [time_avg, psth_avg] = groupplot_psth_individual_infusion(obj, groupdata, i)
            data_for_plot = [groupdata(i).data_perSession(1).psth_infusion, groupdata(i).data_perSession(2).psth_infusion, ...
                groupdata(i).data_perSession(3).psth_infusion];
            time_for_plot = [groupdata(i).data_perSession(1).infusion_time, groupdata(i).data_perSession(2).infusion_time, ...
                groupdata(i).data_perSession(3).infusion_time];
            trial_nan = [];
            for i = 1:size(data_for_plot,2)
                if isnan(data_for_plot(1,i))
                    trial_nan = [trial_nan, i];
                end
            end
            data_for_plot(:,trial_nan)  = [];
            time_for_plot(:, trial_nan) = [];

            figure;
            subplot(2, 1, 1)
            x = mean(time_for_plot, 2, 'omitnan');
            y = mean(data_for_plot, 2, 'omitnan');
            e = std(data_for_plot,1, 2, 'omitmissing')/sqrt(size(data_for_plot, 2));
            boundedline(x, y, e, '-k');
            xlabel('Time (s)')
            ylabel('Z \Delta F/F')
            xlim([min(mean(time_for_plot, 2, 'omitnan')), max(mean(time_for_plot, 2, 'omitnan'))])
            xlim([-10, 50])

            hold on
            ylim([-1, 3])
            plot([0, 0], [-1, 1], 'r--')
            plot([19.50, 19.50], [-1, 1], '--')
            plot([40.00, 40.00], [-1, 1], '--')
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,300,400])
            subplot(2, 1, 2)
            imagesc(mean(time_for_plot, 2), [], data_for_plot')
            % colorbar
            xlabel('Time (s)')
            ylabel('Trials')
            xlim([-10, 50])

            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,900,400])
            colormap('jet')
            clim([-2, 5])
            box off
            time_avg = mean(time_for_plot, 2);
            psth_avg = mean(data_for_plot, 2);
        end
        function groupplot_psth_avg(obj, time_avg, psth_avg)
            figure;
            subplot(2, 1, 1)
            x = mean(time_avg, 2, 'omitnan');
            y = mean(psth_avg, 2, 'omitnan');
            e = std(psth_avg,1, 2, 'omitmissing')/sqrt(size(psth_avg, 2));
            boundedline(x, y, e, '-k');
            xlabel('Time (s)')
            ylabel('Z \Delta F/F')
            xlim([min(mean(time_avg, 2, 'omitnan')), max(mean(time_avg, 2, 'omitnan'))])
            xlim([-10, 50])
            hold on
            ylim([-1, 2])
            plot([0, 0], [-1, 1], 'r--')
            plot([19.50, 19.50], [-1, 1], '--')
            plot([40.00, 40.00], [-1, 1], '--')
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,300,400])

            psth_avg(:, any(isnan(psth_avg), 1)) = [];
            time_avg(:, any(isnan(time_avg), 1)) = [];

            subplot(2, 1, 2)
            imagesc(mean(time_avg, 2), [], psth_avg')
            % colorbar
            xlabel('Time (s)')
            xlim([-10, 50])
            ylabel('Trials')
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,900,400])
            colormap('jet')
            clim([-1, 3])
            box off
        end
        function mdl = correlaiton_analysis_cluster(obj, resp, resistence, cluster_id)
            colors = cbrewer2('div', 'RdYlBu', 4);

            %
            figure
            mdl = fitlm(resp, resistence);
            hold on
            h1 = plot(mdl)
            ylim([0, 0.8])
            xlim([-1, 2.5])
            xlabel('Dopamine')
            ylabel('Resistence Score')
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,400,400])
            scatter(resp, resistence)
            hold on
            scatter(resp(cluster_id==1), resistence(cluster_id ==1), 'MarkerFaceColor',colors(1,:), 'MarkerEdgeColor','w')
            hold on
            scatter(resp(cluster_id==2), resistence(cluster_id ==2), 'MarkerFaceColor',colors(2,:), 'MarkerEdgeColor','w')
            scatter(resp(cluster_id==3), resistence(cluster_id ==3), 'MarkerFaceColor',colors(3,:), 'MarkerEdgeColor','w')
            scatter(resp(cluster_id==4), resistence(cluster_id ==4), 'MarkerFaceColor',colors(4,:), 'MarkerEdgeColor','w')
            ylim([0, 0.8])
            xlim([-1, 2.5])
            xlabel('Dopamine')
            ylabel('Resistence Score')
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,400,400])


        end






    end


end


