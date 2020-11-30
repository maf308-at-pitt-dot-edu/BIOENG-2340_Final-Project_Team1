%% Dataset Preparation
% Author: Mark Freithaler
% Course: BIOENG 2340
% Assgn: Final Project
% Date: Fall 2020

%% Assumptions
% The directory structure is uniform and follows (sourceDir/Setup-Inidicies/anat/filename_T1w.nii.gz)

%% Cleanup
close all
clc

%% CONSTS
sourceDir = 'C:\Users\Mark\Desktop\OneDrive_2020-11-05\2340 Dataset\';
destDir = 'C:\Users\Mark\Desktop\OneDrive_2020-11-05\output\'; % 'T1' and 'T2' will be appended.
destDirT1 = [destDir, 'T1\'];
destDirT2 = [destDir, 'T2\'];

%% Enumerate iterative values
setupList = dir([sourceDir, 'sub-SAX*']);

%% Open nifti and choose slices to export

% Iterate through all the setups (Patient & day)
endi = numel(setupList);
for i = 88:1:endi
    % Load in the setup imaging data
    %t1Nifti = niftiread([sourceDir, setupList(i).name, '\anat\', setupList(i).name, '_T1w.nii.gz']);
    %t2Nifti = niftiread([sourceDir, setupList(i).name, '\anat\', setupList(i).name, '_T2w.nii.gz']);
    % The naming convention changed half-way through
    t1Nifti = niftiread([sourceDir, setupList(i).name, '\anat\', setupList(i).name, '_anat_', setupList(i).name, '_T1w.nii.gz']);
    t2Nifti = niftiread([sourceDir, setupList(i).name, '\anat\', setupList(i).name, '_anat_', setupList(i).name, '_T2w.nii.gz']); 
    
    % Ask the user to select the top and bottom slices
    topSliceNum = GetSliceNumAndVerify(t1Nifti, t2Nifti,...
        [sprintf('Select TOP slice (%d of %d) ', i, endi), setupList(i).name]);
    bopSliceNum = GetSliceNumAndVerify(t1Nifti, t2Nifti,...
        [sprintf('Select BOTTOM slice (%d of %d) ', i, endi), setupList(i).name]);
    
    % Iterate through and export all the selected slices for both T1 and T2
    for j = bopSliceNum:1:topSliceNum
       % Create file paths
       mkdir(destDirT1);
       mkdir(destDirT2);
       
       % Select data for export
       t1slice = squeeze(t1Nifti(:, :, j));
       t2slice = squeeze(t2Nifti(:, :, j));
       
       % Export to PNGs
       imwrite(im2double(t1slice), [destDirT1, setupList(i).name, sprintf('_%03d', j), '_T1.png']);
       imwrite(im2double(t2slice), [destDirT2, setupList(i).name, sprintf('_%03d', j), '_T2.png']);
    end
end

function sliceNum = GetSliceNumAndVerify(t1scan3D, t2scan3D, reqText)
    f = figure;
    sz = size(t1scan3D);
    f.Name = reqText;
    f.NumberTitle = 'off'; 
    
    % Look at the center sagital slice for axial slice selection
    t1sagCenter = ceil(sz(1)/2);
    t2sagCenter = ceil(sz(1)/2);
    sagCenterIm = cat(3,...
        im2double(squeeze(t1scan3D(t1sagCenter, :, :))),...
        im2double(squeeze(t2scan3D(t2sagCenter, :, :))),...
        zeros(sz(2), sz(3)));
    
    verified = 'no';
    while strcmp(verified, 'Yes') == 0
        % Select the slice on the sagital image
        imshow(sagCenterIm)
        sagSz = size(sagCenterIm);
        truesize(f, sagSz(1:2)*2)
        movegui(f, 'north');
        pt = drawpoint();
        sliceNum = round(pt.Position(1));
        t1slice = squeeze(t1scan3D(:, :, sliceNum));
        t2slice = squeeze(t2scan3D(:, :, sliceNum));
        
        % Verify using the axial images
        t1t2slice = [t1slice, t2slice];
        imshow(t1t2slice)
        truesize(f, size(t1t2slice)*2)
        movegui(f, 'north');
        verified = questdlg('Is this good?', 'Verify', 'Yes', 'No', 'Yes');
    end
    close(f)
end