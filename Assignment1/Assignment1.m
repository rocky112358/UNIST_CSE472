%% Task 1

image = imread("data/mosaic/crayons_mosaic.bmp");

red_mask = cast(repmat([1 0;0 0], [240 300]), 'uint8');
green_mask = cast(repmat([0 1;1 0], [240 300]), 'uint8');
blue_mask = cast(repmat([0 0;0 1], [240 300]), 'uint8');

red_channel = image .* red_mask;
green_channel = image .* green_mask;
blue_channel = image .* blue_mask;
figure(1)
subplot(1, 3, 1)
imshow(red_channel)
title("Red channel")
subplot(1, 3, 2)
imshow(green_channel)
title("Green channel")
subplot(1, 3, 3)
imshow(blue_channel)
title("Blue channel")

%% Task 2
red_filter = [1/4 1/2 1/4; 1/2 1 1/2; 1/4 1/2 1/4];
green_filter = [0 1/4 0; 1/4 1 1/4; 0 1/4 0];
blue_filter = red_filter;

red = imfilter(red_channel, red_filter);
green = imfilter(green_channel, green_filter);
blue = imfilter(blue_channel, blue_filter);

recovered_image = cat(3, red, green, blue);
figure(2)
subplot(1, 3, 1)
imshow(recovered_image)
title("Recovered image")

original_image = imread("data/mosaic/crayons.jpg");
subplot(1, 3, 2)
imshow(original_image)
title("Original image")

error = original_image - recovered_image;
error_per_pixel = abs(original_image(:,:,1)-recovered_image(:,:,1))+...
    abs(original_image(:,:,2)-recovered_image(:,:,2))+...
    abs(original_image(:,:,3)-recovered_image(:,:,3));
mean_error = mean(error_per_pixel, 'all')
max_error = max(error_per_pixel, [], 'all')
subplot(1, 3, 3)
imshow(error_per_pixel)
title("Error")

%% Task 4, 5
images = ["data/data/00125v.jpg", "data/data/00149v.jpg", "data/data/00153v.jpg", "data/data/00351v.jpg", "data/data/00398v.jpg"];
figure(3)
for i=1:size(images,2);
    image = imread(images(i));
    image_blue = image(1:fix(size(image, 1)/3), :);
    subplot(size(images, 2), 4, (i-1)*4+1)
    imshow(image_blue)
    title("Blue channel")
    image_green = image(fix(size(image, 1)/3)+1:fix(size(image, 1)/3)*2, :);
    subplot(size(images, 2), 4, (i-1)*4+2)
    imshow(image_green)
    title("Green channel")
    image_red = image(fix(size(image, 1)/3)*2+1:fix(size(image, 1)/3)*3, :);
    subplot(size(images, 2), 4, (i-1)*4+3)
    imshow(image_red)
    title("Red channel")

    image_rg = normxcorr2(image_red(10:end-10,10:end-10), image_green(10:end-10,10:end-10));
    [ypeak, xpeak] = find(image_rg==max(image_rg(:)));
    yoffset = ypeak-size(image_red(10:end-10,10:end-10),1);
    xoffset = xpeak-size(image_red(10:end-10,10:end-10),2);
    image_red_offed = imtranslate(image_red, [xoffset, yoffset]);

    image_bg = normxcorr2(image_blue(10:end-10,10:end-10), image_green(10:end-10,10:end-10));
    [ypeak, xpeak] = find(image_bg==max(image_bg(:)));
    yoffset = ypeak-size(image_blue(10:end-10,10:end-10),1);
    xoffset = xpeak-size(image_blue(10:end-10,10:end-10),2);
    image_blue_offed = imtranslate(image_blue, [xoffset, yoffset]);

    image_combined = cat(3, image_red_offed, image_green, image_blue_offed);
    subplot(size(images, 2), 4, (i-1)*4+4)
    imshow(image_combined)
    title("Aligned Image")
end