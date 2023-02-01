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
mr(x) = (1526.721939)*( x + (63.448101) )^(-(1.501067)) + (-0.750698); % Medium range sensor model

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
yyaxis left
plot(t_18Hz, inv_18);
plot(t_18Hz, actual_dist*ones(length(t_18Hz),1))
title('Medium Range Sensor at 18Hz, 27cm')
xlabel('Time (s)')
ylabel('Measured Distance (cm)')
yyaxis right
error_18Hz = (inv_18 - actual_dist) .*100 ./ actual_dist;
plot(t_18Hz, error_18Hz);
ylabel('%Error')
hold off

figure(2);
hold on
yyaxis left
plot(t_180Hz, inv_180);
plot(t_18Hz, actual_dist*ones(length(t_18Hz),1))
title('Medium Range Sensor at 180Hz')
xlabel('Time (s)')
ylabel('Measured Distance (cm)')
yyaxis right
error_180Hz = (inv_180 - actual_dist) .*100 ./ actual_dist;
plot(t_180Hz, error_180Hz);
ylabel('%Error')
hold off

%% Average errors
ave_18_dist = sprintf('Average 18Hz was %.2f with std of %.2f', mean(inv_18), std(inv_18));
disp(ave_18_dist);

ave_18_err = sprintf('Average 18Hz error was %.2f with std of %.2f', mean(error_18Hz), std(error_18Hz));
disp(ave_18_err);

ave_180_dist = sprintf('Average 180Hz was %.2f with std of %.2f', mean(inv_180), std(inv_180));
disp(ave_180_dist);

ave_180_err = sprintf('Average 180Hz error was %.2f', mean(error_180Hz), std(error_180Hz));
disp(ave_180_err);