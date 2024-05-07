function [centroid, radii] = blob_detection(image, c_range)
    [bw_image, ~] = create_mask(image);

    % Remove noises
    morph_disk = strel('disk', 5);          % set morphological structure
    im_open = imopen(bw_image, morph_disk);  % apply opening

    % Step 6: Get blob's centroid through Hough Transformation
    [centroid, radii] = imfindcircles(im_open, c_range);
end
