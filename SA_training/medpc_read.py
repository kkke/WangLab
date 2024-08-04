# -*- coding: utf-8 -*-
"""
Created on Wed Aug 31 22:38:47 2022

@author: llkon
"""

import re  #for word processing
import pandas as pd    #for data loading and manipulation
import os #for access folder
import numpy as np   #for calculaiton
from openpyxl import load_workbook
from datetime import datetime
from collections import defaultdict
import scipy.io
Tree= lambda: defaultdict(Tree)

# =============================================================================
# directory = 'D:\WangLab_data\SA_training\SA_25'
# os.chdir(directory)
# 
# # if you don't want export you data into *.xlsx file
# file = '2022-07-06_11h42m_Subject sa25.txt'
# =============================================================================
def medpc_readdata(file):
    alldata_tree = Tree()
    subject_list= []
    MSN_dict={}
    nowtime = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
    progamnames = []
        
    #################################
    #load raw file into dict
    #################################
    with open(file, 'r') as f:
        datasets = f.read().split('Start Date: ') #Split the data file at Start Dates
        working_var_label= ['A', 'B', 'C', 'G','L', 'M', 'N', 'O', 'W']    
        
    theData = datasets[1]
    thisDate = (datetime.strptime(theData[0:8], "%m/%d/%y")).strftime("%Y-%m-%d")
    thisDate = thisDate.replace('-','')
    data_dict = {}
    if theData.find('\r\n'):
        theData = theData.replace('\r\n', '\n')
        splitOffData = theData.split('MSN:')
        match = re.search('Subject: .*\n', splitOffData[0])
        subject = match.group(0).split(':')[1].strip()
        subject_list.append(subject)
        variables = splitOffData[1].split('\n')
        match2 = re.search('Box: .*\n', splitOffData[0])
        box = match2.group(0).split(':')[1].strip()
        programname = variables.pop(0).strip()
        #if there is date needed to be remove from a ID's data
        #then skip all the extraction process below
        #only extract data that we need    
        #recognize all defined variable name in MSN protocol    
        if programname == 'Extinction_LMS':
            print('Start loading extinction session')
            working_var_label.pop()
        
        for idx, var in enumerate(working_var_label, 1):
            if idx < len(working_var_label):
                start = variables.index(working_var_label[idx-1]+":")
                end = variables.index(working_var_label[idx]+":")
                data = variables[start+1:end]
            else:
                start = variables.index(working_var_label[idx-1]+":")
                data = variables[start+1:]
            temp = []
    
            for d in data:
                if d!='':
                    temp += re.split('\s+',d.split(':')[1])
                    temp.remove('')
                #convert str --> numbers
            data_dict[var.strip(':')] =  pd.to_numeric(pd.Series(temp, name = var.strip(':'),dtype = float))
        alldata_tree[programname][thisDate][subject] = data_dict
      
    sumdata = {}
    sumdata['subject'] = subject
    sumdata['training'] = programname
    sumdata['date'] = thisDate
    sumdata['FR'] = data_dict['A'][2]
    sumdata['Resp-B'] = data_dict['B'][1]
    sumdata['Resp-F'] = data_dict['B'][2]
    sumdata['Resp-Cue-B'] = data_dict['B'][6]
    sumdata['Resp-Cue-F'] = data_dict['B'][7]
    sumdata['Resp-Total'] = data_dict['B'][0]
    sumdata['Reward'] = data_dict['B'][3]
    
    summarydata = pd.DataFrame(sumdata.items()).transpose()
    summarydata.columns = summarydata.iloc[0,:]
    summarydata = summarydata.drop(summarydata.index[0])
    return summarydata, data_dict

def medpc_preprocess(filedir):
    i = 0
    timestamps = []
    for filenames in os.listdir(filedir):
        if filenames.endswith('.txt'):
            # Prepare the Summary DataFrame for Each Session
            temp, temp_dict= medpc_readdata(os.path.join(filedir, filenames))
        else:
            continue
        if i == 0:
            data = temp
        else:
            data = pd.concat([data,  temp], ignore_index=True)
        timestamps.append(medpc_readtimestamps(temp_dict))
        # scipy.io.savemat(filedir + filenames + '_timestamps.mat', timestamps)
        i = i+1
    subject = data['subject'][0]
    # save all data in one file
    #summarydata[subject] = data 

    activeLever = data['training'][2][0]
    if activeLever == 'F':
        inactiveLever = 'B'
    else:
        inactiveLever = 'F'
        
    data['activeLeverPress'] = data['Resp-' + activeLever] + data['Resp-Cue-' + activeLever]
    data['inactiveLeverPress'] = data['Resp-' + inactiveLever] + data['Resp-Cue-' + inactiveLever]
    
    data['activeLeverPress-Cue'] = data['Resp-Cue-' + activeLever]
    data['inactiveLeverPress-Cue'] = data['Resp-Cue-' + inactiveLever]

    data.to_csv(os.path.join(filedir, subject + "_" + filedir.strip().split("/")[-1] + '.csv'))

    return data, timestamps

    #savedirectory = 'D:\Project_Master_Folder\Self-Administration\data'

def medpc_readtimestamps(data_dict):
    timestamps = {}
    timestamps['cue'] = data_dict['G']
    back_lever  = data_dict['L']
    front_lever = data_dict['M']
    timestamps['reward']      = data_dict['W']
    timestamps['back_lever']  = list(filter(lambda x: x !=0, back_lever))
    timestamps['front_lever'] = list(filter(lambda x: x != 0,front_lever))
    return timestamps

def medpc_readreward(filedir):
    alldata_tree = Tree()
    subject_list= []
    MSN_dict={}
    nowtime = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
    progamnames = []
    for filenames in os.listdir(filedir): 
        if filenames.endswith('.txt'):
            file = os.path.join(filedir, filenames)
    #################################
    #load raw file into dict
    #################################
    with open(file, 'r') as f:
        datasets = f.read().split('Start Date: ') #Split the data file at Start Dates
    working_var_label= ['A', 'B']    
        
    theData = datasets[1]
    thisDate = (datetime.strptime(theData[0:8], "%m/%d/%y")).strftime("%Y-%m-%d")
    thisDate = thisDate.replace('-','')
    data_dict = {}
    if theData.find('\r\n'):
        theData = theData.replace('\r\n', '\n')
        splitOffData = theData.split('MSN:')
        match = re.search('Subject: .*\n', splitOffData[0])
        subject = match.group(0).split(':')[1].strip()
        subject_list.append(subject)
        variables = splitOffData[1].split('\n')
        match2 = re.search('Box: .*\n', splitOffData[0])
        box = match2.group(0).split(':')[1].strip()
        programname = variables.pop(0).strip()
        #if there is date needed to be remove from a ID's data
        #then skip all the extraction process below
        #only extract data that we need    
        #recognize all defined variable name in MSN protocol    
        if programname == 'Extinction_LMS':
            print('Start loading extinction session')
            working_var_label.pop()
        
        for idx, var in enumerate(working_var_label, 1):
            if idx < len(working_var_label):
                start = variables.index(working_var_label[idx-1]+":")
                end = variables.index(working_var_label[idx]+":")
                data = variables[start+1:end]
            else:
                start = variables.index(working_var_label[idx-1]+":")
                data = variables[start+1:]
            temp = []
    
            for d in data:
                if d!='':
                    temp += re.split('\s+',d.split(':')[1])
                    temp.remove('')
                #convert str --> numbers
            data_dict[var.strip(':')] =  pd.to_numeric(pd.Series(temp, name = var.strip(':'),dtype = float))
        alldata_tree[programname][thisDate][subject] = data_dict
      
    sumdata = {}
    sumdata['subject'] = subject
    sumdata['training'] = programname
    sumdata['date'] = thisDate
    sumdata['FR'] = data_dict['A'][2]
    sumdata['Resp-B'] = data_dict['B'][1]
    sumdata['Resp-F'] = data_dict['B'][2]
    sumdata['Resp-Cue-B'] = data_dict['B'][6]
    sumdata['Resp-Cue-F'] = data_dict['B'][7]
    sumdata['Resp-Total'] = data_dict['B'][0]
    sumdata['Reward'] = data_dict['B'][3]
    
    summarydata = pd.DataFrame(sumdata.items()).transpose()
    summarydata.columns = summarydata.iloc[0,:]
    summarydata = summarydata.drop(summarydata.index[0])
    # summarydata.to_csv(os.path.join(filedir, subject + '_' + filedir.strip().split("/")[-1] + '.csv'))

    return summarydata
    
 
