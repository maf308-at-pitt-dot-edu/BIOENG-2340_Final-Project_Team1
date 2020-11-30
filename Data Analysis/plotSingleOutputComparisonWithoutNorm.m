%% Plot Single Output Comparison (Without Normalization)
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
    imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T1.png']), trimEdges),       'T1 Original'; ...
    imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T1Fake.png']), trimEdges),   'T1 Generated'; ...
    imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T1Recon.png']), trimEdges),  'T1 Reconstructed'; ...
    };

t2 = {...
    imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T2.png']), trimEdges),       'T2 Original'; ...
    imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T2Fake.png']), trimEdges),   'T2 Generated'; ...
    imTrim(imread([sourceDir, 'sub-SAXSISO02b_150_T2Recon.png']), trimEdges),  'T2 Reconstructed'; ...
    };

%% Perform comparisons

figure(1);
plotFigs(t1);
figure(2);
plotFigs(t2);

% Histogram Values and images for mat-file export
[t1HistCntsOrig, t1HistBinLocsOrig] = imhist(t1{1, 1});
[t1HistCntsFake, t1HistBinLocsFake] = imhist(t1{2, 1});
[t1HistCntsReco, t1HistBinLocsReco] = imhist(t1{3, 1});
[t2HistCntsOrig, t2HistBinLocsOrig] = imhist(t2{1, 1});
[t2HistCntsFake, t2HistBinLocsFake] = imhist(t2{2, 1});
[t2HistCntsReco, t2HistBinLocsReco] = imhist(t2{3, 1});
t1ImgOrig = t1{1, 1};
t1ImgFake = t1{2, 1};
t1ImgReco = t1{3, 1};
t2ImgOrig = t2{1, 1};
t2ImgFake = t2{2, 1};
t2ImgReco = t2{3, 1};

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

function plotFigs(imgNamePairs)
    len = length(imgNamePairs);
    for i = 1:len
        subplot(3, len, i);
        showIm(imgNamePairs{i, 1}, imgNamePairs{i, 2});
        subplot(3, len, i + len);
        imhist(imgNamePairs{i, 1});
        title('Intensity Histogram')
        ylim([0, 500])
        subplot(3, len, i + len*2);
        showIm(abs(imgNamePairs{1, 1} - imgNamePairs{i, 1}), ['Abs(', imgNamePairs{i, 2}, ' - ', imgNamePairs{1, 2}, ')']);
    end
end