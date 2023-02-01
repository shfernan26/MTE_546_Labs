%% Enter information here
clc;
clear all;
close all;
% Distances tested
actual_dist = 27; %cm
% Data 
load('./Data Collection/SensorModel/SensorModel_MedRange_27cm.mat')
med_18Hz = data;
t_18Hz = time;

load('./Take2/Med_27cm_180Hz.mat')
med_180Hz = data;
t_180Hz = time;

% Model eqns 
syms x

% Eqn that converts voltage given distance
mr(x) = exp(-2*x);

%% Use model inverse to generate distance measurements

mr_inv = finverse(mr);

inv_18 = zeros(length(med_18Hz),1);
for i = 1:length(inv_18)
    inv_18(i) = subs(mr_inv, x, med_18Hz(i));

end

inv_180 = zeros(length(med_180Hz),1);
for i = 1:length(inv_180)
    inv_180(i) = subs(mr_inv, x, med_180Hz(i));

end

%% Plots

figure(1);
hold on
plot(t_18Hz, inv_18);
error_18Hz = inv_18 - actual_dist;
plot(t_18Hz, error_18Hz);
hold off
legend('Sensor Reading','Error')
title('Medium Range Sensor at 18Hz')
xlabel('Time (s)')
ylabel('Measured Distance (cm)')

figure(2);
hold on
plot(t_180Hz, inv_180);
error_180Hz = inv_180 - actual_dist;
plot(t_180Hz, error_180Hz);
hold off
legend('Sensor Reading','Error')
title('Medium Range Sensor at 180Hz')
xlabel('Time (s)')
ylabel('Measured Distance (cm)')
