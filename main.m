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

% Sets Hough Transform range
c_range = [1, 700];

% Initialize frame variables
frame_count = 0;
fps = 0;
start_time = tic;
last_frame_time = 0;
ms_between_frames = 0;

while hasFrame(vid)
    % Increment frame counter
    frame_count = frame_count + 1;

    fprintf('Processing frame %d of %d (%d%%)\n', frame_count, vid.NumFrames, floor((frame_count/vid.NumFrames)*100));
    
    % Get video frame
    frame = readFrame(vid);
    
    % Obtains masked image centers
    [centers, radii] = blob_detection(frame, c_range);

    % Detects if the object is ocluded or not
    if size(centers) > 0
        % Filters the largest centroid ignoring noised detections
        [max_radius, max_index] = max(radii);    % highest radii index
        filtered_center = centers(max_index, :); % largest center index

        % Sets origin to the frame center instead of up left
        [frame_y, frame_x, ~] = size(frame);
        x = filtered_center(1) - frame_x/2;
        y = frame_y/2 - filtered_center(2);

        centers_info = sprintf('center: (%.2f, %.2f)', x, y);

        % Inserts a circle where the blob was detected
        frame = insertShape(frame, 'filled-circle', [filtered_center, max_radius], 'Color', 'red');
    else
        centers_info = sprintf('center: N/A');
    end

    % Inserts a text showing detected blob centers
    frame = insertText(frame, [1, 50], centers_info, FontSize=36, FontColor="white", TextBoxColor="black");

    % Inserts current frame counter on frame
    frame = insertText(frame, [1, 1], frame_count, FontSize=24);
    
    % Computes FPS and ms between each 10 frames
    if mod(frame_count, 10) == 0
        elapsed_time = toc;

        fps = frame_count / elapsed_time;
        ms_between_frames = (elapsed_time - last_frame_time) * 1000; % Elapsed time between frames in milliseconds
        last_frame_time = elapsed_time;

        tic;
    end

    % Inserts FPS on frame
    frame = insertText(frame, [size(frame, 2) - 100, 20], sprintf('FPS: %.2f', fps), 'FontSize', 12, 'TextColor', 'white', 'BoxColor', 'black', 'BoxOpacity', 0.5);

    % Inserts ms between frames on frame
    frame = insertText(frame, [size(frame, 2) - 100, 50], sprintf('ms: %.2f', ms_between_frames), 'FontSize', 12, 'TextColor', 'white', 'BoxColor', 'black', 'BoxOpacity', 0.5);

    % Write frame into output video
    writeVideo(videoOut, frame);
end

% Closes ouput video object
close(videoOut);

% Cleans input video handler
delete(vid);

fprintf('Done!\n');
