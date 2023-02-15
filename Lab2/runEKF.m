% x = f(x,u) + w; w ~N(0,Q)
% z = h(x) + v; v ~N(0,R)

clc;
clear all
close all
load('./data/Test1.mat')

% Sensor data will be average of both sensors
y = mean(data,2);



x0 = [10; 0];
R = 0.5136; % Variance of lab1 short range data
Q = [0.01 0;
    0 0.02];

T = 0.1;
A = [1 T; 
     0 1];

sim_time = 10; 
sim_time_arr = 1:T:sim_time;
N = length(sim_time_arr);

% IC's
x = zeros(2,N);
x(:,1) = x0;
P = zeros(2,2,N);
P(:,:,1) = Q;
z_hat = zeros(N);

syms d v 
F = double(jacobian([d+T*v ,v],[d,v]));

syms dist vel
% Converts distance to voltage
volts = (28.909879)*( dist + (2.844489) )^(-(1.236330)) + (0.043781);
H_jacob = jacobian(volts, [dist, vel]);
H = matlabFunction(H_jacob);

P_hat = zeros(2,2,N);
x_hat = zeros(2,N);
K = zeros(2);
w = zeros(2,N);
v = zeros(N);

true_pos = x0(1);

% Actual Motion
for i = 2:length(sim_time_arr)
    true_pos(end+1) = true_pos(end) + x0(2)*T; 
end


for n = 2:length(sim_time_arr)
    w(:,n) = [Q(1,1)*randn + 0 ; Q(2,2)*randn + 0];
    v(n) = R(1,1)*randn + 0;
     
    x_hat(:,n) = A*x(:,n-1) +  w(:,n);
    z_hat(n) = H(x(1,n))*x(:,n) + v(n);
    P_hat(:,:,n) = F*P(:,:,n-1)*F'+Q;
    K = P_hat(:,:,n)*H(x(1,n))'/( H(x(1,n))*P_hat(:,:,n)*H(x(1,n))'+R );
    
    x(:,n) = x_hat(:,n) + K*(y(n) - z_hat(n-1));
    P(:,:,n) = ( eye(2)-K*H(x(1,n)) )*P(:,:,n);   
end

% Plots
figure(1);
hold on;
plot(sim_time_arr, x(1,:));
plot(sim_time_arr, x_hat(1,:));
plot(sim_time_arr, true_pos);
legend('State Estimate', 'Prediction', '"True" Pos');
title('Predicted vs Current Distance');
hold off