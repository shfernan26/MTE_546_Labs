%% Enter information here
clc;
clear all;
close all;
% Distances tested
actual_dist = 27; %cm

% Data 
load('./Data Collection/SensorModel/SensorModel_MedRange_27cm.mat')
baseline = data; % Baseline is aluminum block, 18Hz at 27cm
t_baseline = time;
load('./Take2/Tilted_Med_27cm_18Hz.mat')
tilted = data;
t_tilted = time;
load('./Take2/Wood_Med_27cm_18Hz.mat')
wood = data;
t_wood = time;

% Model eqns 
syms x

% Eqn that converts voltage given distance
mr(x) = exp(-2*x);

%% Use model inverse to generate distance measurements

mr_inv = finverse(mr);

if (length(baseline) ~= length(tilted)) || (length(baseline) ~= length(wood))
    msg = 'Length of arrays not the same';
    error(msg)
end

baseline_dist = zeros(length(baseline),1);
for i = 1:length(baseline_dist)
    baseline_dist(i) = subs(mr_inv, x, baseline(i));
end

tilted_dist = zeros(length(tilted),1);
for i = 1:length(tilted_dist)
    tilted_dist(i) = subs(mr_inv, x, tilted(i));
end

wood_dist = zeros(length(wood),1);
for i = 1:length(wood_dist)
    wood_dist(i) = subs(mr_inv, x, wood(i));
end

%% Plots

figure(1);
hold on
plot(t_baseline, baseline_dist);
error_baseline = baseline_dist - actual_dist;
plot(t_baseline, error_baseline);
hold off
legend('Baseline Conditions','Error')
title('Medium Range Sensor at 18Hz, Aluminum Block')
xlabel('Time (s)')
ylabel('Distance (cm)')

figure(2);
hold on
plot(t_tilted, tilted_dist);
error_tilted = tilted_dist - actual_dist;
plot(t_tilted, error_tilted);
hold off
legend('Tilted Block','Error')
title('Medium Range Sensor at 18Hz, Tilted Block')
xlabel('Time (s)')
ylabel('Distance (cm)')

figure(3);
hold on
plot(t_wood, wood_dist);
error_wood = wood_dist - actual_dist;
plot(t_wood, error_wood);
hold off
legend('Wood Block','Error')
title('Medium Range Sensor at 18Hz, Wood Block')
xlabel('Time (s)')
ylabel('Distance (cm)')
