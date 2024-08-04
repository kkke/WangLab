# -*- coding: utf-8 -*-
"""
Created on Mon May 22 13:54:03 2023

@author: KeChen
"""
import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

def load_csv_batch(directory):
    i = 0
    for filenames in os.listdir(directory):
        if filenames.endswith('.csv'):
            # Prepare the Summary DataFrame for Each Session
            df = pd.read_csv(os.path.join(directory, filenames), header = 0)
        else:
            continue
        if i == 0:
            data = df
        else:
            data = pd.concat([data,df], ignore_index=True)
        i = i+1    
    data.head()
    return data

def zeroMaze_analysis(data):
    fig = plt.figure(figsize = (4, 6))
    sns.barplot(
        data,
        x="Treatment", y="Open : time", width= 0.5)

    sns.scatterplot(
        data,
        x="Treatment", y="Open : time",  
    )
    plt.ylabel('Time (s) in Open Arm')
    return fig

    # plt.figure(figsize=(4, 6)) 
    # sns.barplot(
    #     data,
    #     x="Treatment", y="Open : distance")

    # sns.scatterplot(
    #     data,
    #     x="Treatment", y="Open : distance",  
    # )
    # plt.ylabel('Distance(m) in Open Arm')
def openfield_analysis(data):
    plt.figure(figsize = (4, 6))
    sns.barplot(
        data = data,
        x="Treatment", y="all_Centertime", width = 0.25)

    sns.scatterplot(
        data=data,
        x="Treatment", y="all_Centertime")
    plt.ylabel('Duration in Center (s)')


    plt.figure(figsize = (4, 6))
    sns.barplot(
        data = data,
        x="Treatment", y="all_CenterDistance", width = 0.25)
    sns.scatterplot(
        data=data,
        x="Treatment", y="all_CenterDistance")
    plt.ylabel('Center Movement Distance (m)')

    plt.figure(figsize = (4, 6))
    sns.barplot(
        data = data,
        x="Treatment", y="all_distance", width = 0.25)
    plt.ylabel('Locomotion Distance (m)')

    sns.scatterplot(
        data=data,
        x="Treatment", y="all_distance")
    plt.ylabel('Movement Distance (m)')