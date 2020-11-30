%% modelGradients
function [GradGAB,GradGBA,GradDA,GradDB]=...
    modelGradients(A,B,paramsGAB,paramsGBA,...
    paramsDA,paramsDB,settings)
fakeA = Generator(B,paramsGBA);
fakeB = Generator(A,paramsGAB);
reconB = Generator(fakeA,paramsGAB);
reconA = Generator(fakeB,paramsGBA);
idA = Generator(A,paramsGBA);
idB = Generator(B,paramsGAB);
validA0= Discriminator(A,paramsDA);
validB0= Discriminator(B,paramsDB);
validA = Discriminator(fakeA,paramsDA);
validB = Discriminator(fakeB,paramsDB);
% Loss calculation for Discriminator
%A
dA_loss_real = mean((validA0-1).^2,'all');
dA_loss_fake = mean((validA).^2,'all');
dA_loss = .5*(dA_loss_real+dA_loss_fake);
%B
dB_loss_real = mean((validB0-1).^2,'all');
dB_loss_fake = mean((validB).^2,'all');
dB_loss = .5*(dB_loss_real+dB_loss_fake);
% Loss calculation for Generator
%AB
gAB_loss_fake = mean((validB-1).^2,'all');
gAB_L1id = mean(abs(idB-B),'all');
gAB_L1re = mean(abs(reconB-B),'all');
%BA
gBA_loss_fake = mean((validA-1).^2,'all');
gBA_L1id = mean(abs(idA-A),'all');
gBA_L1re = mean(abs(reconA-A),'all');
%Total
g_loss=gAB_loss_fake+gBA_loss_fake+...
    settings.lambda_cycle*(gAB_L1re+gBA_L1re)+...
    settings.lambda_id*(gAB_L1id+gBA_L1id);

[GradGAB,GradGBA] = dlgradient(g_loss,...
    paramsGAB,paramsGBA,...
    'RetainData',true);
GradDA = dlgradient(dA_loss,paramsDA);
GradDB = dlgradient(dB_loss,paramsDB);
end