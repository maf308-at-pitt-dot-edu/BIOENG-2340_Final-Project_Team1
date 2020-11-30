%% Generator
function dly = Generator(dlx,params)
d0 = dlx;
evaconv='d%d = dlconv(d%d,params.CNW%d,params.CNb%d,"Stride",2,"Padding","same");';
evaleak='d%d = leakyrelu(d%d,.2);';
evainst='d%d = instancenorm(d%d);';
evatran='u%d=dltranspconv(u%d,params.TCW%d,params.TCb%d,"Stride",2,"Cropping","same");';
evacat3='u%d=cat(3,u%d,d%d);';
evainst2='u%d = instancenorm(u%d);';
for i = 1:4
    eval(sprintf(evaconv,i,i-1,i,i));
    eval(sprintf(evaleak,i,i));
    eval(sprintf(evainst,i,i));
end
u0 = d4;
% u1=dltranspconv(d0,params.TCW1,params.TCb1,'Stride',2,'Cropping','same');
for i = 0:3
    eval(sprintf(evatran,i+1,i,i+1,i+1));
    if i < 3
        eval(sprintf(evainst2,i+1,i+1));
        eval(sprintf(evacat3,i+1,i+1,3-i));
    end
end
% tanh layer
dly = tanh(u4);
end