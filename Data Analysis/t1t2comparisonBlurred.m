%% T1 vs T2 Generations
% Author: Mark Freithaler
% Course: BIOENG 2340
% Assgn: Final Project
% Date: Fall 2020

%% Cleanup
clc

%% CONSTS
% sourceDir = 'C:\Users\Mark\Desktop\OneDrive_2020-11-05\output\';
sourceDir = 'C:\Users\Mark\Desktop\OneDrive_2020-11-05\results\Combined\';
blurSize = 5;

% Pixels to trim from each edge of the images being compared [L, R, T, B]
trimEdges = [0, 17, 0, 0];

% Load Images
t1 = {...
    mat2gray(imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T1.png']), trimEdges)),       'T1 Original'; ...
    mat2gray(imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T1Fake.png']), trimEdges)),   'T1 Generated'; ...
    };

t2 = {...
    mat2gray(imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T2.png']), trimEdges)),       'T2 Original'; ...
    mat2gray(imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T2Fake.png']), trimEdges)),   'T2 Generated'; ...
    };

%% Perform comparisons

figure(4);
% Plain Images
subplot(3, 3, 1);
showIm(t1{1, 1}, t1{1, 2});
subplot(3, 3, 9);
showIm(t2{1, 1}, t2{1, 2});
subplot(3, 3, 3);
showIm(t1{2, 1}, t1{2, 2});
subplot(3, 3, 7);
showIm(t2{2, 1}, t2{2, 2});

% Comparisons
subplot(3, 3, 2);
showIm(findBlurredDiffs(t1{1, 1}, t1{2, 1}, blurSize), ['Abs(', t1{1, 2}, ' - ', t1{2, 2}, ')']);
subplot(3, 3, 4);
showIm(findBlurredDiffs(t1{1, 1}, t2{2, 1}, blurSize), ['Abs(', t1{1, 2}, ' - ', t2{2, 2}, ')']);
subplot(3, 3, 6);
showIm(findBlurredDiffs(t2{1, 1}, t1{2, 1}, blurSize), ['Abs(', t2{1, 2}, ' - ', t1{2, 2}, ')']);
subplot(3, 3, 8);
showIm(findBlurredDiffs(t2{1, 1}, t2{2, 1}, blurSize), ['Abs(', t2{1, 2}, ' - ', t2{2, 2}, ')']);

subplot(3, 3, 5);
showIm(abs(t1{1, 1} - t2{1, 1}), ['Abs(', t1{1, 2}, ' - ', t2{1, 2}, ')']);

%% Helper Functions
function output = imTrim(img, trims)
    rows = 1;
    cols = 2;
    left = 1;
    right = 2;
    top = 3;
    bottom = 4;

    imDims = size(img);
    output = img((1 + trims(top)):(imDims(rows) - trims(bottom)), ...
        (1 + trims(left)):(imDims(cols) - trims(right)));
end

function showIm(img, t)
    imshow(img);
    colormap('gray');
    axis off;
    title(t)
end

function blurred_diff = findBlurredDiffs(img_a, img_b, windowWidth)
    h = ones(windowWidth, windowWidth)/(windowWidth.^2);
    imgABlur = imfilter(img_a, h);
    imgBBlur = imfilter(img_b, h);
    blurred_diff = abs(imgABlur - imgBBlur);
end