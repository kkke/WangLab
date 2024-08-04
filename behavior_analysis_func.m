classdef behavior_analysis_func
    methods
        function SA_behavioral_Plot_1A(obj, summarydata)
            %UNTITLED Summary of this function goes here
            %   Detailed explanation goes here
            figure
            colors = cbrewer('div', 'RdYlBu', 4);
            subplot(1, 3, 1)
            % obj.FR_plot(summarydata)
            hold on
            ha = plot(summarydata.activeLeverPress , '-o', color = colors(1,:));
            hold on
            hi = plot(summarydata.inactiveLeverPress , '-o', color = colors(4,:));
            set(ha, 'LineWidth', 1)
            set(ha, 'MarkerFaceColor', 'w')
            set(hi, 'LineWidth', 1)
            set(hi, 'MarkerFaceColor', 'w')
            sessionlength = size(summarydata, 1);
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
            subplot(1, 3, 2)
            % obj.FR_plot(summarydata)
            ha = plot(summarydata.("activeLeverPress-Cue") , '-o', color = colors(1,:));
            hold on
            hi = plot(summarydata.("inactiveLeverPress-Cue"), '-o', color = colors(4,:));
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
            subplot(1, 3, 3)
            % obj.FR_plot(summarydata)
            h = plot(summarydata.Reward, '-o', color = colors(1,:));
            set(h, 'LineWidth', 1)
            set(h, 'MarkerFaceColor', 'w')
            ylabel('Infusion #')
            xlim([0,sessionlength])
            ylim([0,150])
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,1200,400])
            xlabel('Session #')
            title('Drug Infusion')
        end

        function FR_plot(obj, summarydata, high)
            if nargin ==3
                high = high;
            else
                high = max([summarydata.Resp_Total]);

            end
            hold on
            colors = cbrewer('div', 'RdYlBu', 4);
            
            fr1 = find(summarydata.FR ==1);
            rectangle('position', [fr1(1), 1, fr1(end)-fr1(1), high], 'FaceColor', [colors(4,:),0.3], 'EdgeColor', 'none')
            text(fr1(1), high + 40, 'FR1')
            fr2 = find(summarydata.FR ==2);
            rectangle('position', [fr2(1), 1, fr2(end)-fr2(1), high], 'FaceColor', [colors(4,:),0.5], 'EdgeColor', 'none')
            text(fr2(1), high + 40, 'FR2')
            fr4 = find(summarydata.FR ==4);
            rectangle('position', [fr4(1), 1, fr4(end)-fr4(1), high], 'FaceColor', [colors(4,:),0.7], 'EdgeColor', 'none')
            text(fr4(1), high + 40, 'FR4')
        end


        function summarydata = save_data(obj, filename, folder)
            dataRaw = readtable([filename, '.csv']);
            obj.SA_behavioral_Plot_1A(dataRaw)
            save([folder, '\', filename, '.mat'], "dataRaw")
        end

        function line_plot_MA_avg(obj, data1, data2, legend1, legend2)
            % h1 = plot(mean(summary.wt.CrossCoef,1), '-ko', 'MarkerFaceColor', 'k', 'LineWidth', 1)
            if nargin ==3
                legend1 = 'Active Lever';
                legend2 = 'Inactive Lever';
            end
            colors = cbrewer('div', 'RdYlBu', 6);
            h1 = errorbar(mean(data1,1, "omitnan"), std(data1, 0, 1, "omitmissing")./sqrt(size(data1, 1)), '-o', 'color', colors(1,:), 'LineWidth', 1);
            set(h1, 'LineWidth', 1)
            set(h1, 'MarkerFaceColor', 'w')
            hold on
            h2 = errorbar(mean(data2,1, "omitnan"), std(data2, 0, 1, "omitmissing")./sqrt(size(data2, 1)), '-o', 'color', colors(6,:), 'LineWidth', 1);
            set(h2, 'LineWidth', 1)
            set(h2, 'MarkerFaceColor', 'w')
            legend([h1, h2], {legend1, legend2})
            ylabel('Lever Press #')
            xlim([0,20])
            % xticks([0:13])
            % xticklabels({'','1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', ''})
            % xlabel('Signal to Noise Ratio (dB)')
            % xlabel('Signal to Noise Ratio (dB)')
            xlabel('Session #')
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,600,400,400])
        end

        function line_plot_MA(obj, data1, data2, legend1, legend2)
            if nargin ==3
                legend1 = 'Active Lever';
                legend2 = 'Inactive Lever';
            end
            figure;
            colors = cbrewer('div', 'RdYlBu', 6);
            h1 = plot(data1, '-o', 'color', colors(1,:),  'LineWidth', 1);
            set(h1, 'MarkerFaceColor', 'w')
            hold on
            h2 = plot(data2, '-o', 'color', colors(6,:), 'LineWidth', 1);
            set(h2, 'MarkerFaceColor', 'w')
            legend([h1(1), h2(1)], {legend1, legend2})
            ylabel('Lever Press #')
            xlim([0,20])
            % xticks([0:13])
            % xticklabels({'','1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', ''})
            % xlabel('Signal to Noise Ratio (dB)')
            % xlabel('Signal to Noise Ratio (dB)')
            xlabel('Session #')
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,600,400,400])
        end
       
        function line_plot_errorbar(obj, data1, color ,y_label)
            
            h1 = errorbar(mean(data1,1, 'omitnan'), std(data1, 0, 1, "omitmissing")./sqrt(size(data1, 1)), '-o', 'color', color, 'LineWidth', 1);
            set(h1, 'LineWidth', 1)
            set(h1, 'MarkerFaceColor', 'w')
            % legend(h1,  legend1)
            ylabel(y_label)
            xlim([0,20])
            % xticks([0:13])
            % xticklabels({'','1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', ''})
            % xlabel('Signal to Noise Ratio (dB)')
            % xlabel('Signal to Noise Ratio (dB)')
            xlabel('Session #')
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,600,400,400])
        end
        function line_plot_pr_ratio(obj, data, pr)
            figure;
            plot(pr, 'k', 'LineWidth',1)
            ylim([0, 400])
            xlabel("Infusion #")
            ylabel('Break Point (Lever Press #)')
            hold on
            scatter(data.Reward,  data.PR, 'MarkerFaceColor', 'w', 'LineWidth',1)
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,600,400,400])
            title('Progressive-Ratio Test')
        end
        function [x_index, subdata] = line_plot_MA_align_punishment(obj, summarydata, event)
            % Create a vector of colors
            colors = linspace(0, 1, length(summarydata));
            figure
            legend_handles = [];
            legend_labels  = {};
            subdata = {};
            % rectangle('Position',[-0.5, 0, 3, 100], 'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'none');
            % text(-0.1, 90, 'Punishment', 'FontSize', 12, 'Color', 'r')
            % text(-0.4, 85, '0.2 mA Shock', 'FontSize',12)
            % hold on
            % plot([-3.5, 2.5], [105, 105], 'Color', [221,28,119]/255, 'LineWidth',2)
            % text(-0.5, 110, 'Fentanyl', 'FontSize', 14, 'Color', [221,28,119]/255, 'FontWeight','bold')
            % plot([2.5, 4.5], [105, 105], 'Color', [49,163,84]/255, 'LineWidth',2)
            % text(2.5, 110, 'Saline', 'FontSize', 14, 'Color', [49,163,84]/255, 'FontWeight','bold')
            % rectangle('Position',[-0.5, 1, 3, 900], 'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'none');
            % text(-0.1, 885, 'Punishment', 'FontSize', 12, 'Color', 'r')
            % text(-0.4, 805, '0.2 mA Shock', 'FontSize',12)
            % hold on
            % plot([-3.5, 2.5], [905, 905], 'Color', [221,28,119]/255, 'LineWidth',2)
            % text(-1, 935, 'Fentanyl', 'FontSize', 14, 'Color', [221,28,119]/255, 'FontWeight','bold')
            % plot([2.5, 4.5], [905, 905], 'Color', [49,163,84]/255, 'LineWidth',2)
            % text(2.5, 935, 'Saline', 'FontSize', 14, 'Color', [49,163,84]/255, 'FontWeight','bold')
            hold on
            for i = 1 : length(summarydata)
                
            
                include_index = sort([summarydata(i).recording_index; summarydata(i).shock_session]);
                subdata_training = summarydata(i).data(include_index,:);
                shock_index = min(find(contains(subdata_training.training, 'shock')));
                x_index{i} = (1: size(subdata_training, 1)) - shock_index;
                h(i) = plot(x_index{i}, subdata_training.(event) , '-o', 'color', [colors(i) 0 1-colors(i)]);
                % h(i) = plot(x_index{i}, subdata_training.(event) , '-o', 'color', [colors(i) 0 1-colors(i)]);

                hold on
                set(h(i), 'LineWidth', 1)
                set(h(i), 'MarkerFaceColor', 'w')
                legend_handles = [legend_handles, h(i)];
                legend_labels  = {legend_labels{:}, subdata_training.subject{1}};
                subdata{i} = subdata_training;
            end
            legend(legend_handles, legend_labels)
            hold on
            ylabel(event)
            xlabel('Session #')
            % set(gca,'XTick',0:2:31)
            % ylim([0, 50])
            xlim([-4,4])
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,400,400])
            
        end
        
        function plot_data = avg_align_punishement(obj, subdata, x_index, event)
            plot_data = [];
            thr = -3; % 3 sessions before punishment
            % event = 'Reward';
            for i = 1:length(subdata)
                indx = find(x_index{i}>=-3);
                if length(indx)<7
                    plot_data(1:length(indx), i) =  subdata{i}.(event)(indx);
                    plot_data((length(indx)+1):end, i) = NaN;

                elseif length(indx)>7
                    error('Something is wrong')
                else
                    plot_data(:,i) = subdata{i}.(event)(indx);
                end
            end
        end

        function peri_event_plot(obj, dataRaw)
            colors = cbrewer('div', 'RdYlBu', 6);
            % dataRaw = readmatrix('SA05_FR4_121721.CSV', NumHeaderLines = 5);
            % columns = {'Back_Resp', 'Front_Resp', 'Back_IRT', 'Front_IRT', 'Reward', 'Cue'};
            for i = 1:length(columns)
                data.(columns{i}) = dataRaw(dataRaw(:, i)>0, i);
            end
            data.Cue = [0; data.Cue]; % Insert the first Cue

            % get the peri-event of the lever press and reward
            for i = 1:length(data.Cue)-1
                time_range = [data.Cue(i), data.Cue(i+1)];
                perievent_back(i).times   = data.Back_Resp(find(data.Back_Resp > time_range(1) & data.Back_Resp < time_range(2))) - data.Cue(i);
                perievent_front(i).times  = data.Front_Resp(find(data.Front_Resp > time_range(1) & data.Front_Resp < time_range(2)))- data.Cue(i);
                perievent_reward(i).times = data.Reward(find(data.Reward > time_range(1) & data.Reward < time_range(2)))-data.Cue(i);
            end

            %plot the peri-event raster of lever pressing and reward
            figure;
            hold on
            for i = 1:length(data.Cue)-1
                if ~isempty(perievent_front(i).times)
                    h1 = plot([perievent_front(i).times, perievent_front(i).times]', [i, i+1], 'color',colors(1,:));
                end
            end


            hold on
            for i = 1:length(data.Cue)-1
                if ~isempty(perievent_back(i).times)
                    h3 = plot([perievent_back(i).times, perievent_back(i).times]', [i, i+1], 'color', colors(6,:));
                end
            end

            hold on
            for i = 1:length(data.Cue)-1
                h2 = plot([perievent_reward(i).times, perievent_reward(i).times]', [i, i+1], 'k');
            end

            xlabel('Time (s)')
            ylabel('Trial #')
            xlim([-10,300])
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gcf,'position',[100,100,800,400])
        end
        
        function T = hierarchical_cluster(obj, resp_ap)

            resp_ap_scaled = (resp_ap - mean(resp_ap, 1))./std(resp_ap, 1);
            % resp_ap_scaled = resp_ap./max(resp_ap,[],1);
            % resp_ap_scaled = resp_ap;

            Z = linkage(resp_ap_scaled,'ward','euclidean');
            clusterN = 4;
            T = cluster(Z,'maxclust',clusterN); % edit by ke, increase the cluster from 9 to 16.
            cutoff =  Z(end-clusterN+2,3);
            figure
            subplot(2, 1, 1)
            [H,tt,outperm] = dendrogram(Z,0,'ColorThreshold',cutoff);
            % for i = 1:size(resp_ap_scaled, 2)
            %     subplot(size(resp_ap_scaled, 2),1,i)
            %     bar(resp_ap_scaled(outperm,i))
            %     hold on
            % end
           
            data_reorg = resp_ap_scaled(outperm, :);
            subplot(2, 1, 2)
            imagesc(data_reorg')
            colormap(jet)
            set(gca,'YTick',[1, 2])
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)
            set(gca, 'YTickLabel', {'Resistance','Reinstatement'})
        end

        function behavioral_shock_plot(obj, summarydata)
            dataRaw = summarydata;
            training_protocol = dataRaw.training;
            recording_index = find(contains(training_protocol, 'Ephys'));
            shock_session     = find(contains(training_protocol, 'shock'));
            clear summarydata
            summarydata.animalID = dataRaw.subject{1};
            summarydata.data = dataRaw;
            summarydata.recording_index = recording_index;
            summarydata.shock_session     = shock_session;
            figure
            subplot(1,2,1)
            legend_handles = [];
            legend_labels  = {};
            subdata = {};
            rectangle('Position',[-0.5, 0, 3, 100], 'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'none');
            text(-0.1, 90, 'Punishment', 'FontSize', 12, 'Color', 'r')
            text(-0.4, 85, '0.2 mA Shock', 'FontSize',12)
            hold on
            plot([-3.5, 2.5], [105, 105], 'Color', [221,28,119]/255, 'LineWidth',2)
            text(-0.5, 110, 'Fentanyl', 'FontSize', 14, 'Color', [221,28,119]/255, 'FontWeight','bold')
            plot([2.5, 4.5], [105, 105], 'Color', [49,163,84]/255, 'LineWidth',2)
            text(2.5, 110, 'Saline', 'FontSize', 14, 'Color', [49,163,84]/255, 'FontWeight','bold')
            % rectangle('Position',[-0.5, 1, 3, 900], 'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'none');
            % text(-0.1, 885, 'Punishment', 'FontSize', 12, 'Color', 'r')
            % text(-0.4, 805, '0.2 mA Shock', 'FontSize',12)
            % hold on
            % plot([-3.5, 2.5], [905, 905], 'Color', [221,28,119]/255, 'LineWidth',2)
            % text(-1, 935, 'Fentanyl', 'FontSize', 14, 'Color', [221,28,119]/255, 'FontWeight','bold')
            % plot([2.5, 4.5], [905, 905], 'Color', [49,163,84]/255, 'LineWidth',2)
            % text(2.5, 935, 'Saline', 'FontSize', 14, 'Color', [49,163,84]/255, 'FontWeight','bold')
            hold on
            include_index = sort([summarydata.recording_index; summarydata.shock_session]);
            subdata_training = summarydata.data(include_index,:);
            shock_index = min(find(contains(subdata_training.training, 'shock')));
            x_index = (1: size(subdata_training, 1)) - shock_index;
            h = plot(x_index, subdata_training.('Reward') , '-o', 'color','k');
            % h(i) = plot(x_index{i}, subdata_training.(event) , '-o', 'color', [colors(i) 0 1-colors(i)]);

            hold on
            set(h, 'LineWidth', 1)
            set(h, 'MarkerFaceColor', 'w')
            ylabel('Infusion #')
            xlabel('Session #')
            % set(gca,'XTick',0:2:31)
            % ylim([0, 50])
            xlim([-4,4])
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)

            subplot(1,2,2)
            rectangle('Position',[-0.5, 1, 3, 850], 'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'none');
            text(-0.1, 865, 'Punishment', 'FontSize', 12, 'Color', 'r')
            text(-0.4, 805, '0.2 mA Shock', 'FontSize',12)
            hold on
            plot([-3.5, 2.5], [905, 905], 'Color', [221,28,119]/255, 'LineWidth',2)
            text(-1, 935, 'Fentanyl', 'FontSize', 14, 'Color', [221,28,119]/255, 'FontWeight','bold')
            plot([2.5, 4.5], [905, 905], 'Color', [49,163,84]/255, 'LineWidth',2)
            text(2.5, 935, 'Saline', 'FontSize', 14, 'Color', [49,163,84]/255, 'FontWeight','bold')
            hold on
            h2 = plot(x_index, subdata_training.('activeLeverPress') , '-o', 'color',[215, 25, 28]/255);
            hold on
            h3 = plot(x_index, subdata_training.('inactiveLeverPress') , '-o', 'color',[44, 123, 182]/255);
            % h(i) = plot(x_index{i}, subdata_training.(event) , '-o', 'color', [colors(i) 0 1-colors(i)]);

            hold on
            set(h2, 'LineWidth', 1)
            set(h2, 'MarkerFaceColor', 'w')
            set(h3, 'LineWidth', 1)
            set(h3, 'MarkerFaceColor', 'w')
            ylabel('Lever Press #')
            xlabel('Session #')
            % set(gca,'XTick',0:2:31)
            % ylim([0, 50])
            xlim([-4,4])
            box off
            set(gca,'TickDir','out')
            set(gca,'fontsize',12)
            set(gca,'TickLengt', [0.015 0.015]);
            set(gca, 'LineWidth',1)


            set(gcf,'position',[100,100,800,400])
        end
    
    end
end