clc;
clear all;
close all;
load('../Lab1/Data Collection/SensorModel/all-sensor-model-data.mat')

all_short = cat(1, s4, s10, s20, s25, s30);
var_short = var(all_short);
