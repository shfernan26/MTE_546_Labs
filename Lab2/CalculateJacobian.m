%% Enter information here
clc;
clear all;
close all;
% Model eqns 
syms x v a 
% Eqn that converts voltage given distance
sr(x) = (5.224514)*( x + (-2.196009) )^(-(0.198318)) + (-2.468841); % Short range sensor model
% Use model inverse to generate distance measurements
sr_inv = finverse(sr);

lin_model = jacobian([sr_inv, 0, 0], [x, v, a]);
disp(lin_model)