%% Step 1: Load and preprocess the image
image = imread('images/marked-parrot-drone.png');
hsv_image = rgb2hsv(image);

%% Step 2: Create a color mask by filtering HSV channels
h_color = 0.1; % average hue
s_min = 0.5; % min saturation
v_min = 0.5; % min value
v_max = 1.0; % max value

color_threshold = .5;
mask = (hsv_image(:,:,1) >= (h_color - color_threshold)) & ...
          (hsv_image(:,:,1) <= (h_color + color_threshold)) & ...
          (hsv_image(:,:,2) >= s_min) & ...
          (hsv_image(:,:,3) >= v_min) & ...
          (hsv_image(:,:,3) <= v_max);

%% Step 3: Apply the color mask on the image
color_mask = bsxfun(@times, image, cast(mask, 'like', image));

%% Step 4: Binarize the filtered image
bw_threshold = 0.1;  % binarization threshold
gray_image = rgb2gray(color_mask);
bw_image = imbinarize(gray_image, bw_threshold);

%% Step 5: Remove noises
morph_disk = strel('disk', 10);             % set morphological structure
im_open = imopen(bw_image, morph_disk);  % apply oppening

%% Step 6: Get blob's centroid through Hough Transformation
c_range = [40, 400];
[centroid, radii] = imfindcircles(im_open, c_range);

imshow(image);
viscircles(centroid, radii);
