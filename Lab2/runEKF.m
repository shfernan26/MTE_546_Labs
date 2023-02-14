% x = f(x,u) + w; w ~N(0,Q)
% z = h(x) + v; v ~N(0,R)

clc;
clear all
close all

rng(0,'twister');
std = 5;
mean = 500;
y = std.*randn(2,1) + mean;



x0 = [10; 2];
R = 0.5136; % Variance of lab1 short range data
Q = [0.01 0;
    0 0.02];

T = 0.1;
A = [1 T; 
     0 1];

sim_time = 5; 
sim_time_arr = 1:T:sim_time;


% IC's
x = x0;
P = Q;
z = 0;

syms d v 
F = double(jacobian([d+T*v ,v],[d,v]));

syms dist vel
% Converts distance to voltage
volts = (28.909879)*( dist + (2.844489) )^(-(1.236330)) + (0.043781);
H_jacob = jacobian(volts, [dist, vel]);
H = matlabFunction(H_jacob);

x_pred = x0;
P_pred = Q;
K_arr = [0; 0];
w = [0; 0];

true_pos = x0(1);

% Actual Motion
for i = 2:length(sim_time_arr)
    true_pos(end+1) = true_pos(end) + x0(2)*T; 
end


for n = 2:length(sim_time_arr)
    w(:,n) = [Q(1,1)*randn + 0 ; Q(2,2)*randn + 0];
    v(:,n) = [R*randn + 0];
     
    x(:,n) = A*x(:,n-1) +  w(:,n); 
    z(n) = H(x(1,n))*x(:,n) + v(:,n);
    P(:,:,n) = F*P(:,:,n-1)*F'+Q;
    K = P(:,:,n)*H(x(1,n))'*( ( H(x(1,n))*P(:,:,n)*H(x(1,n))'+R )^-1 );
    
    K_arr(:, end+1) = K;
    x_pred(:,end+1) = x(:,n) + K*(z(n) - z(n-1));
    P_pred(:,:,end+1) = ( eye(2)-K*H(x(1,n)) )*P(:,:,n);   
end

% Plots
figure(1);
hold on;
plot(x(1,:));
plot(x_pred(1,:));
plot(true_pos);
legend('State Estimate', 'Prediction', 'True Pos');
title('Predicted vs Current Distance');
hold off


