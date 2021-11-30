%% Task 1
campose_filenames = dir("data/cam-poses/*.txt");

for i=1:length(campose_filenames)
    t_affine{i} = readmatrix("data/cam-poses/"+campose_filenames(i).name);
    r{i} = t_affine{i}(1:3, 1:3)';
    t{i} = t_affine{i}(:, 4);
    c{i} = -inv(r{i}')*t{i};
end
%% Task 2 (rc1) 
intrinsic_params = readmatrix("data/Calibration.txt");
image_filenames = dir("data/images/*.jpg");

for i=1:length(image_filenames)-1
    left_image = imread("data/images/"+image_filenames(i).name);
    right_image = imread("data/images/"+image_filenames(i+1).name);
    e = t{i}-r{i}'*inv(r{i+1}')*t{i+1};
    r_1 = e'./norm(e);
    r_2 = 1/sqrt(e(2)^2+e(1)^2).*[-e(2) e(1) 0];
    r_rect = [r_1;r_2;cross(r_1,r_2)];
    R_1 = r_rect;
    R_2 = r_rect*r{i}*inv(r{i+1});
    left_mat = intrinsic_params*R_1*inv(intrinsic_params);
    left_mat(:,3) = [0;0;1];
    right_mat = intrinsic_params*R_2*inv(intrinsic_params);
    right_mat(:,3) = [0;0;1];
    left_warped = imwarp(left_image, affine2d(left_mat));
    right_warped = imwarp(right_image, affine2d(right_mat));
    
    % crop image (make same height)
    left_warped_resized = imcrop(left_warped, [0 0 min(size(left_warped,2), size(right_warped,2)) min(size(left_warped,1), size(right_warped,1))]);
    right_warped_resized = imcrop(right_warped, [0 0 min(size(left_warped,2), size(right_warped,2)) min(size(left_warped,1), size(right_warped,1))]);
    figure(i), subplot(2,1,1), imshow([left_image right_image]);
    title("Before");
    hold on;
    for j=1:50:size(left_image,1)
        figure(i), subplot(2,1,1), plot([0 size(left_image,2)+size(right_image,2)], [j j], 'color', 'red')
    end
    figure(i), subplot(2,1,2), imshow([rot90(rot90(left_warped_resized)) rot90(rot90(right_warped_resized))]);
    title("After");
    hold on;
    for j=1:50:size(left_warped_resized,1)
        figure(i), subplot(2,1,2), plot([0 size(left_warped_resized,2)+size(right_warped_resized,2)], [j j], 'color', 'red')
    end
end

%% Task 2 (rc2)
intrinsic_params = readmatrix("data/Calibration.txt");
image_filenames = dir("data/images/*.jpg");

for i=1:length(image_filenames)-1
    left_image = imread("data/images/"+image_filenames(i).name);
    right_image = imread("data/images/"+image_filenames(i+1).name);
    T = (c{i} - c{i+1})';
    r_1 = T./norm(T);
    r_2 = 1/sqrt(T(1)^2+T(2)^2).*[-T(2) T(1) 0];
    r_rect = [r_1;r_2;cross(r_1,r_2)];
    R_1 = r_rect;
    R_2 = r_rect*r{i}*inv(r{i+1});
    left_mat = intrinsic_params*R_1*inv(intrinsic_params);
    left_mat(:,3) = [0;0;1];
    right_mat = intrinsic_params*R_2*inv(intrinsic_params);
    right_mat(:,3) = [0;0;1];
    left_warped = imwarp(left_image, projective2d(left_mat));
    right_warped = imwarp(right_image, projective2d(right_mat));
    
    % crop image (make same height)
    left_warped_resized = imcrop(left_warped, [0 0 min(size(left_warped,2), size(right_warped,2)) min(size(left_warped,1), size(right_warped,1))]);
    right_warped_resized = imcrop(right_warped, [0 0 min(size(left_warped,2), size(right_warped,2)) min(size(left_warped,1), size(right_warped,1))]);
    figure(i), subplot(2,1,1), imshow([left_image right_image]);
    title("Before");
    hold on;
    for j=1:50:size(left_image,1)
        figure(i), subplot(2,1,1), plot([0 size(left_image,2)+size(right_image,2)], [j j], 'color', 'red')
    end
    figure(i), subplot(2,1,2), imshow([rot90(left_warped_resized) rot90(right_warped_resized)]);
    title("After");
    hold on;
    for j=1:50:size(left_warped_resized,1)
        figure(i), subplot(2,1,2), plot([0 size(left_warped_resized,1)+size(right_warped_resized,1)], [j j], 'color', 'red')
    end
end