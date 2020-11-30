%% Instance normalization
function dly = instancenorm(dlx)
% x_ijkt (SSCB) Dimension [WHCT]
mukt = sum(dlx,[1,2])/prod(size(dlx,[1,2]));
m = [1:size(dlx,1)]';
varkt=sum((dlx-m.*mukt).^2,[1,2])/prod(size(dlx,[1,2]));
dly = (dlx-mukt)./sqrt(varkt+eps);
end