%% Settings
warning('off');

%% Setting up Kinect V2
% fprintf('Configuring Kinect V2...');
% ColorVid = videoinput('kinect', 1, 'BGR_1920x1080');
% depthVid = videoinput('kinect', 2, 'Depth_512x424');
% triggerconfig([ColorVid depthVid], 'manual');
% start([ColorVid depthVid]);
% fprintf('Ok\n');

%% Stablish bluetooth connection
% fprintf('Stablishing Bluetooth connection...');
% blt = ble('RS_W215913');
% fprintf('Ok\n');

%% Detect drone
% Load video from files
vid = VideoReader('images\parrot-drone-video.mp4');

% Create an object to save output video
delete('output\output_video.mp4');
videoOut = VideoWriter('output\output_video.mp4', 'MPEG-4');
open(videoOut);

% Set a frame counter
frame_count = 0;

% Sets Hough Transform range
c_range = [1, 700];

while hasFrame(vid)
    % Increment frame counter
    frame_count = frame_count + 1;

    fprintf('Processing frame %d of %d (%d%%)\n', frame_count, vid.NumFrames, floor((frame_count/vid.NumFrames)*100));
    
    % Get video frame
    frame = readFrame(vid);
    
    % Obtains blobs centroid
    [centroid, radii] = blob_detection(frame, c_range);

    % Detects if the object is ocluded or not
    if size(centroid) > 0
        centroid_info = sprintf('Centroid: (%.2f, %.2f)', centroid(1), centroid(2));
    else
        centroid_info = sprintf('Centroid: N/A');
    end

    % Inserts a circle where the blob was detected
    [max_radius, max_index] = max(radii); % highest radii index
    biggest_centroid = centroid(max_index, :); % highest radii coords
    frame = insertShape(frame, 'filled-circle', [biggest_centroid, max_radius], 'Color', 'red');

    % Inserts a text showing detected blob centroid
    frame = insertText(frame, [1, 50], centroid_info, FontSize=36, FontColor="white", TextBoxColor="black");

    % Inserts current frame counter on frame
    frame = insertText(frame, [1, 1], frame_count, FontSize=24);

    % Write frame into output video
    writeVideo(videoOut, frame);
end

% Closes ouput video object
close(videoOut);

% Cleans input video handler
delete(vid);

fprintf('Done!\n');
