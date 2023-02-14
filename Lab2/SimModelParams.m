% Set up workspace for use with simulation
clc;
clear all;
close all;


T = 0.5;
A = [1 T; 
     0 1];
 
x0 = [10; 2];

R = 0.5136; % Variance of lab1 short range data
Q = [0.01 0;
    0 0.02];




