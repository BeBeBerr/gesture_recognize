imgs = dir(['./video_frame/' '*.jpg']);

video = VideoWriter('output.mp4', 'MPEG-4'); %create the video object
video.FrameRate = 20;
open(video); %open the file for writing

% figure;

for ii = 0:351
    img = imread(['./video_frame/frame' num2str(ii) '.jpg']);
    
%     imshow(img);
    
    writeVideo(video,img);
end

close(video);