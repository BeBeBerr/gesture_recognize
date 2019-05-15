close all; clear; clc;
% 
% g1_imgs = dir(['./g1/' '*.jpg']);
% g2_imgs = dir(['./g2/' '*.jpg']);
% g3_imgs = dir(['./g3/' '*.jpg']);
% g4_imgs = dir(['./g4/' '*.jpg']);
% g5_imgs = dir(['./g5/' '*.jpg']);
% background_imgs = dir(['./new_background_2/' '*.jpg']);
% 
% g1_f = zeros(length(g1_imgs), 3776); % hog 8100
% g2_f = zeros(length(g2_imgs), 3776);
% g3_f = zeros(length(g3_imgs), 3776);
% g4_f = zeros(length(g4_imgs), 3776);
% g5_f = zeros(length(g5_imgs), 3776);
% background_f = zeros(length(background_imgs), 3776);
% 
% for i = 1:length(g1_imgs)
%     img = imread(['./g1/' g1_imgs(i).name]);
% %     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
%  
%     g1_f(i, :) = [lbp];
% end
% 
% for i = 1:length(g2_imgs)
%     img = imread(['./g2/' g2_imgs(i).name]);
% %     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
% 
%     g2_f(i, :) = [lbp];
% end
% 
% for i = 1:length(g3_imgs)
%     img = imread(['./g3/' g3_imgs(i).name]);
% %     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
% 
%     g3_f(i, :) = [lbp];
% end
% 
% for i = 1:length(g4_imgs)
%     img = imread(['./g4/' g4_imgs(i).name]);
% %     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
%   
%     g4_f(i, :) = [lbp];
% end
% 
% for i = 1:length(g5_imgs)
%     img = imread(['./g5/' g5_imgs(i).name]);
% %     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
% 
%     g5_f(i, :) = [lbp];
% end
% 
% for i = 1:length(background_imgs)
%     img = imread(['./new_background_2/' background_imgs(i).name]);
% %     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
% 
%     background_f(i, :) = [lbp];
% end
% 
% 
% 
% %display single hog feature
% % img = imread('./background/background100.jpg');
% % img = imread('./hands/hand200.jpg');
% %[hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
% %figure
% %plot(visual);
% 
% 
% %shuffle data
% shuffled_g1_f = g1_f(randperm(size(g1_f,1)),:);
% shuffled_g2_f = g2_f(randperm(size(g2_f,1)),:);
% shuffled_g3_f = g3_f(randperm(size(g3_f,1)),:);
% shuffled_g4_f = g4_f(randperm(size(g4_f,1)),:);
% shuffled_g5_f = g5_f(randperm(size(g5_f,1)),:);
% 
% shuffled_hand_f = [shuffled_g1_f; shuffled_g2_f; shuffled_g3_f; shuffled_g4_f; shuffled_g5_f];
% shuffled_new_background_f = background_f(randperm(size(background_f,1)),:);
% 
% save shuffled_new_background_f
% save shuffled_hand_f



load('shuffled_new_background_f.mat');
load('shuffled_hand_f.mat');


training_set = [shuffled_hand_f(1:1000, :) ; shuffled_new_background_f(1:3000, :)];

labels = [ones(1000, 1) ;zeros(3000, 1)];

hand_n = size(shuffled_hand_f, 1);
background_n = size(shuffled_new_background_f, 1);

test_set = [shuffled_hand_f(1001:hand_n, :) ; shuffled_new_background_f(3001:background_n, :)];


test_labels = [ones(hand_n - 1001 + 1, 1) ; zeros(background_n - 3001 + 1, 1)];

[coeff,score,latent] = pca(training_set);

reduced_d = 500;

trans = coeff(:, 1:reduced_d);

reduced_training_set = zeros(size(training_set, 1), reduced_d);
reduced_test_set = zeros(size(test_set, 1), reduced_d);


for index = 1:size(reduced_training_set, 1)
    reduced_training_set(index, :) = training_set(index, :) * trans;
end

for index = 1:size(reduced_test_set, 1)
    reduced_test_set(index, :) = test_set(index, :) * trans;
end

figure
scatter3(reduced_training_set(1:1000, 1), reduced_training_set(1:1000, 2), reduced_training_set(1:1000, 3), 'r*');
hold on;
scatter3(reduced_training_set(1001:4000, 1), reduced_training_set(1001:4000, 2),reduced_training_set(1001:4000, 3), 'ko');

svm_model = fitcknn(reduced_training_set, labels);


count = 0;
for index = 1:size(reduced_test_set, 1)
    feature = reduced_test_set(index, :);
    label = predict(svm_model, feature);
    if label == test_labels(index)
        count = count + 1;
    end
end
count / length(test_labels)





