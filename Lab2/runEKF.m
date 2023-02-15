% x = f(x,u) + w; w ~N(0,Q)
% z = h(x) + v; v ~N(0,R)

clc;
clear all
close all

rng(0,'twister'); % Sets repeatable randomness

T = 0.5; % Sample rate
sim_time = 10; 
sim_time_arr = 1:T:sim_time;
N = length(sim_time_arr);

%% Key Model Parameters
% Common short range sensor model
syms dist
volts = (28.909879)*( dist + (2.844489) )^(-(1.236330)) + (0.043781);
volt_func = matlabFunction(volts);


R = 0.5136; % Variance of Lab 1 short range data
Q = [0.01 0;
    0 0.02];
A = [1 T; 
     0 1];


% Choose source of sensor measurements in next section (comment out
% unneeded section
%% CHOICE A - SIMULATION
% Motion model plus Gaussian noise
sim_range=linspace(1,sim_time,N)';
f=@(t) 10+2*t + (Q(1,1)*randn + 0);
block_pos=feval(f,sim_range);

% Measurement model plus Gaussian noise - converts distance to voltage
y1 = feval(volt_func, block_pos) + (R(1,1)*randn + 0);
y2 = feval(volt_func, block_pos) + (R(1,1)*randn + 0);
y = (y1 + y2) / 2;

figure(1);
subplot(2,1,1);
plot(sim_time_arr, block_pos);
title('Block position');
xlabel('Time (s)');
ylabel('Distance (cm)');

subplot(2,1,2);
hold on;
plot(sim_time_arr, y1);
plot(sim_time_arr, y2);
plot(sim_time_arr, y);
legend('Sensor 1', 'Sensor 2', 'Average');
title('Sensor Average');
xlabel('Time (s)');
ylabel('Distance (cm)');
hold off


%% CHOICE B - REAL WORLD

% load('./data/Test1.mat')
% % Sensor data will be average of both sensors
% y1 = mean(data,2);
% y = downsample(y1,ceil(T/0.02857)); % Downsample by factor of target period / 35Hz i.e 0.02857s
% % If sim array is longer than real world data after downsampling, append 0s
% if N > length(y) 
%     y(numel(sim_time_arr)) = 0;
% else % If sim array is shorter, slice real world data to shorten
%     y = y(1:N);
% end

%% TRUE POSITION 

true_pos = 10;
% Actual Motion
for i = 2:N
    true_pos(end+1) = true_pos(end) + 2*T; % d2 = d1 + v*t
end

%% EKF 


x0 = [10; 2]; % Initial state

% IC's
x = zeros(2,N);
x(:,1) = x0;
P = zeros(2,2,N);
P(:,:,1) = Q;
z_hat = zeros(N);

syms dist vel
% Jacobian for measurement model
H_jacob = jacobian(volts, [dist, vel]);
H = matlabFunction(H_jacob);

P_hat = zeros(2,2,N);
x_hat = zeros(2,N);
K = zeros(2);
w = zeros(2,N);
v = zeros(1,N);

for n = 2:N
    w(:,n) = [Q(1,1)*randn + 0 ; Q(2,2)*randn + 0];
    v(n) = R(1,1)*randn + 0;
     
    x_hat(:,n) = A*x(:,n-1) + w(:,n);
    z_hat(n) = H(x(1,n))*x(:,n) + v(n);
    P_hat(:,:,n) = A*P(:,:,n-1)*A'+Q;
    K = P_hat(:,:,n)*H(x(1,n))'/( H(x(1,n))*P_hat(:,:,n)*H(x(1,n))'+R );
    
    x(:,n) = x_hat(:,n) + K*(y(n) - z_hat(n-1));
    P(:,:,n) = ( eye(2)-K*H(x(1,n)) )*P(:,:,n);   
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

