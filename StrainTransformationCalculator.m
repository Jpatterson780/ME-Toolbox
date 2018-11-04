%% Strain Transformation Calculator
% Contributors: Josh Patterson
% Code Version 1.1
% Last Updated 11/1/2018

%% Initialization

clear; close all; clc;

%% Collect Data and Establish Matrices

% User input for initial x-y Strain State
prompt = {'\epsilon_x','\epsilon_y','\gamma_xy','\theta'};
name = 'x-y Strain State';
numlines = 1;
defaultanswer = {'0.01','-0.01','0.0','45'};
options.Resize = 'on';
options.WindowStyle = 'modal';
options.Interpreter = 'tex';
userInput = inputdlg(prompt,name,numlines,defaultanswer,options);
strain = [str2double(userInput(1));str2double(userInput(2))...
    ;str2double(userInput(3))];
theta = str2double(userInput(4));
theta = deg2rad(theta);

% Set up Matrices R, A, and R^-1
R = [1,0,0;0,1,0;0,0,2];
A = [(cos(theta))^2,(sin(theta)^2),2*sin(theta)*cos(theta);...
    (sin(theta)^2),(cos(theta))^2,-2*sin(theta)*cos(theta);...
    -sin(theta)*cos(theta),sin(theta)*cos(theta),(cos(theta)^2)-(sin(theta)^2)];

%% Calculate

% Transformed Strain = R*A*(R^-1)*Strain
trStrain = R*(A/R)*strain;

% Set the value to zero if it is obnoxiously small, but still non-zero 
for i=1:3
    if abs(trStrain(i)) <= .00001
        trStrain(i) = 0;
    end
end

%% Display Results

% Display a table of desired values
results=table(trStrain(1),trStrain(2),trStrain(3),...
    'VariableNames',{'epsilonX','epsilonY','gammaXY'});
fprintf('\nTransformed Strain Results: \n\n');
disp(results);





