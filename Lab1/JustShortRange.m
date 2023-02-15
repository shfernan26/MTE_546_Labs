%% SENSOR MODEL %%
clc;
clear all;
close all;
load('./Data Collection/SensorModel/all-sensor-model-data.mat')
load('./Data Collection/SensorModel/group-8.mat')

% Means
all_short = cat(1, s4, s10, s20, s25, s30);
each_short_mean = [mean(s4) mean(s10) mean(s20) mean(s25) mean(s30)]

% Plots
figure(1)
short_dist = [4 10 20 25 30];
short_dist = short_dist + 3.3;
hold on
scatter(short_dist, each_short_mean);
x0 = [50 6.4 1.3 -0.2]; 
rational = fittype( @(a,b,c,d,x) (a*(x + b).^(-c))+d );
[fitted_curve,gof] = fit(short_dist',each_short_mean',rational,'StartPoint',x0)
y = fitted_curve(short_dist);
error = abs(each_short_mean - y');
max_error_short = max(error)
avg_error_short = mean(error)
p = coeffvalues(fitted_curve);
plot(short_dist, fitted_curve(short_dist))
hold off
legend('Collected Data','Fitted Function')
title('Short Range Distance Means')
xlabel('Distance (cm)')
ylabel('Voltage (V)')
short_eqn = sprintf('y = (%.6f)*( x + (%.6f) )^(-(%.6f)) + (%.6f)',p(1),p(2),p(3),p(4));
disp(short_eqn)
fitted_curve(9)

figure(2)
SR_Lookup_Voltage = [2.72 2.01 1.57 1.26 1.05 0.92 0.8 0.75 0.67 0.52 0.41]; 
SR_Lookup_Distance = [  4    6    8   10   12   14  16   18   20   25 30];
hold on
x0 = [50 6.4 1.3 -0.2]; 
rational = fittype( @(a,b,c,d,x) (a*(x + b).^(-c))+d );
[fitted_curve,gof] = fit(SR_Lookup_Distance',SR_Lookup_Voltage',rational,'StartPoint',x0)
y = fitted_curve(SR_Lookup_Distance);
error = abs(SR_Lookup_Voltage - y');
p = coeffvalues(fitted_curve);
plot(SR_Lookup_Distance, fitted_curve(SR_Lookup_Distance))
hold off
legend('Collected Data','Fitted Function')
title('Short Range Data Sheet Fit')
xlabel('Distance (cm)')
ylabel('Voltage (V)')
better_short_eqn = sprintf('y = (%.6f)*( x + (%.6f) )^(-(%.6f)) + (%.6f)',p(1),p(2),p(3),p(4));
disp(better_short_eqn)
fitted_curve(9)