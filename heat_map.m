function [map] = heat_map(X, model, model_size, pca_trans)

X_size = size(X);
width = X_size(2);
height = X_size(1);

hmap = zeros(height, width);

if width > height
    longest = width;
    shortest = height;
else
    longest = height;
    shortest = width;
end

window_size = [longest/2 shortest];



for window_index = 1:length(window_size)
    s = window_size(window_index);
    offset = round(s * 0.3); % step size
    hori = 0;
%     figure
    while hori + s - offset < width
        if hori > width - s
            hori = width - s;
            if hori < 0
                break;
            end
        end
        ver = 0;
        while ver + s - offset < height
            if ver > height - s
                ver = height - s;
                if ver < 0
                    break;
                end
            end
            sub_img = imcrop(X, [hori, ver, s, s]);
          
%             figure;
%             imshow(sub_img);
            if isempty(sub_img)
                ver = ver + offset;
                continue;
            end
            sub_img = imresize(sub_img, [model_size, model_size]);
            
%             global frame_count
%             imwrite(sub_img, ['./video_frame/skin' num2str(frame_count) '.jpg']);
%             frame_count = frame_count + 1;
         
%             hog = extractHOGFeatures(sub_img, 'CellSize', [8 8]);
            lbp = extractLBPFeatures(rgb2gray(sub_img), 'CellSize', [16 16]);
            sub_feature = [lbp];
            % pca
            %[label, NegLoss, PBScore, Posterior ] = predict(model, sub_feature * pca_trans);
            label = predict(model, sub_feature * pca_trans);
        
            if label > 0
                
                
                hmap(ceil(ver+1):ceil(ver+s), ceil(hori+1):ceil(hori+s)) = hmap(ceil(ver+1):ceil(ver+s), ceil(hori+1):ceil(hori+s)) + 1;
            end
            ver = ver + offset;
        end
        hori = hori + offset;
    end
end

map = hmap;

end

