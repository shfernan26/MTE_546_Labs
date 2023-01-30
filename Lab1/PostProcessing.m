%% SENSOR MODEL %%
clc;
clear all;
load('./Data Collection/SensorModel/SensorModel_MedRange_10cm.mat')

% mean_med = cat(1, med_10(:,2), med_27(:,2), med_45(:,2), med_62(:,2), med_80(:,2));
mean_med = cat(1, m10, m27, m45, m62, m80);
disp(mean(mean_med))