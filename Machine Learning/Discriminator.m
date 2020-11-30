%% Discriminator
function dly = Discriminator(dlx,params)
d0 = dlx;
evaconv='d%d = dlconv(d%d,params.CNW%d,params.CNb%d,"Stride",%d,"Padding","same");';
evaleak='d%d = leakyrelu(d%d,.2);';
evainst='d%d = instancenorm(d%d);';
for i = 1:5
    if i < 5
        eval(sprintf(evaconv,i,i-1,i,i,2))
    else
        eval(sprintf(evaconv,i,i-1,i,i,1))
    end
    eval(sprintf(evaleak,i,i))
    if i > 1
        eval(sprintf(evainst,i,i))
    end
end
dly = d5;
end