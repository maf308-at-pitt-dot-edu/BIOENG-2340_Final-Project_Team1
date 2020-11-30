%% params Generator Initilization
function paramsGen = InitializeGen(settings,gf)
paramsGen.CNW1 = dlarray(initializeGaussian([4,4,settings.image_size(3),gf]));
paramsGen.CNb1 = dlarray(zeros(gf,1,'single'));
paramsGen.CNW2 = dlarray(initializeGaussian([4,4,gf,2*gf]));
paramsGen.CNb2 = dlarray(zeros(2*gf,1,'single'));
paramsGen.CNW3 = dlarray(initializeGaussian([4,4,2*gf,4*gf]));
paramsGen.CNb3 = dlarray(zeros(4*gf,1,'single'));
paramsGen.CNW4 = dlarray(initializeGaussian([4,4,4*gf,8*gf]));
paramsGen.CNb4 = dlarray(zeros(8*gf,1,'single'));

paramsGen.TCW1 = dlarray(initializeGaussian([4,4,4*gf,8*gf]));
paramsGen.TCb1 = dlarray(zeros(4*gf,1,'single'));
paramsGen.TCW2 = dlarray(initializeGaussian([4,4,2*gf,8*gf]));
paramsGen.TCb2 = dlarray(zeros(2*gf,1,'single'));
paramsGen.TCW3 = dlarray(initializeGaussian([4,4,gf,4*gf]));
paramsGen.TCb3 = dlarray(zeros(gf,1,'single'));
paramsGen.TCW4 = dlarray(initializeGaussian([4,4,settings.image_size(3),2*gf]));
paramsGen.TCb4 = dlarray(zeros(settings.image_size(3),1,'single'));
end