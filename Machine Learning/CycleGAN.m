%% Cycle-GAN
%% Load Data
trainA = preprocess(Alist);
trainB = preprocess(Blist);
%% Settings
gf = 32; df = 64; settings.disc_patch = [8,8,1];
settings.lambda_cycle = 10;
settings.lambda_id = .1*settings.lambda_cycle;
settings.batch_size = 1; settings.image_size=[128,128,1]; 
settings.lr = 0.0002; settings.beta1 = 0.5;
settings.beta2 = 0.999; settings.maxepochs = 200;

%% 2 Generator (conv->deconv)
paramsGAB = InitializeGen(settings,gf);
paramsGBA = InitializeGen(settings,gf);
%% 2 Discriminator (conv)
paramsDA = InitializeDis(settings,df);
paramsDB = InitializeDis(settings,df);
%% Train
% average Gradient and average Gradient squared holders
avgG.DA = []; avgGS.DA = []; avgG.DB = []; avgGS.DB = []; 
avgG.GAB = []; avgGS.GAB = []; avgG.GBA = []; avgGS.GBA = [];
numIterations = floor(size(trainA,4)/settings.batch_size);
out = false; epoch = 0; global_iter = 0; count = 1;
while ~out
    tic; 
    shuffleid = randperm(size(trainA,4));
    trainAshuffle = trainA(:,:,:,shuffleid);
    trainBshuffle = trainB(:,:,:,shuffleid);
    fprintf('Epoch %d\n',epoch) 
    for i=1:numIterations
        global_iter = global_iter+1;
        ABatch=gpdl(trainAshuffle(:,:,:,i),'SSCB');
        BBatch=gpdl(trainBshuffle(:,:,:,i),'SSCB');

        [GradGAB,GradGBA,GradDA,GradDB] = ...
            dlfeval(@modelGradients,ABatch,BBatch,...
            paramsGAB,paramsGBA,paramsDA,paramsDB,...
            settings);

        % Update Discriminator network parameters
        [paramsDA,avgG.DA,avgGS.DA] = ...
            adamupdate(paramsDA, GradDA, ...
            avgG.DA, avgGS.DA, global_iter, ...
            settings.lr, settings.beta1, settings.beta2);
        [paramsDB,avgG.DB,avgGS.DB] = ...
            adamupdate(paramsDB, GradDB, ...
            avgG.DB, avgGS.DB, global_iter, ...
            settings.lr, settings.beta1, settings.beta2);

        % Update Generator network parameters
        [paramsGAB,avgG.GAB,avgGS.GAB] = ...
            adamupdate(paramsGAB, GradGAB, ...
            avgG.GAB, avgGS.GAB, global_iter, ...
            settings.lr, settings.beta1, settings.beta2);
        [paramsGBA,avgG.GBA,avgGS.GBA] = ...
            adamupdate(paramsGBA, GradGBA, ...
            avgG.GBA, avgGS.GBA, global_iter, ...
            settings.lr, settings.beta1, settings.beta2);
        if i==1 || rem(i,20)==0
            idxPlot = [200];
            APlot = gpdl(trainA(:,:,:,idxPlot),'SSCB');
            BPlot = gpdl(trainB(:,:,:,idxPlot),'SSCB');
            progressplot(APlot,BPlot,paramsGAB,paramsGBA)
        end
        
        if rem(global_iter,count^2)==0 || rem(global_iter,200)==0
            h = gcf;
            % Capture the plot as an image 
            frame = getframe(h); 
            im = frame2im(frame); 
            [imind,cm] = rgb2ind(im,256); 
            % Write to the GIF File 
            if count == 1
              imwrite(imind,cm,'CycleGAN.gif','gif', 'Loopcount',inf); 
            else 
              imwrite(imind,cm,'CycleGAN.gif','gif','WriteMode','append'); 
            end 
            
            count = count+1;
        end
    
    end

    elapsedTime = toc;
    disp("Epoch "+epoch+". Time taken for epoch = "+elapsedTime + "s")
    epoch = epoch+1;
    if epoch == settings.maxepochs
        out = true;
    end    
end
