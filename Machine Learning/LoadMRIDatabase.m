%% Load images from files
path = 'C:\Users\Pete\OneDrive\Documents\IntroMedImaging\Project\GAN_Master\Matlab-GAN-master\CycleGAN\FullMRIData\T1\';
filesA = dir([path '*.png']);
Alist = []; 
for i = 1:length(filesA)
    imj=imresize(imread([path filesA(i).name]),[128,128]);
    Alist = cat(4,Alist,im2double(imj));
    if i == 2999
        disp('Halfway Done with A')
    end
end

disp('Done with A')
path = 'C:\Users\Pete\OneDrive\Documents\IntroMedImaging\Project\GAN_Master\Matlab-GAN-master\CycleGAN\FullMRIData\T2\';
filesB = dir([path '*.png']);
Blist = [];
for i = 1:length(filesB)
    imj=imresize(imread([path filesB(i).name]),[128,128]);
    Blist = cat(4,Blist,im2double(imj));
    if i == 2999
        disp('Halfway Done with B')
    end
end