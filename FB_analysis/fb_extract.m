function ProcessedData = fb_extract(filename, type, chan_Num)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
rawdata_tree = '/DataAcquisition/FPConsole/Signals/';
setting_tree = '/Configurations/FPConsole/AIN02/Settings/';
% processed_data_tree = '/DataProcessed/FPConsole/DFFSignals/';
switch type
    case 'Seriers'
        Seriers = {'Series0001', 'Series0002', 'Series0003'};
    case 'none'
        Seriers = {'Series0001'};
end
switch chan_Num
    case 1 % only 1 chan is using
        chan_405 = {'AIN02xAOUT01'};
        chan_465 = {'AIN02xAOUT02'}    
    case 2 % both channels are using
        chan_405 = {'AIN02xAOUT01', 'AIN04xAOUT01'};
        chan_465 = {'AIN02xAOUT02', 'AIN04xAOUT02'};
end
for j = 1:length(chan_405)
    chan_405name = chan_405{j};
    chan_465name = chan_465{j};
    for i = 1:length(Seriers)
        ProcessedData(i).Seriers = Seriers{i};
        ProcessedData(i).settings.Sig405_output  = h5readatt([filename, '.doric'], [setting_tree, 'LockInAOUT1'], 'OutputLevel');
        ProcessedData(i).settings.Sig470_output  = h5readatt([filename, '.doric'], [setting_tree, 'LockInAOUT2'], 'OutputLevel');
        ProcessedData(i).rawData.Sig405   = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/', chan_405name, '-LockIn/Values']);
        ProcessedData(i).rawData.Sig470   = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/', chan_465name, '-LockIn/Values']);
       
        ProcessedData(i).rawData.time     = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/', chan_405name, '-LockIn/Time']);
        %     ProcessedData(i).processed.signal = h5read([ProcessedData_filename{i}, '.doric'], [processed_data_tree, Seriers{i}, '/AIN02xAOUT02-LockIn/Values']);
        %     ProcessedData(i).processed.time = h5read([ProcessedData_filename{i}, '.doric'], [processed_data_tree, Seriers{i}, '/AIN02xAOUT02-LockIn/Time']);
        ProcessedData(i).rawDIO.lever     = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/DigitalIO/DIO01']);
        ProcessedData(i).rawDIO.infusion  = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/DigitalIO/DIO02']);
        ProcessedData(i).rawDIO.front     = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/DigitalIO/DIO03']);
        ProcessedData(i).rawDIO.back      = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/DigitalIO/DIO04']);
        ProcessedData(i).rawDIO.time      = h5read([filename, '.doric'], [rawdata_tree, Seriers{i}, '/DigitalIO/Time']);
        
%         % fit 405 to 470 signals to calculate delta F/F
%         Sig405 = ProcessedData(i).rawData.Sig405;
%         Sig470 = ProcessedData(i).rawData.Sig470;
%         [cleanedData,outlierIndices] = rmoutliers(Sig470,"quartiles","ThresholdFactor",3); % remove artifact from fitting.
%         % smooth 0.5 s;
%         sample_rate = 1/mean(diff(ProcessedData(1).rawData.time));
%         n = 0.5 * sample_rate;
%         if mod(floor(n),2)
%             scale = floor(n) + 1;
%         else
%             scale = floor(n);
%         end
%         F470=smooth(cleanedData,scale,'lowess');
%         F405=smooth(Sig405(~outlierIndices),scale,'lowess');
%         bls=polyfit(F405(1:end),F470(1:end),1);
%         %     Sig470 = smooth(Sig470, scale, 'lowess');
%         %     Sig405 = smooth(Sig405, scale, 'lowess');
%         Sig405smooth = smooth(Sig405, scale,'lowess');
%         
% %         Y_Fit=bls(1).*Sig405+bls(2);
%         Y_Fit=bls(1).*Sig405smooth+bls(2);
%         Delta470=(Sig470(:)-Y_Fit(:))./Y_Fit(:);
%         ProcessedData(i).processed.signal = Delta470;
%         ProcessedData(i).processed.time = ProcessedData(i).rawData.time;
%         ProcessedData(i).processed.Fit405 = Y_Fit;
%         figure;
%         subplot(2,1,1)
%         plot(ProcessedData(i).processed.time, Sig470)
%         hold on
%         plot(ProcessedData(i).processed.time, Y_Fit)
%         xlabel('Time (s)')
%         ylabel('Voltage (V)')
%         box off
%         set(gca,'TickDir','out')
%         set(gca,'fontsize',12)
%         set(gca,'TickLengt', [0.015 0.015]);
%         set(gca, 'LineWidth',1)
%         set(gcf,'position',[100,100,600,400])
%         subplot(2,1,2)
%         plot(ProcessedData(i).processed.time, Delta470)
%         xlabel('Time (s)')
%         ylabel('\Delta F/F')
%         set(gca,'TickDir','out')
%         set(gca,'fontsize',12)
%         set(gca,'TickLengt', [0.015 0.015]);
%         set(gca, 'LineWidth',1)
%         set(gcf,'position',[100,100,600,400])
%         box off
    end
save([filename, '_', chan_465name, '_processed.mat'], 'ProcessedData')
clear ProcessedData
end

end

