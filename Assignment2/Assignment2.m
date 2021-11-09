%% Task 1

image = imread("images/wall/im1.pgm");

% apply gaussian filter
gimage = filter2(fspecial('gaussian', 11, 0.5), image);
% find gradient
[Gx, Gy] = imgradientxy(gimage);
%imshow(Gx);
%imshow(Gy);

result = zeros(size(image));

for i=6:size(image, 1)-5
    for j=6:size(image, 2)-5
        % 11-by-11 window
        Ix = Gx(i-5:i+5,j-5:j+5);
        Iy = Gy(i-5:i+5,j-5:j+5);
        H = [sum(Ix.^2, 'all') sum(Ix.*Iy, 'all');sum(Ix.*Iy, 'all') sum(Iy.^2, 'all')];
        result(i,j) = det(H)-0.05*(trace(H)^2);
    end
end

%imshow(result);

[B, I] = sort(result(:), 'descend');
[top_1000_y, top_1000_x] = ind2sub(size(image), I(1:1000));

figure(1), imshow(image);
hold on;
figure(1), scatter(top_1000_x, top_1000_y);

%% Task 2
local_max_x = [];
local_max_y = [];

% binary circle mask
disk_mask = fspecial('disk', 10);

for i=1:1000
    [~, pos] = max(disk_mask .* result(top_1000_y(i)-10:top_1000_y(i)+10,top_1000_x(i)-10:top_1000_x(i)+10), [], 'all', 'linear');
    if pos == 21*10+11  % if the position of the maximum value is the center of the circle
        % then add to the list of local_max coordinates
        local_max_x = [local_max_x;top_1000_x(i)];
        local_max_y = [local_max_y;top_1000_y(i)];
    end
end

figure(2), imshow(image);
hold on;
figure(2), scatter(local_max_x, local_max_y, 'red', 'LineWidth', 1);

