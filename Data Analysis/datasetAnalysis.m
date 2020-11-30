%% Dataset Analysis
% Author: Mark Freithaler
% Course: BIOENG 2340
% Assgn: Final Project
% Date: Fall 2020

%% Cleanup
close all
clc

%% CONSTS
% sourceDir = 'C:\Users\Mark\Desktop\OneDrive_2020-11-05\output\';
sourceDir = 'C:\Users\Mark\Desktop\OneDrive_2020-11-05\output_first_5\';
sourceDir1 = [sourceDir, 'T1\'];
sourceDir2 = [sourceDir, 'T2\'];
    
relevantFilePrefix = 'sub-SAX';
indexDelimiter = '_';

% Pixels to trim from each edge of the images being compared [L, R, T, B]
rows = 1;
cols = 2;
left = 1;
right = 2;
top = 3;
bottom = 4;
trimEdges = [0, 0, 0, 0];

% Example file name: sub-SAXSISO01b_150_T1.png

%% Compare datasets
fileList1 = dir([sourceDir1, relevantFilePrefix, '*']);
file_names = strings(length(fileList1), 1);
total_diff = zeros(length(fileList1), 1);
total_hist_diff = zeros(length(fileList1), 1);
total_blur1_diff = zeros(length(fileList1), 1);
total_blur3_diff = zeros(length(fileList1), 1);
total_blur5_diff = zeros(length(fileList1), 1);
total_blur7_diff = zeros(length(fileList1), 1);
total_hist1_diff = zeros(length(fileList1), 1);
total_hist3_diff = zeros(length(fileList1), 1);
total_hist5_diff = zeros(length(fileList1), 1);
total_hist7_diff = zeros(length(fileList1), 1);

% For each imge in the first directory
for i = 1:length(fileList1)
    im1 = imread([sourceDir1, fileList1(i).name]);
    % Search for the first matching file in the second list
    segs = split(fileList1(i).name, indexDelimiter);
    searchString = [char(segs(1)), indexDelimiter, char(segs(2))];
    fileName2 = dir([sourceDir2, searchString, '*']);
    im2 = imread([sourceDir2, fileName2.name]);

    % If they are not gray, make them gray
    imDims = size(im1);
    if length(imDims) > 2
        im1 = rgb2gray(im1);
    end
    imDims = size(im2);
    if length(imDims) > 2
        im2 = rgb2gray(im2);
    end
    if prod(size(im1) == size(im1)) == 0
        disp('WARNING: Image dimenstions do not match');
    end
    
    % Trim the images
    im1 = im1((1 + trimEdges(top)):(imDims(rows) - trimEdges(bottom)), ...
        (1 + trimEdges(left)):(imDims(cols) - trimEdges(right)));
    im2 = im2((1 + trimEdges(top)):(imDims(rows) - trimEdges(bottom)), ...
        (1 + trimEdges(left)):(imDims(cols) - trimEdges(right)));
    
    % Perform comparisons
    % Index
    file_names(i) = searchString;
    
    % Without blurring
    diff = abs(im1-im2);
    total_diff(i) = sum(diff(:));
    hist1 = imhist(im1);
    hist2 = imhist(im2);
    diff = abs(hist1-hist2);
    total_hist_diff(i) = sum(diff(:));
    
    % Blured Differences
    [total_blur1_diff(i), total_hist1_diff(i)] = findBlurredDiffs(im1, im2, 1);
    [total_blur3_diff(i), total_hist3_diff(i)] = findBlurredDiffs(im1, im2, 3);
    [total_blur5_diff(i), total_hist5_diff(i)] = findBlurredDiffs(im1, im2, 5);
    [total_blur7_diff(i), total_hist7_diff(i)] = findBlurredDiffs(im1, im2, 7);
    
end

% Save Data
results = table(file_names, total_diff, total_hist_diff, ...
    total_blur1_diff, total_hist1_diff, ...
    total_blur3_diff, total_hist3_diff, ...
    total_blur5_diff, total_hist5_diff, ...
    total_blur7_diff, total_hist7_diff);

writetable(results, [sourceDir, 'results.csv'])

function [totalBlurredDiff, totalBlurredHistDiff] = findBlurredDiffs(img_a, img_b, windowWidth)
    h = ones(windowWidth, windowWidth)/(windowWidth.^2);
    imgABlur = imfilter(img_a, h);
    imgBBlur = imfilter(img_b, h);
    
    blurred_diff = abs(imgABlur - imgBBlur);
    totalBlurredDiff = sum(blurred_diff(:));
    histA = imhist(imgABlur);
    histB = imhist(imgBBlur);
    blurred_diff = abs(histA - histB);
    totalBlurredHistDiff = sum(blurred_diff(:));    
end