%% Enter information here
clc;
clear all;
close all;
% Distances tested
actual_dist = [10 15 20 25 30];
% Data 
load('./Take2/TwoSensors_10cm_18Hz.mat')
ts_10cm = data;
load('./Take2/TwoSensors_15cm_18Hz.mat')
ts_15cm = data;
load('./Take2/TwoSensors_20cm_18Hz.mat')
ts_20cm = data;
load('./Take2/TwoSensors_25cm_18Hz.mat')
ts_25cm = data;
load('./Take2/TwoSensors_30cm_18Hz.mat')
ts_30cm = data;

% Model eqns 
syms x

% Eqn that converts voltage given distance
sr(x) = exp(-x);
mr(x) = exp(-2*x);

%% Calculate mean of each sensor at different distances
short_volts = [mean(ts_10cm(:,1)) mean(ts_15cm(:,1)) mean(ts_20cm(:,1)) mean(ts_25cm(:,1)) mean(ts_30cm(:,1))];
med_volts = [mean(ts_10cm(:,2)) mean(ts_15cm(:,2)) mean(ts_20cm(:,2)) mean(ts_25cm(:,2)) mean(ts_30cm(:,2))];

%% Use model inverse to generate distance measurements

sr_inv = finverse(sr);
mr_inv = finverse(mr);

if length(short_volts) ~= length(med_volts)
    msg = 'Length of arrays not the same';
    error(msg)
end

short_dist = zeros(1, length(short_volts));
med_dist = zeros(1, length(med_volts));
ave_dist = zeros(1, length(med_volts));
for i = 1:length(short_volts)
    short_dist(i) = subs(sr_inv, x, short_volts(i));
    med_dist(i) = subs(mr_inv, x, med_volts(i));
    ave_dist(i) = short_dist(i) + med_dist(i) / 2;
end


%% Plots
% a) Comparison of two sensors

figure(1);
hold on
plot(actual_dist, short_dist);
plot(actual_dist, med_dist);
two_sens_diff = med_dist- short_dist;
plot(actual_dist, two_sens_diff)
legend('Short Range','Medium Range', 'Difference between sensors')
title('Short Range Sensor vs. Medium Range Sensor Difference')
xlabel('True Distance (cm)')
ylabel('Measured Distance (cm)')


% b) Comparison of sensor 1 and ruler distance
figure(2);
hold on
plot(actual_dist, short_dist);
short_err = short_dist - actual_dist;
plot(actual_dist, short_err)
legend('Short Range', 'Error')
title('Short Range Sensor vs. Ruler Distance Difference')
xlabel('True Distance (cm)')
ylabel('Measured Distance (cm)')

% c) Comparison of sensor 2 and ruler distance
figure(3);
hold on
plot(actual_dist, med_dist);
med_err = med_dist - actual_dist;
plot(actual_dist, med_err)
legend('Medium Range', 'Error')
title('Medium Range Sensor vs. Ruler Distance Difference')
xlabel('True Distance (cm)')
ylabel('Measured Distance (cm)')

% d) Comparison of sensor average and ruler distance
figure(4);
hold on
plot(actual_dist, ave_dist);
ave_err = ave_dist - actual_dist;
plot(actual_dist, ave_err)
legend('Average', 'Error')
title('Sensor Average vs. Ruler Distance Difference')
xlabel('True Distance (cm)')
ylabel('Measured Distance (cm)')

