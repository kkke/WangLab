%% segment videos based on the event:
directory = 'H:\Data\Withdraw_Videos\FMRI08_NaloxoneInjection_2022-10-04-040250';
cd(directory)
% clear
% directory = pwd;
% cuttime = 150;
% s = seconds(cuttime);
% s.Format = 'hh:mm:ss';
s = '00:11:58';

%% for campy
folders = dir();
camera_index = [0,0, 0, 1, 2];
for i = 3:length(folders)
    folder = folders(i).name;
    outputfile = [directory, '\', folder, '\' 'trim_camera', num2str(camera_index(i)), '.mp4'];
    inputfile = [directory, '\', folder, '\', '0.mp4'];
    system(['ffmpeg -ss ', s, ' -i ', inputfile, ' -t 00:20:00 -c:v libx264 ', outputfile])
end
fileID = fopen('trim.txt','w');
fprintf(fileID,'%3s\n',s);
fclose(fileID);
%% for regular
files = dir('*.mp4');
for i = 1:length(files)
    file = files(i).name;
    outputfile = ['trim_', file];
    inputfile = file;
    system(['ffmpeg -ss ', s, ' -i ', inputfile, ' -t 00:20:00 -c:v libx264 ', outputfile])
end
fileID = fopen('trim.txt','w');
fprintf(fileID,'%3s\n',s);
fclose(fileID);
