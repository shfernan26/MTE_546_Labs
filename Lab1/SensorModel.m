%% SENSOR MODEL %%
clc;
clear all;
close all;
load('./Data Collection/SensorModel/all-sensor-model-data.mat')
load('./Data Collection/SensorModel/group-8.mat')

% Means
all_short = cat(1, s4, s10, s20, s25, s30);
each_short_mean = [mean(s4) mean(s10) mean(s20) mean(s25) mean(s30)];

all_med = cat(1, m10, m27, m45, m62, m80);
each_med_mean = [mean(m10) mean(m27) mean(m45) mean(m62) mean(m80)];

all_long = cat(1, l20group8,l40group8, l80group8, l120group8, l150group8);
each_long_mean = [mean(l20group8) mean(l40group8) mean(l80group8) mean(l120group8) mean(l150group8)];

% Plots
figure(1)
short_dist = [4 10 20 25 30];
hold on
scatter(short_dist, each_short_mean);
p = polyfit(short_dist, each_short_mean, 2);
plot(short_dist, polyval(p, short_dist))
hold off
legend('Collected Data','Fitted Function')
title('Short Range Distance Means')
xlabel('Distance (cm)')
ylabel('Voltage (V)')
short_eqn = sprintf('y = (%.6f) x^2 + (%.6f) x + (%.6f)',p(1),p(2),p(3));
disp(short_eqn)

figure(2)
med_dist = [10 27 45 62 80];
hold on
scatter(med_dist, each_med_mean);
x0 = [112703 97 2 0]; 
rational = fittype( @(a,b,c,d,x) (a*(x + b).^(-c))+d );
[fitted_curve,gof] = fit(med_dist',each_med_mean',rational,'StartPoint',x0);
p = coeffvalues(fitted_curve);
plot(med_dist, fitted_curve(med_dist))
hold off
legend('Collected Data','Fitted Function')
title('Medium Range Distance Means')
xlabel('Distance (cm)')
ylabel('Voltage (V)')
med_eqn = sprintf('y = (%.6f)*( x + (%.6f) )^(-(%.6f)) + (%.6f)',p(1),p(2),p(3),p(4));
disp(med_eqn)

figure(3)
long_dist = [20 40 80 120 150];
hold on
scatter(long_dist, each_long_mean);
x0 = [1 1 1 1]; 
rational = fittype( @(a,b,c,d,x) (a*(x + b).^(-c))+d );
[fitted_curve,gof] = fit(long_dist',each_long_mean',rational,'StartPoint',x0);
p = coeffvalues(fitted_curve);
plot(long_dist, fitted_curve(long_dist))
hold off
legend('Collected Data','Fitted Function')
title('Long Range Distance Means')
xlabel('Distance (cm)')
ylabel('Voltage (V)')
long_eqn = sprintf('y = (%.6f)*( x + (%.6f) )^(-(%.6f)) + (%.6f)',p(1),p(2),p(3),p(4));
disp(long_eqn)
