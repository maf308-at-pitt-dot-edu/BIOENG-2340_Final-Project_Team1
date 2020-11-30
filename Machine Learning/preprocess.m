%% preprocess
function x = preprocess(x)
% x = double(x)/255;
x = (x-.5)/.5;
x = reshape(x,128,128,1,[]);
end