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
mr(x) = (1526.721939)*( x + (63.448101) )^(-(1.501067)) + (-0.750698); % Medium range sensor model

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
yyaxis left
plot(t_baseline, baseline_dist);
plot(t_baseline, actual_dist*ones(length(t_baseline),1))
title('Medium Range Sensor at 18Hz, Aluminum Block')
xlabel('Time (s)')
ylabel('Distance (cm)')
yyaxis right
error_baseline = (baseline_dist - actual_dist) .* 100 ./ actual_dist;
plot(t_baseline, error_baseline);
ylabel('%Error')
hold off


figure(2);
hold on
yyaxis left
plot(t_tilted, tilted_dist);
plot(t_tilted, actual_dist*ones(length(t_tilted),1))
title('Medium Range Sensor at 18Hz, Tilted Block')
xlabel('Time (s)')
ylabel('Distance (cm)')
yyaxis right
error_tilted = (tilted_dist - actual_dist) .* 100 ./ actual_dist;
plot(t_tilted, error_tilted);
ylabel('%Error')
hold off

figure(3);
hold on
yyaxis left
plot(t_wood, wood_dist);
plot(t_wood, actual_dist*ones(length(t_wood),1))
title('Medium Range Sensor at 18Hz, Wood Block')
xlabel('Time (s)')
ylabel('Distance (cm)')
yyaxis right
error_wood = (wood_dist - actual_dist) .* 100 ./ actual_dist;
plot(t_wood, error_wood);
ylabel('%Error')
hold off

%% Average errors
baseline_dist = sprintf('Average baseline distance was %.2f with std of %.2f', mean(baseline_dist), std(baseline_dist));
disp(baseline_dist);

baseline_err = sprintf('Average baseline error was %.2f with std of %.2f', mean(error_baseline), std(error_baseline));
disp(baseline_err);

tilted_dist = sprintf('Average tilted was %.2f with std of %.2f', mean(tilted_dist), std(tilted_dist));
disp(tilted_dist);

tilted_err = sprintf('Average tilted error was %.2f with std of %.2f', mean(error_tilted), std(error_tilted));
disp(tilted_err);

wood_dist = sprintf('Average wood was %.2f with std of %.2f', mean(wood_dist), std(wood_dist));
disp(wood_dist);

wood_err = sprintf('Average wood error was %.2f with std of %.2f', mean(error_wood), std(error_wood));
disp(wood_err);