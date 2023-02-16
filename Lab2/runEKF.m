% x = f(x,u) + w; w ~N(0,Q)
% z = h(x) + v; v ~N(0,R)

clc;
clear all
close all

rng(0,'twister'); % Sets repeatable randomness

T = 0.05; % Sample period
sim_time = 10; % Simulation duration
sim_time_arr = 0:T:sim_time;
N = length(sim_time_arr);

mode = 'simulation'; % 'simulation' or 'real'

%% Key Model Parameters
% Common short range sensor model
syms dist
volts = (28.909879)*( dist + (2.844489) )^(-(1.236330)) + (0.043781);
volt_func = matlabFunction(volts);


R = 0.5136; % Measurement error covariance (Lab 1 data variance)
Q = [0.1 0; % Process noise covariance
    0 0.2];
A = [1 T; 
     0 1];


% Choose source of sensor measurements in next section (comment out
% unneeded section
%% CHOICE A - SIMULATION
if strcmp(mode, 'simulation')
    % Motion model plus Gaussian noise
    sim_range=linspace(1,sim_time,N)';
    f=@(t) 10+0*t + (Q(1,1)*randn + 0);
    block_pos=feval(f,sim_range);
    
    % Measurement model plus Gaussian noise - converts distance to voltage
    y1 = feval(volt_func, block_pos) + (R(1,1)*randn + 0);
    y2 = feval(volt_func, block_pos) + (R(1,1)*randn + 0);
    y = (y1 + y2) / 2;
    
    figure(1);
    subplot(2,1,1);
    plot(sim_time_arr, block_pos);
    title('Simulated Block position');
    xlabel('Time (s)');
    ylabel('Distance (cm)');
    
    subplot(2,1,2);
    hold on;
    plot(sim_time_arr, y1);
    plot(sim_time_arr, y2);
    plot(sim_time_arr, y);
    legend('Sensor 1', 'Sensor 2', 'Average');
    title('Simulated Sensor Models');
    xlabel('Time (s)');
    ylabel('Voltage (cm)');
    hold off

end



%% CHOICE B - REAL WORLD
if strcmp(mode, 'real')
    load('./data/Test1.mat')
    % Sensor data will be average of both sensors
    y1 = mean(data,2);
    y = downsample(y1,ceil(T/0.02857)); % Downsample by factor of target period / 35Hz i.e 0.02857s
    % If sim array is longer than real world data after downsampling, append 0s
    if N > length(y) 
        y(numel(sim_time_arr)) = 0;
    else % If sim array is shorter, slice real world data to shorten
        y = y(1:N);
    end
    
    figure(1);
    plot(sim_time_arr, y);
    title('Real World Sensor Data');
    xlabel('Time (s)');
    ylabel('Voltage (V)');
end

%% EKF 

x0 = [10; 2]; % Initial state estimate

% IC's
x = zeros(2,N);
x(:,1) = x0;
P = zeros(2,2,N);
P(:,:,1) = Q;
z_hat = zeros(1,N);

syms dist vel
% Jacobian for measurement model
H_jacob = jacobian(volts, [dist, vel]);
H = matlabFunction(H_jacob);

P_hat = zeros(2,2,N);
x_hat = zeros(2,N);
x_hat(:,1) = x0;
K = zeros(2);
K_arr = zeros(2,N);
w = zeros(2,N);
v = zeros(1,N);

for n = 2:N
    w(:,n) = [Q(1,1)*randn + 0 ; Q(2,2)*randn + 0];
    v(n) = R(1,1)*randn + 0;
     
    x_hat(:,n) = A*x(:,n-1) + w(:,n);
    z_hat(n) = feval(volt_func, x_hat(1,n)) + v(n);
    P_hat(:,:,n) = A*P(:,:,n-1)*A'+ Q;
    K = P_hat(:,:,n)*H(x(1,n))'/( H(x(1,n))*P_hat(:,:,n)*H(x(1,n))'+R );
    K_arr(:,n) = K;

    x(:,n) = x_hat(:,n) + K*(y(n) - z_hat(n));
    P(:,:,n) = ( eye(2)-K*H(x(1,n)) )*P_hat(:,:,n); 

end

%% TRUE POSITION - SIMULATION

true_pos = 10;
% Actual Motion
for i = 2:N
    true_pos(end+1) = true_pos(end) + 0*T; % d2 = d1 + v*t
end

%% Plots

figure(2);
hold on;
plot(sim_time_arr, x(1,:));
plot(sim_time_arr, x_hat(1,:));
plot(sim_time_arr, true_pos);
legend('State Estimate', 'Prediction', '"True" Pos', 'Sensor Measurement');
title('Measured/Predicted Distance vs. Time');
xlabel('Time (s)');
ylabel('Distance (cm)');
hold off

% For simulation only
figure(3);
hold on;
per_error = (x_hat(1,:) - true_pos) .*100 ./ true_pos;
scatter(sim_time_arr, per_error);
title('% Error Over Test Run');
xlabel('Time (s)');
ylabel('Error (%)');


% For Kalman Gain
figure(4);
hold on;
plot(sim_time_arr, K_arr(1,:));
plot(sim_time_arr, K_arr(2,:));
legend('dist gain', 'vel gain')
title('Kalman Gain');
xlabel('Time (s)');
ylabel('Gain');