# -*- coding: utf-8 -*-
"""
Created on Mon May 22 09:38:01 2023

@author: KeChen
"""

# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

#%% Load necessary Module
import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import behavioral_analysis_function as baf
import scipy.stats as stats
# import pylustrator
# %%
directory = 'D:/Project_Master_Folder/Withdrawal-Pain-Anxiety/Pain/VonFrey_SummaryData.xlsx'
data = pd.read_excel(directory)
data.head()

# Plot the lines on two facets
sns.relplot(
    data=data,
    x="Test_day", y="Threshold",
    hue="Treatment",  col="Hindpaw",
    kind="line", 
    height=5, aspect=.75, facet_kws=dict(sharex=False),
)

# %% [markdown]
# Type you Open fied data folder directory here

# %% Load data Open Field
directory = 'D:/Project_Master_Folder/Withdrawal-Pain-Anxiety/Anxiety/OpenField/IC_MW'   
data = baf.load_csv_batch(directory)
# data['all_distance']       = data['0-300; All : distance'] + data['300-600; All : distance']
# data['all_Centertime']     = data['0-300; Center : time'] + data['300-600; Center : time']
# data['all_CenterDistance'] = data['0-300; Center : distance'] + data['300-600; Center : distance']

# activate pylustrator
# pylustrator.start()

fig, axes = plt.subplots(1, 2, figsize=(8, 6))
sns.barplot(data, x = 'Treatment', y = '0-600; All : distance', errorbar="se", order = ['mCherry', 'hM4Di'], ax = axes[0])
# adding data points 
sns.stripplot(data, x='Treatment', y='0-600; All : distance', color="grey", size=8,  order = ['mCherry', 'hM4Di'], ax = axes[0])


sns.barplot(data, x = 'Treatment', y = '0-600; Center : time', errorbar="se", order = ['mCherry', 'hM4Di'], ax = axes[1])
sns.stripplot(data, x="Treatment", y='0-600; Center : time',color="grey", size=8, order = ['mCherry', 'hM4Di'], ax = axes[1])

# sns.barplot(data, x = 'Treatment', y = '0-600; Peri : time', errorbar="se", ax = axes[1, 0])
# sns.stripplot(data, x="Treatment", y='0-600; Peri : time',color="grey", size=8, ax = axes[1, 0])

# sns.barplot(data, x = 'Treatment', y = '0-600; Corner : time', errorbar="se", ax = axes[1, 1])
# sns.stripplot(data, x="Treatment", y='0-600; Corner : time',color="grey", size=8, ax = axes[1, 1])
plt.show()
plt.figure(1).ax_dict = {ax.get_label(): ax for ax in plt.figure(1).axes}
plt.figure(1).axes[0].set(position=[0.125, 0.53, 0.1701, 0.35])
plt.figure(1).axes[0].get_yaxis().get_label().set(position=(74.12, 0.5), text='Distance Traveled (m)', fontsize=12., fontname='Arial')
plt.figure(1).axes[0].tick_params(axis='y', which='major', labelsize=10)
plt.figure(1).axes[0].set_xlabel("")

plt.figure(1).axes[1].set(position=[0.4448, 0.53, 0.1701, 0.35], xlabel='')
plt.figure(1).axes[1].get_yaxis().get_label().set(position=(351.9, 0.5), text='Time Spent in Center (s)', fontsize=12., fontname='Arial')
plt.figure(1).axes[1].tick_params(axis='y', which='major', labelsize=10)
# Example data (replace with your own)
# data1 = data[data['Treatment'] == 'mCherry']['0-600; Center : time']
# data2 = data[data['Treatment'] == 'hM4Di']['0-600; Center : time']

# # Perform the two-sample t-test
# t_statistic, p_value = stats.ttest_ind(data1, data2)

# # Interpret the results
# if p_value < 0.05:
#     print("Reject the null hypothesis: Means are significantly different.")
# else:
#     print("Fail to reject the null hypothesis: No significant difference in means.")

# %% Save File
save_file = 'D:/Project_Master_Folder/Withdrawal-Pain-Anxiety/Anxiety/OpenField/IC_MW/summary.csv'
data.to_csv(save_file, index = False)
# %% [markdown]
# Zero Maze analysis
directory = 'D:/Project_Master_Folder/Withdrawal-Pain-Anxiety/Anxiety/ZeroMaze/IC_MW'
data = baf.load_csv_batch(directory)
# data['Treatment'].replace({'FMRI-Saline': 'Saline', 'FMRI_Morphine_Naloxone' : 'Morphine',
#                              'FMRI-Morphine': 'Morphine', 'Morphine-FMRI' : 'Morphine' }, inplace= True)
subdata01 = data[data['Segment of test'] == '0 - 300 secs.']
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

# Define a 2x2 plotting region
fig, axes = plt.subplots(2, 2, figsize=(8, 8))

# Open Arm
plot_var = 'open_time_all'    
sns.barplot(sum_data, x = 'Treatment', y = plot_var, errorbar="se", width=0.6,ax = axes[0, 0])
# adding data points 
sns.stripplot(sum_data, x='Treatment', y=plot_var, color="grey", size=8, ax = axes[0, 0])

plot_var = 'open_distance_all'    
sns.barplot(sum_data, x = 'Treatment', y = plot_var, errorbar="se", width=0.6,ax = axes[0, 1])
# adding data points 
sns.stripplot(sum_data, x='Treatment', y=plot_var, color="grey", size=8, ax = axes[0, 1])

plot_var = 'close_time_all'    
sns.barplot(sum_data, x = 'Treatment', y = plot_var, errorbar="se", width=0.6,ax = axes[1, 0])
# adding data points 
sns.stripplot(sum_data, x='Treatment', y=plot_var, color="grey", size=8, ax = axes[1, 0])
plot_var = 'close_distance_all'    
sns.barplot(sum_data, x = 'Treatment', y = plot_var, errorbar="se", width=0.6,ax = axes[1, 1])
# adding data points 
sns.stripplot(sum_data, x='Treatment', y=plot_var, color="grey", size=8, ax = axes[1, 1])

plt.show() 
# Perform the two-sample t-test
#% start: automatic generated code from pylustrator
plt.figure(1).ax_dict = {ax.get_label(): ax for ax in plt.figure(1).axes}
import matplotlib as mpl
# getattr(plt.figure(1), '_pylustrator_init', lambda: ...)()
plt.figure(1).set_size_inches(20.000000/2.54, 20.000000/2.54, forward=True)
plt.figure(1).axes[0].set(position=[0.125, 0.53, 0.1701, 0.35])
plt.figure(1).axes[0].get_yaxis().get_label().set(position=(74.12, 0.5), text='Time Spent in Open Arm (s)', fontsize=12., fontname='Arial')
plt.figure(1).axes[1].set(position=[0.4448, 0.53, 0.1701, 0.35], xlabel='')
plt.figure(1).axes[1].get_yaxis().get_label().set(position=(351.9, 0.5), text='Distance Traveled in Open Arm (m)', fontsize=12., fontname='Arial')
plt.figure(1).axes[2].set(position=[0.125, 0.11, 0.1701, 0.35], xlabel='', ylabel='Time Spent in Close Arm (s)')
plt.figure(1).axes[2].get_yaxis().get_label().set(position=(64.37, 0.5), text='Time Spent in Close Arm (s)', fontsize=12., fontname='Arial')
plt.figure(1).axes[3].set(position=[0.4448, 0.11, 0.1701, 0.35], xlabel='')
plt.figure(1).axes[3].get_yaxis().get_label().set(position=(356.8, 0.5), text='Distance Traveled in Closed Arm (m)', fontsize=12., fontname='Arial')
#% end: automatic generated code from pylustrator
t_statistic, p_value = stats.ttest_ind(sum_data[sum_data['Treatment'] == 'mCherry'][plot_var], 
                                       sum_data[sum_data['Treatment'] =='hM4Di'][plot_var])

# #% start: automatic generated code from pylustrator
# plt.figure(1).ax_dict = {ax.get_label(): ax for ax in plt.figure(1).axes}
# import matplotlib as mpl
# getattr(plt.figure(1), '_pylustrator_init', lambda: ...)()
# plt.figure(1).set_size_inches(20.000000/2.54, 20.000000/2.54, forward=True)
# plt.figure(1).axes[0].set(position=[0.125, 0.53, 0.1701, 0.35])
# plt.figure(1).axes[0].get_yaxis().get_label().set(position=(74.12, 0.5), text='Time Spent in Open Arm (s)', fontsize=12., fontname='Arial')
# plt.figure(1).axes[1].set(position=[0.4448, 0.53, 0.1701, 0.35], xlabel='')
# plt.figure(1).axes[1].get_yaxis().get_label().set(position=(351.9, 0.5), text='Distance Traveled in Open Arm (m)', fontsize=12., fontname='Arial')
# plt.figure(1).axes[2].set(position=[0.125, 0.11, 0.1701, 0.35], xlabel='', ylabel='Time Spent in Close Arm (s)')
# plt.figure(1).axes[2].get_yaxis().get_label().set(position=(64.37, 0.5), text='Time Spent in Close Arm (s)', fontsize=12., fontname='Arial')
# plt.figure(1).axes[3].set(position=[0.4448, 0.11, 0.1701, 0.35], xlabel='')
# plt.figure(1).axes[3].get_yaxis().get_label().set(position=(356.8, 0.5), text='Distance Traveled in Closed Arm (m)', fontsize=12., fontname='Arial')
# #% end: automatic generated code from pylustrator

# Interpret the results
if p_value < 0.05:
    print("Reject the null hypothesis: Means are significantly different.")
else:
    print("Fail to reject the null hypothesis: No significant difference in means.")

# %% Plot the data
fig = baf.zeroMaze_analysis(subdata)
fig.savefig()
# %%
save_file = 'D:/Project_Master_Folder/Withdrawal-Pain-Anxiety/Anxiety/ZeroMaze/FMRI/'

subdata.to_csv(save_file + 'summary_052223.csv', index=False)
# %%
fig.savefig(save_file + 'summary_052223.jpg')

# %%
# %% Load data Withdrawal
directory = r'D:\Project_Master_Folder\Withdrawal-Pain-Anxiety\IC_MW_Withdrawal'
data = baf.load_csv_batch(directory)
# Define a 2x2 plotting region
fig, axes = plt.subplots(2, 2, figsize=(8, 8))

# Open Arm
plot_var = 'num_jump'    
sns.barplot(data, x = 'Treatment', y = plot_var, errorbar="se",  order = ['mCherry', 'hM4Di'], width=0.6,ax = axes[0, 0])
# adding data points 
sns.stripplot(data, x='Treatment', y=plot_var, color="grey",  order = ['mCherry', 'hM4Di'], size=8, ax = axes[0, 0])

plot_var = 'num_rearing'    
sns.barplot(data, x = 'Treatment', y = plot_var, errorbar="se",  order = ['mCherry', 'hM4Di'], width=0.6,ax = axes[0, 1])
# adding data points 
sns.stripplot(data, x='Treatment', y=plot_var, color="grey",  order = ['mCherry', 'hM4Di'], size=8, ax = axes[0, 1])

plot_var = 'num_tremor'    
sns.barplot(data, x = 'Treatment', y = plot_var, errorbar="se",  order = ['mCherry', 'hM4Di'], width=0.6,ax = axes[1, 0])
# adding data points 
sns.stripplot(data, x='Treatment', y=plot_var, color="grey",  order = ['mCherry', 'hM4Di'], size=8, ax = axes[1, 0])

plot_var = 'num_shaking'    
sns.barplot(data, x = 'Treatment', y = plot_var, errorbar="se",  order = ['mCherry', 'hM4Di'], width=0.6,ax = axes[1, 1])
# adding data points 
sns.stripplot(data, x='Treatment', y=plot_var, color="grey",  order = ['mCherry', 'hM4Di'], size=8, ax = axes[1, 1])
plt.show() 

plt.figure(1).set_size_inches(20.000000/2.54, 20.000000/2.54, forward=True)
plt.figure(1).axes[0].set(position=[0.125, 0.53, 0.1701, 0.35])
plt.figure(1).axes[0].get_yaxis().get_label().set(position=(74.12, 0.5), text='Jump #', fontsize=12., fontname='Arial')
plt.figure(1).axes[0].get_xaxis().get_label().set(text='')
plt.figure(1).axes[1].set(position=[0.4448, 0.53, 0.1701, 0.35], xlabel='')
plt.figure(1).axes[1].get_yaxis().get_label().set(position=(351.9, 0.5), text='Rearing #', fontsize=12., fontname='Arial')
plt.figure(1).axes[2].set(position=[0.125, 0.11, 0.1701, 0.35], xlabel='')
plt.figure(1).axes[2].get_yaxis().get_label().set(position=(64.37, 0.5), text='Forepaw Tremor #', fontsize=12., fontname='Arial')
plt.figure(1).axes[3].set(position=[0.4448, 0.11, 0.1701, 0.35], xlabel='')
plt.figure(1).axes[3].get_yaxis().get_label().set(position=(356.8, 0.5), text='Wet-dog Shake #', fontsize=12., fontname='Arial')
#% end: automatic generated code from pylustrator
t_statistic, p_value = stats.ttest_ind(data[data['Treatment'] == 'mCherry'][plot_var], 
                                       data[data['Treatment'] =='hM4Di'][plot_var])
