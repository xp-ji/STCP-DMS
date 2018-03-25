clear all; close all; clc;

% read the information & setup parameters
[info, param] = setParam('MSRAction3D');

% get the train & test datapath
info = getDataTables(info);

% get the depth projection
ctime = compDescripter(info, param);

% training and testing
trainAndTest(info, param);

% % draw the confusion matrix
% DrawCM(info);

diary off;
