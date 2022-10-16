# -*- coding: utf-8 -*-
"""
Created on Tue Oct  4 21:26:53 2022

@author: KeChen
"""

import matplotlib.pyplot as plt
import numpy as np
import os
import pandas as pd 
 # now import pylustrator
import pylustrator
import seaborn as sns


directory = 'D:/Project_Master_Folder/Withdrawal-Pain-Anxiety/Data_Analysis_WholeBrain_cFos/summary'
os.chdir(directory)

i = 0
for filenames in os.listdir(directory):
    if filenames.endswith('.csv'):
        # Prepare the Summary DataFrame for Each Session
        df = pd.read_csv(os.path.join(directory, filenames), header = 0, nrows = 3)
    else:
        continue
    if i == 0:
        data = df
    else:
        data = data.append(df, True)
    i = i+1
    
"""
change the format of the data from wide to long for easier procesing

"""
column_name = data.columns.tolist()
column_name[0] = 'animalID'
data.columns = column_name

long_data = data.melt(id_vars = ['animalID', 'treatment'], value_vars= column_name[2::], 
                      var_name= 'regions', value_name = 'cFos Density')

# Draw a nested barplot by species and sex
g = sns.catplot(
    data=long_data, kind="bar",
    x="regions", y="cFos Density", hue="treatment",
     palette="dark", alpha=.6, height=6
)

"""
clear the data for valerie
"""
data['IC'] = (data['GU'] + data['AI'] + data['VISC'])/3
clean_data  = data.drop(columns= ['CLA', 'BST', 'VTA', 'PAG', 'PB', 'LC', 'ACA', 'GU', 'AI', 'VISC'])

long_clean_data = clean_data.melt(id_vars = ['animalID', 'treatment'], value_vars= clean_data.columns.tolist()[2::], 
                      var_name= 'regions', value_name = 'cFos Density')

# Draw a nested barplot by species and sex
g = sns.catplot(
    data=long_clean_data, kind="bar",
    x="regions", y="cFos Density", hue="treatment",
     palette="dark", alpha=.6, height=6
)

