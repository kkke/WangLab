# -*- coding: utf-8 -*-
"""
Created on Thu May  2 14:46:49 2024

@author: KeChen
"""

#%% Load necessary Module
import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import behavioral_analysis_function as baf
import scipy.stats as stats
# import pylustrator
#%% check the Open Field test: DataSet01; data are analyzed as 5 min snippets
# Data Directory
data_directory = r'D:\Project_Master_Folder\fMRI_Withdrawal\Chronic_Withdrawal_Data\OpenField\DataSet01'
data = baf.load_csv_batch(data_directory)

# Let's calculate the total distance travel and Time Spent in the Center in 10 min
# Use list(data) to check the column variables
Distance = data['0-300; All : distance'].values + data['300-600; All : distance'].values
Time_Center = data['0-300; Center : time'].values + data['300-600; Center : time'].values
Time_Corner = data['0-300; Corner : time'].values + data['300-600; Corner : time'].values
Animal = data['Animal']
Treatment = data['Treatment']
summary_data = pd.DataFrame({'Animal':Animal, 'Treatment': Treatment, 'OF Distance': Distance,
                              'OF Center Time': Time_Center, 'OF Corner Time': Time_Corner})

#%% save summary data
save_file = r'D:\Project_Master_Folder\fMRI_Withdrawal\Chronic_Withdrawal_Data\OpenField\Summary'
summary_data.to_csv(save_file + 'DataSet01.csv', index=False)

#%% check the Open Field test: Data are analyzed as a 10 min period
data_directory = r'D:\Project_Master_Folder\fMRI_Withdrawal\Chronic_Withdrawal_Data\OpenField'
data = baf.load_csv_batch(data_directory)

# Let's calculate the total distance travel and Time Spent in the Center in 10 min
# Use list(data) to check the column variables
Distance = data['0-600; All : distance'].values
Time_Center = data['0-600; Center : time'].values
Time_Corner = data['0-600; Corner : time'].values
Animal = data['Animal']
Treatment = data['Treatment']
summary_data = pd.DataFrame({'Animal':Animal, 'Treatment': Treatment, 'OF Distance': Distance,
                              'OF Center Time': Time_Center, 'OF Corner Time': Time_Corner})
#%% save summary data
save_file = r'D:\Project_Master_Folder\fMRI_Withdrawal\Chronic_Withdrawal_Data\OpenField\Summary'
summary_data.to_csv(save_file + 'DataSet02.csv', index=False)


#%%------------------------------Analyze the Zero Maze------------------------------------------%%#
#--------------------------------Analyze the Zero Maze-------------------------------------------#
#--------------------------------Analyze the Zero Maze-------------------------------------------#
#--------------------------------Analyze the Zero Maze-------------------------------------------#
#%%
# Data Directory
data_directory = r'D:\Project_Master_Folder\fMRI_Withdrawal\Chronic_Withdrawal_Data\ZeroMaze\DataSet'
data = baf.load_csv_batch(data_directory)

# Only analyze 0-5 min; as some animals only perform 5 min
subdata01 = data[data['Segment of test'] == '0 - 300 secs.']

#%% save the data
save_file = r'D:\Project_Master_Folder\fMRI_Withdrawal\Chronic_Withdrawal_Data\ZeroMaze\Summary'
subdata01.to_csv(save_file + 'DataSet0-5min.csv', index=False)

#%% combine 0-5 min with 5-10 min data
subdata01.drop(range(20, 25), inplace=True)
subdata02 = data[data['Segment of test'] == '300 - 600 secs.']
sum_data = subdata01[['Animal', 'Treatment', 'Apparatus']].copy()
open_time_all = subdata01['Open : time'].values + subdata02['Open : time'].values
close_time_all = subdata01['Close : time'].values + subdata02['Close : time'].values
open_distance_all = subdata01['Open : distance'].values + subdata02['Open : distance'].values
close_distance_all = subdata01['Close : distance'].values + subdata02['Close : distance'].values
sum_data = sum_data.assign(open_time_all=open_time_all,
                          close_time_all = close_time_all,
                          open_distance_all = open_distance_all,
                          close_distance_all = close_distance_all)

sum_data.to_csv(save_file + 'DataSet0-10min.csv', index=False)

#%%------------------------------Analyze Acute Withdrawal----------------------------------------%%#
#--------------------------------Analyze Acute Withdrawal----------------------------------------#
#--------------------------------Analyze Acute Withdrawal----------------------------------------#
#--------------------------------Analyze Acute Withdrawal----------------------------------------#
#%%








