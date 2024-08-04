#%%
# -*- coding: utf-8 -*-
"""
Created on Wed Aug 31 17:12:03 2022

@author: KeChen
"""
import os
import pandas as pd
import matplotlib.pyplot as plt
import medpc_read as mr
import scipy.io
#%%
# summarydata = {}
# wkdirectory = 'D:\Matlab_scripts\WangLab\SA_training'
# os.chdir(wkdirectory)

animalID = ['SA_74']
datadirectory = 'H:/Data/SA_training/'
datadir = datadirectory + animalID[0] + '/Acquisition'
data= mr.medpc_preprocess(datadir)

# %%
animalID = ['SA_84']
datadirectory = 'H:/Data/SA_training/'
datadir = datadirectory + animalID[0] + '/PR'
data= mr.medpc_readreward(datadir)
summaryfolder = 'H:/Data/SA_training/Summary'
data.to_csv(summaryfolder + '/' + animalID[0] + '_PR.csv')
# %%
# %%
animalID = ['SA_82']
datadirectory = 'H:/Data/SA_training/'
datadir = datadirectory + animalID[0] + '/ThreeHoursSessions'
data= mr.medpc_preprocess(datadir)
# %%
