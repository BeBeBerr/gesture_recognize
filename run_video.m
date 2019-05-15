% load('gesture_svm');
% load('binary_svm');
% load('binary_pca');
% load('gesture_pca');

v = VideoReader('test15.mov');
figure
count = 0;
c = 0;

% global frame_count
% frame_count = 4035;
while hasFrame(v)
    c = c+1;
    video = readFrame(v);
    if mod(c, 15) ~= 0
        continue
    end
    
    img = video;
    
    roi_list = getSkinSubImages(img);

    outImage = img;

    for index = 1:length(roi_list)
        roi = roi_list{index};
        sub_img = img(roi(1):roi(2), roi(3):roi(4), :);
        
        box = [roi(3), roi(1), roi(4)-roi(3), roi(2)-roi(1)];
 

        hm = heat_map(sub_img, binary_svm, 128, binary_pca);
    
        r = hm;

        max_num = max(max(r));

        r = r / max_num;



        r = imbinarize(r, 0.3);

        stats = regionprops(r, 'BoundingBox');

        
        for i = 1:length(stats)
            sub_box = stats(i).BoundingBox;
            sub_box = [sub_box(1) + box(1), sub_box(2) + box(2), sub_box(3), sub_box(4)];
%             hold on;
%             rectangle('Position', sub_box, 'EdgeColor','g', 'LineWidth', 3);

            center_x = ceil(sub_box(1) + sub_box(3)/2);
            center_y = ceil(sub_box(2) + sub_box(4)/2);
            if sub_box(3) > sub_box(4)
                radius = sub_box(3);
            else
                radius = sub_box(4);
            end

            hand_x = ceil(center_x - radius/2);
            hand_y = ceil(center_y - radius/2);
            
            if hand_x < 0 || hand_y < 0
                continue;
            end
            
            hand_box = [hand_x, hand_y, radius, radius];
            
            
%             hold on;
%             rectangle('Position', hand_box, 'EdgeColor','b', 'LineWidth', 4);


            yend = floor(hand_box(1)+hand_box(3));
            xend = floor(hand_box(2)+hand_box(4));
            
            if xend > size(img, 1) || yend > size(img, 2)
                xend = size(img, 1);
                yend = size(img, 2);
            end
            
            hand_img = img(ceil(hand_box(2)):xend, ceil(hand_box(1)):yend, :); 
            
            hand_img = imresize(hand_img, [128 128]);
            hog = extractHOGFeatures(hand_img, 'CellSize', [8 8]);
            lbp = extractLBPFeatures(rgb2gray(hand_img), 'CellSize', [16 16]);
            
            hand_f = [hog lbp];
            hand_f = hand_f * gesture_pca;
            
            label = predict(gesture_svm, hand_f);
            
            if label == 1
                label_text = 'Open Hand';
            elseif label == 2
                label_text = 'R&R';
            elseif label == 3
                label_text = 'Fist';
            elseif label == 4
                label_text = 'Finger Gun';
            else
                label_text = 'Thumb Up';
            end

            outImage = insertObjectAnnotation(outImage,'rectangle',hand_box, label_text, 'LineWidth', 20, 'FontSize', 70, 'Color', 'green');
            
            
        end
        
    
    end
   
    imwrite(outImage, ['./video_frame/frame' num2str(count) '.jpg']);
    count = count + 1;
        
       
   
    
end