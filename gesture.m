% close all; clear; clc;

% g1_imgs = dir(['./g1/' '*.jpg']);
% g2_imgs = dir(['./g2/' '*.jpg']);
% g3_imgs = dir(['./g3/' '*.jpg']);
% g4_imgs = dir(['./g4/' '*.jpg']);
% g5_imgs = dir(['./g5/' '*.jpg']);
% background_imgs = dir(['./background/' '*.jpg']);
% 
% g1_f = zeros(length(g1_imgs), 8100 + 3776);
% g2_f = zeros(length(g2_imgs), 8100 + 3776);
% g3_f = zeros(length(g3_imgs), 8100 + 3776);
% g4_f = zeros(length(g4_imgs), 8100 + 3776);
% g5_f = zeros(length(g5_imgs), 8100 + 3776);
% background_f = zeros(length(background_imgs), 8100 + 3776);
% 
% for i = 1:length(g1_imgs)
%     img = imread(['./g1/' g1_imgs(i).name]);
%     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
%     g1_f(i, :) = [hog lbp];
% end
% 
% for i = 1:length(g2_imgs)
%     img = imread(['./g2/' g2_imgs(i).name]);
%     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
%     g2_f(i, :) = [hog lbp];
% end
% 
% for i = 1:length(g3_imgs)
%     img = imread(['./g3/' g3_imgs(i).name]);
%     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
%     g3_f(i, :) = [hog lbp];
% end
% 
% for i = 1:length(g4_imgs)
%     img = imread(['./g4/' g4_imgs(i).name]);
%     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
%     g4_f(i, :) = [hog lbp];
% end
% 
% for i = 1:length(g5_imgs)
%     img = imread(['./g5/' g5_imgs(i).name]);
%     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
%     g5_f(i, :) = [hog lbp];
% end
% 
% for i = 1:length(background_imgs)
%     img = imread(['./background/' background_imgs(i).name]);
%     [hog, visual] = extractHOGFeatures(img, 'CellSize', [8 8]);
%     lbp = extractLBPFeatures(rgb2gray(img), 'CellSize', [16 16]);
%     background_f(i, :) = [hog lbp];
% end
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
% shuffled_background_f = background_f(randperm(size(background_f,1)),:);
% 
% save shuffled_g1_f
% save shuffled_g2_f
% save shuffled_g3_f
% save shuffled_g4_f
% save shuffled_g5_f
% save shuffled_background_f
% 



% load('shuffled_g1_f.mat');
% load('shuffled_g2_f.mat');
% load('shuffled_g3_f.mat');
% load('shuffled_g4_f.mat');
% load('shuffled_g5_f.mat');

training_set = [shuffled_g1_f(1:200, :) ; 
    shuffled_g2_f(1:200, :) ; 
    shuffled_g3_f(1:200, :) ; 
    shuffled_g4_f(1:200, :) ; 
    shuffled_g5_f(1:200, :) ; 
   ];

labels = [ones(200, 1) ; 
    ones(200, 1) + 1; 
    ones(200, 1) + 2; 
    ones(200, 1) + 3; 
    ones(200, 1) + 4; 
 ];

g1_n = size(shuffled_g1_f, 1);
g2_n = size(shuffled_g2_f, 1);
g3_n = size(shuffled_g3_f, 1);
g4_n = size(shuffled_g4_f, 1);
g5_n = size(shuffled_g5_f, 1);


test_set = [shuffled_g1_f(201:g1_n, :) ; 
    shuffled_g2_f(201:g2_n, :) ; 
    shuffled_g3_f(201:g3_n, :) ; 
    shuffled_g4_f(201:g4_n, :) ; 
    shuffled_g5_f(201:g5_n, :) ;
   ];


test_labels = [ones(g1_n - 201 + 1, 1) ; 
    ones(g2_n - 201 + 1, 1) + 1;
    ones(g3_n - 201 + 1, 1) + 2;
    ones(g4_n - 201 + 1, 1) + 3;
    ones(g5_n - 201 + 1, 1) + 4;
 ];

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
scatter3(reduced_training_set(1:200, 1), reduced_training_set(1:200, 2),reduced_training_set(1:200, 3), 'r*');
hold on;
scatter3(reduced_training_set(201:400, 1), reduced_training_set(201:400, 2),reduced_training_set(201:400, 3), 'g*');
hold on;
scatter3(reduced_training_set(401:600, 1), reduced_training_set(401:600, 2),reduced_training_set(401:600, 3), 'b*');
hold on;
scatter3(reduced_training_set(601:800, 1), reduced_training_set(601:800, 2),reduced_training_set(601:800, 3), 'c*');
hold on;
scatter3(reduced_training_set(801:1000, 1), reduced_training_set(801:1000, 2),reduced_training_set(801:1000, 3), 'm*');


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





