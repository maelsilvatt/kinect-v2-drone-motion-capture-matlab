close all;

%% Load drone image
image = imread('images/marked-parrot-drone.png');

%% Convert from RGB to HSV
hsv_image = rgb2hsv(image);

%% Set the desired HSV tone (in this case, red color)
h_color = 0.1; % average hue
s_min = 0.5; % min saturation
v_min = 0.5; % min value
v_max = 1.0; % max value

%% Set the color mas
color_threshold = .5; % to get close variations
mask = (hsv_image(:,:,1) >= (h_color - color_threshold)) & ...
          (hsv_image(:,:,1) <= (h_color + color_threshold)) & ...
          (hsv_image(:,:,2) >= s_min) & ...
          (hsv_image(:,:,3) >= v_min) & ...
          (hsv_image(:,:,3) <= v_max);

%% Apply mask to drone image
color_mask = bsxfun(@times, image, cast(mask, 'like', image));

%% Binarize mask
bw_threshold = 0.1;  % binarization threshold
gray_image = rgb2gray(color_mask);
bw_image = imbinarize(gray_image, bw_threshold);

%% Remove noises
morph_disk = strel('disk', 10);             % set morphological structure
im_open = imopen(bw_image, morph_disk);  % apply oppening

%% Get disk's centroid through Hough Transformation
c_range = [40, 400];
[centroid, radii] = imfindcircles(im_open, c_range);

%% Show drone's centroid
imshow(image);
viscircles(centroid, radii);
