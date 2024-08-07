% Explore the fiber photometry data
clc;clear;close all
[file, path] = uigetfile('H:\Data\FB_data\Dopamine\*.mat');
load([path, file])

idx = 6
% plot the raw data with event: front, back, infusion
colors = cbrewer('div', 'RdYlBu', 4);

figure
subplot(2, 1, 1)
h1 = plot(summarydata(idx).time, summarydata(idx).raw_reference);
hold on
h2 = plot(summarydata(idx).time, summarydata(idx).raw_signal);
xlabel('Time (s)')
ylabel('Voltage (mV)')
for i = 1:length(summarydata(idx).infusion)
    h3 = plot([summarydata(idx).infusion(i), summarydata(idx).infusion(i)], [0, 0.6], 'r');
end
for i = 1:length(summarydata(idx).front)
    h4 = plot([summarydata(idx).front(i), summarydata(idx).front(i)], [0, 0.6], 'g');
end

legend([h1, h2], {'Reference', 'Signal'})

subplot(2, 1, 2)
plot(summarydata(idx).time, summarydata(idx).signal, 'k')
hold on
for i = 1:length(summarydata(idx).infusion)
    plot([summarydata(idx).infusion(i), summarydata(idx).infusion(i)], [2, 5], 'color', colors(1,:));
end
for i = 1:length(summarydata(idx).front)
    h4 = plot([summarydata(idx).front(i), summarydata(idx).front(i)], [-1, 2], 'color', colors(2,:));
end
for i = 1:length(summarydata(idx).back)
    h5 = plot([summarydata(idx).back(i), summarydata(idx).back(i)], [-5, -1], 'color', colors(3,:));
end
xlabel('Time (s)')
ylabel('Baseline Corrected Z-score')

set(gcf,'position',[100,100,1600,400])
%%
videoObj = VideoReader("SA57_NAc_012623Cam32E4-9320-02_0000.avi");
numFrames = videoObj.NumFrames;
% Read the first frame
firstFrame = rgb2gray(readFrame(videoObj));

% Display the first frame
figure; imshow(firstFrame);
title('First Frame of the Video');


% Clean up by closing the VideoReader object
% clear videoObj;

% Draw a circle manually
h1 = imellipse;
wait(h1);
roiPosition1 = getPosition(h1);

h2 = imellipse;
wait(h2);
roiPosition2 = getPosition(h2);

h3 = imellipse;
wait(h3);
roiPosition3 = getPosition(h3);
%%
averageIntensity = zeros(3,numFrames);
binaryMask1 = createMask(h1);
binaryMask2 = createMask(h2);
binaryMask3 = createMask(h3);
% Read frames in parallel
for frameIndex = 1:numFrames
    frames = read(videoObj, frameIndex);
    
    % Extract the region of interest (ROI) from the original image
    roiImage1 = frames .* uint8(binaryMask1);
    roiImage2 = frames .* uint8(binaryMask2);
    roiImage3 = frames .* uint8(binaryMask3);
    % Calculate the average intensity within the circle
    averageIntensity(1,frameIndex) = mean(roiImage1(binaryMask1));
    averageIntensity(2,frameIndex) = mean(roiImage2(binaryMask2));
    averageIntensity(3,frameIndex) = mean(roiImage3(binaryMask3));
end
% Create a binary mask for the circle


[t_on t_off]=Timing_onset_offset(averageIntensity(2,:), 1:size(averageIntensity,2), 150,500,1);
save('video_timeinfo.mat', 't_on', 't_off', 'averageIntensity', 'roiPosition1', 'roiPosition2', 'roiPosition3')
% Display the average intensity
disp(['Average Intensity within the Circle: ', num2str(averageIntensity)]);

% Optionally, you can save the ROI image
imwrite(roiImage, 'roi_image.png'); % Change the file extension as needed

%% load dlc results
dlc_file = 'SA57_NAc_012623Cam32E4-9320-02_0000DLC_resnet101_SA_AnalysisAug22shuffle5_1030000_filtered.csv';
dlc_data = readtable(dlc_file);
dlc_data.Properties.VariableNames(2) = "x";
dlc_data.Properties.VariableNames(3) = "y";
dlc_data.Properties.VariableNames(4) = "likelihood";
bodycenter.x = dlc_data.x;
bodycenter.y = dlc_data.y;
bodycenter.likelihood = dlc_data.likelihood;
bodycenter.frameInfo = load('video_timeinfo.mat');

indx = find(bodycenter.likelihood <0.8);
%% save video clips
dlc_video = 'SA57_NAc_012623Cam32E4-9320-02_0000DLC_resnet101_SA_AnalysisAug22shuffle5_1030000_filtered_labeled.mp4';
videoObj = VideoReader(dlc_video);
% Get video properties
frameRate = videoObj.FrameRate;
t_on = bodycenter.frameInfo.t_on;
t_off = bodycenter.frameInfo.t_off;

% Create a VideoWriter object to write the output video
outputVideoFile = 'trial_02.mp4'
videoWriter = VideoWriter(outputVideoFile, 'MPEG-4');
videoWriter.FrameRate = frameRate;
open(videoWriter);

% Loop through each frame and write it to the output video
frameStart = t_on(2)-5*30;
frameEnd   = t_on(3);
for frameIndex = frameStart:frameEnd
    % Read the current frame
    currentFrame = read(videoObj, frameIndex);
    
    % Perform any processing on the frame if needed
    
    % Write the frame to the output video
    writeVideo(videoWriter, currentFrame);
end
close(videoWriter)
clear videoWriter
%%
% plot a moving traces
figure;
% Initialize the trace
x = [];
y = [];

% Loop to update the trace
for i = 1:2000
    % Generate new data points (replace this with your own data)
    new_x = bodycenter.x(t_on(1)+i-1);
    new_y = 640-bodycenter.y(t_on(1)+i-1);
    
    % Update the trace
    x = [x, new_x];
    y = [y, new_y];
    
    % Plot the trace
    plot(x, y, 'b-', 'LineWidth', 2);
    title('Moving Trace');
    xlabel('X-axis');
    ylabel('Y-axis');
    
    % Pause for a short time to create a smooth animation
    pause(0.03);
end

%%
i = 3
leverInsertion = summarydata(i).leverInsertion;
time = summarydata(i).time;
signal = summarydata(i).signal;
figure
for j = 1:length(leverInsertion)-1
    indx = find(time > leverInsertion(j) & time < leverInsertion(j+1));
    reset_time = leverInsertion(j);
    plot(time(indx)-reset_time, signal(indx)+4*j)
    hold on
end
xlim([0,500])

%% plot on the same 
%%
i = 2
leverInsertion = summarydata(i).leverInsertion;
time = summarydata(i).time;
signal = summarydata(i).signal;
front = summarydata(i).front;
back = summarydata(i).back;
infusion = summarydata(i).infusion;
figure
session = [30*60, 90*60, 150*60]; % record every 30 min
k =1
colors = cbrewer('div', 'RdYlBu', 4);
for j = 1:length(leverInsertion)-1
    % j = 1
    if leverInsertion(j+1)< session(k)
        indx = find(time > leverInsertion(j) & time < leverInsertion(j+1));
        reset_time = leverInsertion(j);
        plot(time(indx)-reset_time, signal(indx)+4*j, 'color', colors(mod(j,4)+1,:,:))
        hold on
        index2 = find(back > leverInsertion(j) & back < leverInsertion(j+1));
        plot([back(index2), back(index2)]- reset_time, [-4, 4] + 4*j, 'r')
        % index3 = find(front > leverInsertion(j) & front < leverInsertion(j+1));
        % plot([front(index3), front(index3)] - reset_time, [-4, 4] + 4*j, 'r')
        index4 = find(infusion > leverInsertion(j) & infusion < leverInsertion(j+1));
        plot([infusion(index4), infusion(index4)]- reset_time, [-4, 4] + 4*j, 'g')
    else
        k = k+1
    end

end
xlabel('Time (s)')
ylabel('Trials + Z-score dF/F')
set(gcf,'position',[100,100,800,600])
box off
set(gca,'TickDir','out')
set(gca,'fontsize',12)
set(gca,'TickLengt', [0.015 0.015]);
set(gca, 'LineWidth',1)
% move_x = bodycenter.x(t_on(j) : t_on(j+1));
% move_y = bodycenter.y(t_on(j) : t_on(j+1));
% speed = sqrt((diff(move_x)).^2 + (diff(move_y)).^2);
% speed_time = linspace(0, leverInsertion(j+1) -leverInsertion(j), length(speed));
% plot(speed_time, speed +10)
%% behavioral plot
clear
load('sa85_ThreeHoursSessions.mat')
baf = behavior_analysis_func;
baf.behavioral_shock_plot(summarydata)
sgtitle('SA57')
saveas(gcf, 'SA57.pdf', 'pdf');

%%