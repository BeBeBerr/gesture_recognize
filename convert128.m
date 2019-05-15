
background_imgs = dir(['./new_background/' '*.jpg']);
% % % % % % % % % % % % % % % % % % % % for i = 1:length(background_imgs)
    img = imread(['./new_background/' background_imgs(i).name]);
    img = imresize(img, [128 128]);
    imwrite(img, ['./sub/bg' num2str(i) '.jpg']);
end