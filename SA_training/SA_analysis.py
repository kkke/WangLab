# -*- coding: utf-8 -*-
"""
Created on Wed Aug 31 17:12:03 2022

@author: KeChen
"""
import os
import pandas as pd
import matplotlib.pyplot as plt
from medpc_read import medpc_readdata

wkdirectory = 'D:\Matlab_scripts\WangLab\SA_training'
os.chdir(wkdirectory)


datadirectory = 'H:\Data\SA_training\SA_25'

i = 0
for filenames in os.listdir(datadirectory):
    if filenames.endswith('.txt'):
        # Prepare the Summary DataFrame for Each Session
        temp= medpc_readdata(os.path.join(datadirectory, filenames))
        
    else:
        continue
    if i == 0:
        data = temp
    else:
        data = pd.concat([data,  temp], ignore_index=True)
    i = i+1
#%%
data.plot( y = 'Reward')