%% HISTOGRAMS %%
clc;
clear all;
close all;
load('./Data Collection/SensorModel/all-sensor-model-data.mat')
load('./Data Collection/SensorModel/group-8.mat')

dists = [10, 27, 45, 62, 80];
all = [m10 m27 m45 m62 m80];
all_mean = [mean(m10) mean(m27) mean(m45) mean(m62) mean(m80)];

%std = std(all)
%var = var(all)

t = tiledlayout(3,2)

for i = 1 : 5
    nexttile
    histogram(all(:,i), 50)
    grid on;
    xline(all_mean(i), 'Color', 'r', 'LineWidth', 2);
    title("Medium-Range Data Collected at " + dists(i) + " cm")
    ylabel('Count')
    xlabel('Voltage (V)')
    legend('measurements', 'mean')
end


%legend('measurements')

%% FUNCTION STUFF %%

