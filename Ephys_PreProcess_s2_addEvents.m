%
% the loading file is where the continous raw data is, it is to get the
% time of the first sampled ephys data
function Ephys_PreProcess_s2_addEvents(file, path, outputpath)
if nargin < 2
    [file, path] = uigetfile('H:\Data\Ephys_Recording\*.txt', 'Load the Sync Message file');
end
analdir = path;
strsplit = split(analdir, '\');
session = strsplit{5};
cd(analdir)
txtfile = fileread([path, '\', file]);
txtfile = split(txtfile, '30000 Hz:');
startTime = str2num(txtfile{2});
Fs = 30000; %sampling rate in Hz
%% loads in the channel map (if needed)
% Spike.ts = readNPY('timestamps.npy');
% Spike.sample = readNPY('sample_numbers.npy');
format long
Spike.ts(1) = double(startTime)/Fs;
% myFolder = split(analdir, '\');
myNewPath = [analdir,  '\events\Acquisition_Board-100.Rhythm Data\TTL'];
cd(myNewPath);
Event.Session = session;
Event.ts = readNPY('timestamps.npy');
Event.sample_numbers = readNPY('sample_numbers.npy');
Event.states = readNPY('states.npy');
% align all events to the start of acquisition
event_lightCue_on  = Event.ts(find(Event.states ==1)) - Spike.ts(1);
event_lightCue_off = Event.ts(find(Event.states ==-1))- Spike.ts(1);
event_camera_on    = Event.ts(find(Event.states ==2)) - Spike.ts(1);
event_camera_off   = Event.ts(find(Event.states ==-2))- Spike.ts(1);
clear Event
Event.session = session;
Event.lightCue_on  = event_lightCue_on;
Event.lightCue_off = event_lightCue_off;
Event.camera_on    = event_camera_on;
%% save the event data
if nargin < 2
    outputpath = uigetdir(analdir, 'Select the folder to save the event data')
end
cd([outputpath, '/SpikeData/'])
fprintf('Savine the event data\n');    
save('Events.mat', 'Event')
