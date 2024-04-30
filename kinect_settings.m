%% RGB Sensor parameters
fx = 570.2264673913043; % Focal Length in X
fy = 536.4408307453416; % Focal Length in Y
H = 3.3240;

%% Setting up sensor
ColorVid = videoinput('kinect',1,'BGR_1920x1080');
depthVid = videoinput('kinect',2,'Depth_512x424');
triggerconfig([ColorVid depthVid],'manual');
pause(0.5)

start([ColorVid depthVid]);
pause(0.5)

%% Init loop
for j =1:10
    pause(0.3)
    imgColor_i = getsnapshot(ColorVid);
    pause(0.3)
    imgDepth_i = getsnapshot(depthVid);
end