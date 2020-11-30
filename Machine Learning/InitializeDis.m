function paramsDis= InitializeDis(settings,df)
paramsDis.CNW1 = dlarray(initializeGaussian([4,4,settings.image_size(3),df]));
paramsDis.CNb1 = dlarray(zeros(df,1,'single'));
paramsDis.CNW2 = dlarray(initializeGaussian([4,4,df,2*df]));
paramsDis.CNb2 = dlarray(zeros(2*df,1,'single'));
paramsDis.CNW3 = dlarray(initializeGaussian([4,4,2*df,4*df]));
paramsDis.CNb3 = dlarray(zeros(4*df,1,'single'));
paramsDis.CNW4 = dlarray(initializeGaussian([4,4,4*df,8*df]));
paramsDis.CNb4 = dlarray(zeros(8*df,1,'single'));
paramsDis.CNW5 = dlarray(initializeGaussian([4,4,8*df,1]));
paramsDis.CNb5 = dlarray(zeros(1,1,'single'));
end