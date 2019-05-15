v = VideoReader('video.mov');

count = 0;

c = 0;
while hasFrame(v)
    c = c+1;
    video = readFrame(v);
    if mod(c, 3) ~= 0
        continue
    end
    
    %img = imresize(video, [128 128]);
    img = video;
    imwrite(img, ['./test_video/t' num2str(count) '.jpg']);
    count = count + 1;
    
end