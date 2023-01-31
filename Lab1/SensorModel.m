%% SENSOR MODEL %%
clc;
clear all;
close all;
load('./Data Collection/SensorModel/all-sensor-model-data.mat')

% Means
all_short = cat(1, s4, s10, s20, s25, s30);
each_short_mean = [mean(s4) mean(s10) mean(s20) mean(s25) mean(s30)];

all_med = cat(1, m10, m27, m45, m62, m80);
each_med_mean = [mean(m10) mean(m27) mean(m45) mean(m62) mean(m80)];

all_long = cat(1, l20,l52, l85, l117, l150);
each_long_mean = [mean(l20) mean(l52) mean(l85) mean(l117) mean(l150)];

% Plots
figure(1)
short_dist = [4 10 20 25 30];
hold on
scatter(short_dist, each_short_mean);
p = polyfit(short_dist, each_short_mean, 3);
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
p = polyfit(med_dist, each_med_mean, 3);
plot(med_dist, polyval(p, med_dist))
hold off
legend('Collected Data','Fitted Function')
title('Medium Range Distance Means')
xlabel('Distance (cm)')
ylabel('Voltage (V)')
med_eqn = sprintf('y = (%.6f) x^2 + (%.6f) x + (%.6f)',p(1),p(2),p(3));
disp(med_eqn)

figure(3)
long_dist = [20 52 85 117 150];
hold on
scatter(long_dist, each_long_mean);
p = polyfit(long_dist, each_long_mean, 3);
plot(long_dist, polyval(p, long_dist))
hold off
legend('Collected Data','Fitted Function')
title('Long Range Distance Means')
xlabel('Distance (cm)')
ylabel('Voltage (V)')
long_eqn = sprintf('y = (%.6f) x^2 + (%.6f) x + (%.6f)',p(1),p(2),p(3));
disp(long_eqn)
