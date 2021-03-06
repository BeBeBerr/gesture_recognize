function images = getSkinSubImages(I)
%input an RGB image or change this function to input a Binary image and we
%can skip the next line that makes the mask
BW = createMask(I);
stats = regionprops(BW, 'BoundingBox');
imshow(BW);
len = length(stats);
images = cell(1,len);
for i = 1 : length(stats)
   box = stats(i).BoundingBox;
   yend = floor(box(1)+box(3));
   xend = floor(box(2)+box(4));
   % mat = I(ceil(box(2)):xend, ceil(box(1)):yend, :); 
   images{1,i} = [ceil(box(2)), xend, ceil(box(1)), yend];
end
end

function BW = createMask(RGB)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder App. The colorspace and
%  minimum/maximum values for each channel of the colorspace were set in the
%  App and result in a binary mask BW and a composite image maskedRGBImage,
%  which shows the original RGB image values under the mask BW.

% Auto-generated by colorThresholder app on 22-Jun-2016
%------------------------------------------------------


% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.0;
channel1Max = 0.07;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.188;
channel2Max = 1.0;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.314;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
BW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

%need to adjust this based on the size of the images we are using
%120,000 is 1% of the 3000x4000 images. works well on all the ones I tested
pixels = size(RGB, 1) * size(RGB, 2);

BW = bwareaopen(BW, 0.005 * pixels);
%the fill may be unneccesary if we arent using the percentage of skin color
%BW = imfill(BW, 'holes');
end