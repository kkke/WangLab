%% load individual dataset
clear, clc
fb = fb_extract_doric;
folder = 'H:\Data\FB_data\Dopamine\DAT_DA_03\032224';
% folder = 'H:\Data\FB_data\Dopamine\Fentanyl\SADA13\063023'
% filename = 'SADA05_Ch2_DLS_Ch4_NAc_112123_0000';  % naming needs to be: aminalID_date_region
filename = 'DATDA03_032224_NAc_0000';  % naming needs to be: aminalID_date_region
Sessions = {'Hab01', 'Saline01', 'Cocaine', 'Saline02','Fentanyl','Non-Contingent'};
session = Sessions{5};
% data = fb.load_ch2_threeSeries([folder, '\', filename]);
% data1 = fb.load_ch2_threeSeries_ployfit([folder, '\', filename]);
% data = fb.load_ch2_oneSeries([folder, '\', filename]);
% data = fb.load_green_red_threeSeries([folder, '\', filename]);
data = fb.load_oneSeries_green_red([folder, '\', filename]);
data = fb.fill_metadata(data, filename, session);
summarydata = fb.save_data(data, folder);
%%