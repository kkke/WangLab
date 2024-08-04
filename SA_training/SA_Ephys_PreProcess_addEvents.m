%
% the loading file is where the continous raw data is, it is to get the
% time of the first sampled ephys data
function SA_Ephys_PreProcess_addEvents(file, path, outputpath)
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
% event id:
% -2: Lever on, 2: Lever off
% -3: pump on, 3: pump off;
% -4: Back  Light On, -4: Back Light Off;
% -5: Front Light On, 5: Front Light off;
% -6: Front Lever depress, 6: Front Lever release (fixed)
% -7: Back Lever depress, 7: Back Lever release (fixed)
event_Lever_on  = Event.ts(find(Event.states ==-2)) - Spike.ts(1);
event_Lever_off = Event.ts(find(Event.states ==2))- Spike.ts(1);
event_pump_on  = Event.ts(find(Event.states ==-3)) - Spike.ts(1);
event_pump_off = Event.ts(find(Event.states ==3))- Spike.ts(1);
event_back_light_on    = Event.ts(find(Event.states ==-4)) - Spike.ts(1);
event_back_light_off   = Event.ts(find(Event.states ==4))- Spike.ts(1);
event_front_light_on   = Event.ts(find(Event.states ==-5)) - Spike.ts(1);
event_front_light_off   = Event.ts(find(Event.states ==5)) - Spike.ts(1);
event_back_press_on    = Event.ts(find(Event.states ==-7)) - Spike.ts(1);
event_back_press_off   = Event.ts(find(Event.states ==7))- Spike.ts(1);
event_front_press_on   = Event.ts(find(Event.states ==-6)) - Spike.ts(1);
event_front_press_off   = Event.ts(find(Event.states ==6)) - Spike.ts(1);
clear Event
Event.Lever_on = event_Lever_on;  
Event.Lever_off = event_Lever_off;
Event.session = session;
Event.pump_on = event_pump_on;  
Event.pump_off = event_pump_off; 
Event.back_light_on = event_back_light_on;   
Event.back_light_off = event_back_light_off;  
Event.front_light_on = event_front_light_on;  
Event.front_light_off = event_front_light_off;  
Event.back_press_on   = event_back_press_on;
Event.back_press_off  = event_back_press_off;   
Event.front_press_on  = event_front_press_on;   
Event.front_press_off = event_front_press_off;   
%% save the event data
if nargin < 2
    outputpath = uigetdir(analdir, 'Select the folder to save the event data')
end
% cd([outputpath, '/SpikeData/'])
cd(outputpath)
fprintf('Savine the event data\n');    
save('Events.mat', 'Event')
