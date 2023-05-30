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
        
        function all_data = load_ch2_threeSeries(obj, filename)
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

        function [psth_time,psth_signal, fig] = psth_fb(obj, data,time, event, pre, post, fig_title)
            %UNTITLED4 Summary of this function goes here
            %   Detailed explanation goes here
            %
            % data = Signal_concat;
            % time = Time_concat;
            % event = DIO.infusion;
            % pre = -5; % in secs
            % post= 5; % in secs
            sample_rate = 1/mean(diff(time(1:1000)));
            sample_size = floor((post-pre) * sample_rate);
            index = [];
            psth_signal = zeros(sample_size, length(event));
            psth_time   = zeros(sample_size, length(event));
            for i = 1:length(event)
                index = find(time> event(i) + pre & time < event(i) + post);
                if length(index)< sample_size
                else
                    psth_time(:, i) = time(index(1:sample_size)) -  event(i);
                    psth_signal(:,i) = data(index(1:sample_size));
                end
            end

            fig = figure;
            subplot(2,1,1)
            plot(mean(psth_time, 2), mean(psth_signal, 2), 'k')
            hold on
            x = mean(psth_time, 2);
            y = mean(psth_signal, 2);
            e = std(psth_signal,1, 2)/sqrt(size(psth_signal, 2));
            boundedline(x, y, e, '-k');
            xlabel('Time (s)')
            ylabel('\Delta F/F')
            xlim([min(mean(psth_time, 2)), max(mean(psth_time, 2))])
            % ylim([-0.1, 0.1])
            ylim([-1, 1])
            title(fig_title)

            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,300,400])
            subplot(2, 1, 2)
            imagesc(mean(psth_time, 2),[] ,psth_signal')
            % colorbar
            xlabel('Time (s)')
            ylabel('Trials')
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,300,400])
            colormap('jet')
            clim([-1, 1])
            box off
        end




    end
end


