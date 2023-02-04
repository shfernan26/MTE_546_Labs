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
sr(x) = (5.224514)*( x + (-2.196009) )^(-(0.198318)) + (-2.468841); % Short range sensor model:
mr(x) = (1526.721939)*( x + (63.448101) )^(-(1.501067)) + (-0.750698); % Medium range sensor model

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
    ave_dist(i) = (short_dist(i) + med_dist(i)) ./ 2;
end


%% Plots
% a) Comparison of two sensors

figure(1);
hold on
plot(actual_dist, short_dist);
plot(actual_dist, med_dist);
two_sens_diff = med_dist - short_dist;
plot(actual_dist, two_sens_diff)
legend('Short Range','Medium Range', 'Difference between sensors')
title('Short Range Sensor vs. Medium Range Sensor Difference')
xlabel('Ruler Distance (cm)')
ylabel('Measured Distance (cm)')


% b) Comparison of sensor 1 and ruler distance
figure(2);
hold on
yyaxis left
plot(actual_dist, short_dist);
title('Short Range Sensor vs. Ruler Distance Difference')
xlabel('Ruler Distance (cm)')
ylabel('Measured Distance (cm)')
yyaxis right
short_err = (short_dist - actual_dist).*100 ./ actual_dist;
plot(actual_dist, short_err)
ylabel('% Error')

% c) Comparison of sensor 2 and ruler distance
figure(3);
hold on
yyaxis left
plot(actual_dist, med_dist);
title('Medium Range Sensor vs. Ruler Distance Difference')
xlabel('Ruler Distance (cm)')
ylabel('Measured Distance (cm)')
yyaxis right
med_err = (med_dist - actual_dist).*100 ./ actual_dist;
plot(actual_dist, med_err)
ylabel('% Error')


% d) Comparison of sensor average and ruler distance
figure(4);
hold on
yyaxis left
plot(actual_dist, ave_dist);
title('Sensor Average vs. Ruler Distance Difference')
xlabel('Ruler Distance (cm)')
ylabel('Measured Distance (cm)')
yyaxis right
ave_err = (ave_dist - actual_dist).*100 ./ actual_dist;
plot(actual_dist, ave_err)
ylabel('% Error')

%% Average error calculations
ave_short_err = sprintf('Average short range error was %.2f', mean(short_err));
disp(ave_short_err);

ave_med_err = sprintf('Average medium range error was %.2f', mean(med_err));
disp(ave_med_err);