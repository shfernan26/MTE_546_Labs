% Set up workspace for use with simulation
clc;
clear all;
close all;

T = 0.2;

% R = [0.5136; 0; 0]; 
R = 0.05;
% Q = [0.1 0 0;
%     0 0.2 0;
%     0 0 0.3];
Q = [0.1 0;
    0 0.2];

SR_Lookup_Voltage = [0 2.2 2.7 2 1.6 1.3 1.15 0.9 0.8 0.75 0.65 0.5 0.45 0.35 0.3]; 
SR_Lookup_Distance = [0 2 4 6 8 10 12 14 16 18 20 25 30 35 40]; 

% Motion_Profiles
dist = timeseries([10; 12; 14; 16; 18; 20]); 
vel = timeseries([2; 2; 2; 2; 2]);
accel = timeseries([0; 0; 0; 0; 0]);


