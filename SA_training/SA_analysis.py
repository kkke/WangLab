# -*- coding: utf-8 -*-
"""
Created on Wed Aug 31 17:12:03 2022

@author: KeChen
"""
import os
import pandas as pd
import matplotlib.pyplot as plt
from medpc_read import medpc_readdata

summarydata = {}
wkdirectory = 'D:\Matlab_scripts\WangLab\SA_training'
os.chdir(wkdirectory)

animalID = ['SA_17', 'SA_20', 'SA_22', 'SA_23', 'SA_25', 'SA_26', 'SA_27', 'SA_29', 'SA_30', 'SA_31']

datadirectory = 'H:\Data\SA_training'
for animal in animalID:
    filedir = os.path.join(datadirectory, animal)
        
    i = 0
    for filenames in os.listdir(filedir):
        if filenames.endswith('.txt'):
            # Prepare the Summary DataFrame for Each Session
            temp= medpc_readdata(os.path.join(filedir, filenames))
            
        else:
            continue
        if i == 0:
            data = temp
        else:
            data = pd.concat([data,  temp], ignore_index=True)
        i = i+1
    subject = data['subject'][0]
    # save all data in one file
    summarydata[subject] = data 

    activeLever = data['training'][6][0]
    if activeLever == 'F':
        inactiveLever = 'B'
    else:
        inactiveLever = 'F'
        
    data['activeLeverPress'] = data['Resp-' + activeLever] + data['Resp-Cue-' + activeLever]
    data['inactiveLeverPress'] = data['Resp-' + inactiveLever] + data['Resp-Cue-' + inactiveLever]
    
    data['activeLeverPress-Cue'] = data['Resp-Cue-' + activeLever]
    data['inactiveLeverPress-Cue'] = data['Resp-Cue-' + inactiveLever]
    
    savedirectory = 'D:\Project_Master_Folder\Self-Administration\data'
    
    data.to_csv(os.path.join(savedirectory, subject + '_Acquisition.csv'))
# data.plot( y = ['activeLeverPress', 'inactiveLeverPress'])

#%% save data
import pickle
# create a binary pickle file 
filetosave = os.path.join(savedirectory, 'summary_all.pkl')
f = open(filetosave,"wb")
# write the python object (dict) to pickle file
pickle.dump(summarydata,f)

# close file
f.close()

#%% select data for plotting

import pickle
savedirectory = 'D:\Project_Master_Folder\Self-Administration\data'
# create a binary pickle file 
filetosave = os.path.join(savedirectory, 'summary_all.pkl')
file = open(filetosave, 'rb')

# dump information to that file
summarydata = pickle.load(file)

# close the file
file.close()

subdata = {}
lengthofdata = 12
subdata['sa17'] = summarydata['sa17'].iloc[5:17, :].reset_index(drop = True)
subdata['sa20'] = summarydata['sa20'].iloc[4:16, :].reset_index(drop = True)
subdata['sa22'] = summarydata['sa22'].iloc[5:17,:].reset_index(drop = True)
subdata['sa23'] = summarydata['sa23'].iloc[3:15,:].reset_index(drop = True)
subdata['sa25'] = summarydata['sa25'].iloc[3:15,:].reset_index(drop = True)
subdata['sa26'] = summarydata['sa26'].iloc[3:15,:].reset_index(drop = True)
subdata['sa27'] = summarydata['sa27'].iloc[3:15,:].reset_index(drop = True)
subdata['sa29'] = summarydata['sa29'].iloc[3:, :].reset_index(drop = True)
subdata['sa30'] = summarydata['sa30'].iloc[3:, :].reset_index(drop = True)
subdata['sa31'] = summarydata['sa31'].iloc[3:, :].reset_index(drop = True)
#%%
keys = ['sa17', 'sa20', 'sa22', 'sa23', 'sa25', 'sa26', 'sa27']
treatments = ['cocaine', 'cocaine', 'cocaine', 'cocaine', 'cocaine', 'cocaine', 'saline']
for key, treatment in zip(keys,treatments):
    subdata[key].insert(1, 'treatment', [treatment] * lengthofdata)
    
for key in keys:
    sub_data_pd = pd.concat([subdata[key] for key in keys])
sub_data_pd.insert(1, 'Session', sub_data_pd.index)
sub_data_pd = sub_data_pd.reset_index(drop = True)
#%% summary plot
import seaborn as sns
custom_params = {"axes.spines.right": False, "axes.spines.top": False}
sns.set_theme(style="ticks", rc=custom_params)

# Draw a pointplot to show pulse as a function of three categorical factors
g = sns.pointplot(x="Session", y='activeLeverPress', hue="treatment", ci = 68,
                capsize=.2,  markers=["^", "o"], height=3, aspect=.75,
                kind="point", data=sub_data_pd)

sns.pointplot(x="Session", y='inactiveLeverPress', hue="treatment", ci = 68,
                capsize=.2,  markers=["^", 'o'], height=3, aspect=.75,
                kind="point", data=sub_data_pd, linestyles= ['--', '--'], ax = g)

summary_fig = g.get_figure()
  
# use savefig function to save the plot and give 
# a desired name to the plot.
summary_fig.savefig(os.path.join(savedirectory, 'summaryplot.pdf'))
#%%
import numpy as np

keys = ['sa17', 'sa20', 'sa22', 'sa23', 'sa25', 'sa26', 'sa27']
plotkeys = ['activeLeverPress', 'inactiveLeverPress']
plotdata = {}

for plotkey in plotkeys:
    plotdata[plotkey] = pd.DataFrame(columns= keys)
    for key in keys:
        plotdata[plotkey][key] = subdata[key][plotkey].reset_index(drop = True)
        # temp = subdata[key][plotkey].to_frame()
        # temp.rename(columns = {plotkey : key})
    meanvalue = plotdata[plotkey].iloc[:, 0:6].mean(axis = 1)
    sem       = plotdata[plotkey].std(axis = 1)/np.sqrt(6)
    plotdata[plotkey]['mean'] = meanvalue
    plotdata[plotkey]['sem'] = sem
    plotdata[plotkey].insert(0, 'FR', summarydata['sa17'].iloc[5:17, 3].reset_index(drop = True))

ax = plotdata['activeLeverPress'].plot(y = 'mean', yerr = 'sem', ylim = (0, 400), legend = 'Active Lever')
plotdata['inactiveLeverPress'].plot(ax = ax, y = 'mean', yerr = 'sem',  ylim = (0, 400))