%% progressplot
function progressplot(A,B,paramsGAB,paramsGBA)
%progressplot(APlot,BPlot,paramsGAB,paramsGBA)
fakeA = Generator(BPlot,paramsGBA);
fakeB = Generator(APlot,paramsGAB);
reconB = Generator(fakeA,paramsGAB);
reconA = Generator(fakeB,paramsGBA);

% fakeA = Generator(BPlot,paramsGBA);
% fakeB = Generator(AJPlot,paramsGAB);


fig = gcf;
if ~isempty(fig.Children)
    delete(fig.Children)
end

All = cat(4,APlot,fakeB,reconA,BPlot,fakeA,reconB);
% All = cat(4,APlot,fakeB,reconA,BPlot,fakeA,reconB);
I = imtile(gatext(All),'GridSize',[2,3]);
I = rescale(I);
imagesc(I)
colormap gray
set(gca,'visible','off')

drawnow;
end