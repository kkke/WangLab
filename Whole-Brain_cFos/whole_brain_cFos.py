# -*- coding: utf-8 -*-
"""
Created on Mon Aug 29 11:48:23 2022

@author: KeChen
"""
import os
import pandas as pd
import matplotlib.pyplot as plt

# =============================================================================
# directory = 'I:\LifeCanvas CRO datasets\May 2022 datasets\FanWang_03292022_MIT_analysis'
# filename = 'combined_density_FanWang_03292022_MIT_6.csv'
# 
# =============================================================================

directory = 'I:\LifeCanvas CRO datasets\March 2022 datasets\MIT_Wang_12142021_analysis'
filename = 'combined_density_MIT_Wang_12142021_6.csv'
os.chdir(directory)

#%% extract useful information
rawData = pd.read_csv(os.path.join(directory, filename))
print(rawData.head())

# brain regions for analysis
Ctx_regions = ['GU', 'AI', 'VISC', 'ACA']
Str_regions = ['ACB', 'PVT', 'PSTN', 'VTA', 'PAG', 'PB', 'LC']
Amg_regions = ['CLA', 'BST', 'BLA', 'CEA']


all_regions = Ctx_regions + Str_regions + Amg_regions

#for region in all_regions:
#    sub_data = sub_data.append(rawData.loc[rawData['acronym'] == region], ignore_index=True)
    
sub_data_L = pd.concat([rawData.loc[rawData['acronym'] == region + '-L'] for region in all_regions],
          ignore_index=True)
sub_data_R = pd.concat([rawData.loc[rawData['acronym'] == region + '-R'] for region in all_regions],
          ignore_index=True)


sub_data_L.plot.bar(x = 'acronym', y = [6, 7,8], title = 'Left', xlabel = 'Regions', ylabel = 'cFos+ Density (cells/mm^3)')
sub_data_R.plot.bar(x = 'acronym', y = [6, 7,8], title = 'Right', xlabel = 'Regions', ylabel = 'cFos+ Density (cells/mm^3)')

sub_data = pd.DataFrame(columns =sub_data_L.columns[-3::])
sub_data.iloc[:,0] = (sub_data_L.iloc[:,6] + sub_data_R.iloc[:,6])/2
sub_data.iloc[:,1] = (sub_data_L.iloc[:,7] + sub_data_R.iloc[:,7])/2
sub_data.iloc[:,2] = (sub_data_L.iloc[:,8] + sub_data_R.iloc[:,8])/2
# sub_data.insert(0, 'volume (mm^3)', sub_data_L['volume (mm^3)'] + sub_data_R['volume (mm^3)']) 
sub_data.insert(0, 'regions', all_regions)
sub_data.plot.bar(x = 'regions', y = [1, 2, 3])
#%% re-organize the data
sub_data_transpose = sub_data.T
sub_data_transpose.columns = sub_data_transpose.iloc[0,:]
sub_data_transpose = sub_data_transpose.drop(sub_data_transpose.index[0])
sub_data_transpose.insert(0, 'treatment', ['saline-naloxone', 'morphine-saline','morphine-naloxone'])

# sub_data_transpose.insert(0, 'treatment', ['morphine-saline', 'morphine-naloxone','saline-naloxone'])

#%% save the data to csv file
summaryfolder = 'D:\Project_Master_Folder\Withdrawal-Pain-Anxiety\Data_Analysis_WholeBrain_cFos'
files = 'kcmp22-24'
os.chdir(summaryfolder)
os.makedirs('.\summary', exist_ok=True)
rawData.to_csv('./summary/' +  files + 'Raw.csv')
sub_data_transpose.to_csv('./summary/summary_' + files + '.csv')
