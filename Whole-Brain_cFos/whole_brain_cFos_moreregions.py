# -*- coding: utf-8 -*-
"""
Created on Sun Oct 16 20:32:03 2022

@author: llkon
"""


"""
Created on Mon Aug 29 11:48:23 2022

@author: KeChen
"""
import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
# =============================================================================
# directory = 'I:\LifeCanvas CRO datasets\May 2022 datasets\FanWang_03292022_MIT_analysis'
# filename = 'combined_density_FanWang_03292022_MIT_6.csv'
# 
# =============================================================================

# directory = 'I:\LifeCanvas CRO datasets\March 2022 datasets\MIT_Wang_12142021_analysis'
# filename = 'combined_density_MIT_Wang_12142021_6.csv'

directory = 'H:/Dropbox/Dropbox/Wang Lab/DataTransfer/Whole_Brain_cFos/rawData'
filename = 'kcmp40-41-46Raw.csv'
os.chdir(directory)

#%% extract useful information
rawData = pd.read_csv(os.path.join(directory, filename))
print(rawData.head())

# Check cortical brain regions for analysis
cortical_data = rawData[(rawData.parent_structure_id == 5) & (rawData.depth == 6)]
corticalplate_data = rawData[(rawData.parent_structure_id == 555) & (rawData.depth == 5)]
striatum_data = rawData[(rawData.parent_structure_id > 571) & (rawData.parent_structure_id <= 592) & (rawData.depth == 6)]
pallidum_data = rawData[(rawData.parent_structure_id > 609) & (rawData.parent_structure_id <= 620) & (rawData.depth == 6)]
thalamus_data = rawData[(rawData.parent_structure_id >= 642) & (rawData.parent_structure_id <= 696) & (rawData.depth == 6)]
hypothalamus_data = rawData[(rawData.parent_structure_id >= 715) & (rawData.parent_structure_id <= 802) & (rawData.depth == 5)]
midbrain_data = rawData[(rawData.parent_structure_id >= 807) & (rawData.parent_structure_id <= 868) & (rawData.depth == 5)]
hindbrain_data = rawData[(rawData.parent_structure_id >= 884) & (rawData.parent_structure_id <= 924) & (rawData.depth == 6)]
medulla_data   = rawData[(rawData.parent_structure_id >= 936) & (rawData.parent_structure_id <= 1010) & (rawData.depth == 6)]

frames = [cortical_data, corticalplate_data, striatum_data,
          pallidum_data, thalamus_data, hypothalamus_data, midbrain_data, hindbrain_data, medulla_data]
sub_data = pd.concat(frames)

sub_data.plot.bar(x = 'acronym', y = [6, 7,8], title = 'Left', xlabel = 'Regions', ylabel = 'cFos+ Density (cells/mm^3)')
index_name = ['cortical_data', 'corticalplate_date', 'striatum_data', 'pallidum_data', 'thalamus_data', 
              'hypothalamus_data', 'midbrain_data', 'hindbrain_data', 'medulla_data']
index_data = [cortical_data.shape[0], corticalplate_data.shape[0], striatum_data.shape[0], 
              pallidum_data.shape[0], thalamus_data.shape[0], hypothalamus_data.shape[0],
              midbrain_data.shape[0], hindbrain_data.shape[0], medulla_data.shape[0]]
index_info = pd.DataFrame(index_data, index= index_name)
index_info.to_csv('brain_index_info.csv')
#%% data cleanning
sub_data = sub_data.drop(sub_data.columns[[6,7,8,9,13]], axis = 1)


#%% re-organize the data
sub_data_transpose = sub_data.T
sub_data_transpose.columns = sub_data_transpose.loc['acronym']
sub_data_transpose = sub_data_transpose.drop(sub_data_transpose.index[0:6])


sub_data_new = sub_data_transpose.rename(index=lambda s: s[0:6])

treatmentData = pd.read_excel('D:/WangLab_data/Data_Analysis_WholeBrain_cFos/mouse_log.xlsx')
gender = [];
treatment = [];
for sub in sub_data_new.index:
    gender.append(treatmentData.loc[(treatmentData.animalID == sub), 'gender'].tolist()[0])
    treatment.append(treatmentData.loc[(treatmentData.animalID == sub), 'treatment'].tolist()[0])
sub_data_new.insert(0, 'gender', gender)
sub_data_new.insert(1, 'treatment', treatment)


# sub_data_transpose.insert(0, 'treatment', ['morphine-saline', 'morphine-naloxone','saline-naloxone'])

#%% save the data to csv file
summaryfolder = 'D:/WangLab_data/Data_Analysis_WholeBrain_cFos/'
files = filename[0:-7]
os.chdir(summaryfolder)
os.makedirs('./summary', exist_ok=True)
sub_data_new.to_csv('./summary/summary_' + files + '.csv')

#%% summarize all data together
directory = 'D:/WangLab_data/Data_Analysis_WholeBrain_cFos/summary'
os.chdir(directory)
i = 0
for f in os.listdir(directory):
    temp = pd.read_csv(os.path.join(directory, f))
    i +=1
    if i ==1:
        data = temp
    else:
        data = pd.concat([data,temp])
        
        



