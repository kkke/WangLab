%
% the loading file is where the continous raw data is, it is to get the
% time of the first sampled ephys data
[file, path] = uigetfile('H:\Data\Ephys_Recording\*.npy', 'Load the Open Ephys Event');
analdir = path;
cd(analdir)
Fs = 30000; %sampling rate in Hz

%% loads in the channel map (if needed)
Spike.ts = readNPY('timestamps.npy');
Spike.sample = readNPY('sample_numbers.npy');

myFolder = split(analdir, '\');
myNewPath = string(join(myFolder(1:end-3),'\'))+ '\events\Acquisition_Board-100.Rhythm Data\TTL';
cd(myNewPath);
Event.ts = readNPY('timestamps.npy');
Event.sample_numbers = readNPY('sample_numbers.npy');
Event.states = readNPY('states.npy');
% align all events to the start of acquisition
event_lightCue_on  = Event.ts(find(Event.states ==1)) - Spike.ts(1);
event_lightCue_off = Event.ts(find(Event.states ==-1))- Spike.ts(1);
event_camera_on    = Event.ts(find(Event.states ==2)) - Spike.ts(1);
event_camera_off   = Event.ts(find(Event.states ==-2))- Spike.ts(1);
clear Event
Event.lightCue_on  = event_lightCue_on;
Event.lightCue_off = event_lightCue_off;
Event.camera_on    = event_camera_on;
cd([analdir, '\continuous\continuous.GUI\SpikeData'])
save('Events.mat', 'Event')
