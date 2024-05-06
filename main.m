%% Clear flags
imaqreset; warning('OFF'); clear all; close all; clc;

%% Setting up Kinect V2
fprintf('Configuring Kinect V2...');
ColorVid = videoinput('kinect', 1, 'BGR_1920x1080');
depthVid = videoinput('kinect', 2, 'Depth_512x424');
triggerconfig([ColorVid depthVid], 'manual');
start([ColorVid depthVid]);
fprintf('Ok\n');

%% Stablish bluetooth connection
fprintf('Stablishing Bluetooth connection...');
blt = ble('RS_W215913');
fprintf('Ok\n');

%% Detect drone
for j =1:10
    pause(0.3) 
    imgColor_i = getsnapshot(ColorVid);
    pause(0.3)
    imgDepth_i = getsnapshot(depthVid);
end