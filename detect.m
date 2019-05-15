close all;

img = imread('img2.JPG');
%img = imrotate(img, -180);

% roi_list = getSkinSubImages(img);

figure
imshow(img);

% 
% for index = 1:length(roi_list)
%     roi = roi_list{index};
%     sub_img = img(roi(1):roi(2), roi(3):roi(4), :);
%     box = [roi(3), roi(1), roi(4)-roi(3), roi(2)-roi(1)];
% %     hold on;
% %     rectangle('Position', box, 'EdgeColor','r', 'LineWidth', 3);
%     
%     hm = heat_map(sub_img, binary_svm, 128, binary_pca);
%     
%     r = hm;
% 
%     max_num = max(max(r));
% 
%     r = r / max_num;
% 
% 
% 
%     r = imbinarize(r, 0.3);
% 
%     stats = regionprops(r, 'BoundingBox');
% 
%     for i = 1:length(stats)
%         sub_box = stats(i).BoundingBox;
%         sub_box = [sub_box(1) + box(1), sub_box(2) + box(2), sub_box(3), sub_box(4)];
% %         hold on;
% %         rectangle('Position', sub_box, 'EdgeColor','g', 'LineWidth', 3);
%         
%         
%         center_x = ceil(sub_box(1) + sub_box(3)/2);
%         center_y = ceil(sub_box(2) + sub_box(4)/2);
%         if sub_box(3) > sub_box(4)
%             radius = sub_box(3);
%         else
%             radius = sub_box(4);
%         end
%         
%         hand_x = ceil(center_x - radius/2);
%         hand_y = ceil(center_y - radius/2);
%         hand_box = [hand_x, hand_y, radius, radius];
% %         hold on;
% %         rectangle('Position', hand_box, 'EdgeColor','b', 'LineWidth', 4);
%     end
%     
%     figure
%     imshow(hm);
% 
%     
% end


