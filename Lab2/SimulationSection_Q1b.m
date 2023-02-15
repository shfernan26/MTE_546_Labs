clc;
clear all
close all


%% Lab 1 Results

% Distances tested
Lab1_range = [10 15 20 25 30];
% Data 
load('../Lab1/Take2/TwoSensors_10cm_18Hz.mat')
ts_10cm = data;
load('../Lab1/Take2/TwoSensors_15cm_18Hz.mat')
ts_15cm = data;
load('../Lab1/Take2/TwoSensors_20cm_18Hz.mat')
ts_20cm = data;
load('../Lab1/Take2/TwoSensors_25cm_18Hz.mat')
ts_25cm = data;
load('../Lab1/Take2/TwoSensors_30cm_18Hz.mat')
ts_30cm = data;

% Calculate mean of each sensor at different distances
short_volts = [mean(ts_10cm(:,1)) mean(ts_15cm(:,1)) mean(ts_20cm(:,1)) mean(ts_25cm(:,1)) mean(ts_30cm(:,1))];


%% New Sensor Model

syms dist vel
volts = (28.909879)*( dist + (2.844489) )^(-(1.236330)) + (0.043781);

%% Sensor Data Lookup Table

SR_Lookup_Voltage = [0 2.2 2.7 2 1.6 1.3 1.15 0.9 0.8 0.75 0.65 0.5 0.45 0.35 0.3]; 
SR_Lookup_Distance = [0 2 4 6 8 10 12 14 16 18 20 25 30 35 40]; 

%%
figure(1);
hold on
plot(Lab1_range, short_volts);
fplot(volts, [0 30]);

plot(SR_Lookup_Distance, SR_Lookup_Voltage)
legend('Lab 1 Results','Proposed Sensor Model', 'Datasheet Values')
title('Lab 1 Results vs. Sensor Model vs. Datasheet')
xlabel('Ruler Distance (cm)')
ylabel('Voltage (V)')




