%% x-y to x'-y' Stress State Calculator
% Contributors: Josh Patterson
% Code Version 1.1
% Last Updated 11/1/2018

%           **--Input values are edited in code--**
%    **--User will not be prompted in the command window--**

%% Initialization
clear; close all; clc; % Prepare the workspace
calcNumber = '9-8'; % Name the calculation  --EDIT THIS VALUE--
xyt = [100;-75;0]; % Set the initial states  --EDIT THIS VALUE--
theta = degtorad(-30); % Set the angle  --EDIT THIS VALUE--
units = 'MPa'; % Set the units  --EDIT THIS VALUE--
A = [(cos(theta))^2,(sin(theta))^2,2*sin(theta)*cos(theta);...
    (sin(theta))^2,(cos(theta))^2,-2*sin(theta)*cos(theta);...
    -sin(theta)*cos(theta),sin(theta)*cos(theta),...
    (cos(theta))^2-(sin(theta))^2]; % Establish the transformation matrix **DO NOT EDIT**


%% Calculation
xytPrime = A*xyt;
I1 = xyt(1)+xyt(2);

%% Display Results
disp(['Results for Problem ', calcNumber, ':']);
disp(['x = ', num2str(xyt(1)),' ', units]);
disp(['y = ', num2str(xyt(2)),' ', units]);
disp(['t = ', num2str(xyt(3)),' ', units]);
disp(['Theta = ', num2str(radtodeg(theta)), ' degrees']);
disp(['I1 = ',num2str(I1),' ', units]);
disp(['x'' = ', num2str(xytPrime(1)),' ', units]);
disp(['y'' = ', num2str(xytPrime(2)),' ', units]);
disp(['t'' = ', num2str(xytPrime(3)),' ', units]);