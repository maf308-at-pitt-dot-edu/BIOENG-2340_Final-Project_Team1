%% White Paper Figures
% Author: Mark Freithaler
% Course: BIOENG 2340
% Assgn: Final Project
% Date: Fall 2020

%% Cleanup
clc

%% CONSTS
% sourceDir = 'C:\Users\Mark\Desktop\OneDrive_2020-11-05\output\';
sourceDir = 'C:\Users\Mark\Desktop\OneDrive_2020-11-05\results\Combined\';

% Pixels to trim from each edge of the images being compared [L, R, T, B]
trimEdges = [0, 17, 0, 0];

% Load Images
t1 = {...
    mat2gray(imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T1.png']), trimEdges)),       'T1 Original'; ...
    mat2gray(imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T2Fake.png']), trimEdges)),   'T2 Generated'; ...
    mat2gray(imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T1Recon.png']), trimEdges)),  'T1 Reconstructed'; ...
    };

t2 = {...
    mat2gray(imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T2.png']), trimEdges)),       'T2 Original'; ...
    mat2gray(imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T1Fake.png']), trimEdges)),   'T1 Generated'; ...
    mat2gray(imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T2Recon.png']), trimEdges)),  'T2 Reconstructed'; ...
    };

%% Perform comparisons

len = length(t1);
for i = 1:len
    subplot(2, len, i);
    showIm(t1{i, 1}, t1{i, 2});
end

for i = 1:len
    subplot(2, len, i + len);
    showIm(t2{i, 1}, t2{i, 2});
end


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