%% SENSOR MODEL %%
clc;
clear all;
load('./Data Collection/SensorModel/SensorModel_MedRange_10cm.mat')
med_10 = [time data];
load('./Data Collection/SensorModel/SensorModel_MedRange_27cm.mat')
med_27 = [time data];
load('./Data Collection/SensorModel/SensorModel_MedRange_45cm.mat')
med_45 = [time data];
load('./Data Collection/SensorModel/SensorModel_MedRange_62cm.mat')
med_62 = [time data];
load('./Data Collection/SensorModel/SensorModel_MedRange_80cm.mat')
med_80 = [time data];

mean_med = cat(1, med_10(:,2), med_27(:,2), med_45(:,2), med_62(:,2), med_80(:,2));
disp(mean(mean_med))