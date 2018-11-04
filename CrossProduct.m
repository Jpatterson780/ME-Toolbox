%% Cross Product Calculator
% Contributors: Josh Patterson
% Code Version 1.0
% Last Updated 10/25/2018

%% Initialization

clear; close all; clc;
fprintf('\n     Cross Product Calculator for C = A x B\n');
fprintf('     where:    A = <A1,A2,A3>    and    B = <B1,B2,B3>\n\n');

%% Collect Data

% User input for vectors a and b
prompt = {'A1','A2','A3','B1','B2','B3'};
name = 'Vector Input';
numlines = 1;
defaultanswer = {'1','1','1','1','1','1'};
options.Resize = 'on';
options.WindowStyle = 'modal';
options.Interpreter = 'tex';
userInput = inputdlg(prompt,name,numlines,defaultanswer,options);

% Organize into seperate vectors and change variable type
vecA = [userInput(1);userInput(2);userInput(3)];
vecB = [userInput(4);userInput(5);userInput(6)];
vecA = str2double(vecA);
vecB = str2double(vecB);

%% Calculate and Display

% Pre-Allocate the resulting vector
vecC = [0;0;0];

% Calculate
vecC(1) = vecA(2)*vecB(3) - vecA(3)*vecB(2);
vecC(2) = vecA(3)*vecB(1) - vecA(1)*vecB(3);
vecC(3) = vecA(1)*vecB(2) - vecA(2)*vecB(1);
magC = sqrt((vecC(1))^2 + (vecC(2))^2 + (vecC(3))^2);

% Display
disp(['     The Resulting Vector, C = <',num2str(vecC(1)),','...
    ,num2str(vecC(2)),',',num2str(vecC(3)),'>']);
disp(['     And The Magnitude, |C| = ', num2str(magC)]);








