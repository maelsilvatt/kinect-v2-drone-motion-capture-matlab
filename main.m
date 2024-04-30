%% Clear flags
imaqreset; warning('OFF'); clear all; close all; clc;

%% Setting up Kinect V2
fprintf('Configuring Kinect V2... ');
run kinect_settings.m;
fprintf('Ok\n');

%% Setting up system model
fprintf('Setting up system model...');
run model_settings.m;
fprintf('Ok\n');

%% Stablish bluetooth connection
fprintf('Stablishing Bluetooth connection...');
run ble_settings.m;
fprintf('Ok\n');