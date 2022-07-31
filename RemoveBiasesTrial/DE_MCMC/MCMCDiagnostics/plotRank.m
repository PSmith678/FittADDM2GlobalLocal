function h = plotRank(posterior, paraNames)


[generations, nChain, nParam] = size(posterior);

for iParam = 1:nParam
    h = figure;
    h2 = squeeze(posterior(:,:,iParam));
    [~, rankPosterior] = calcNormalscores(h2);

    for iChain=1:nChain
        subplot(nChain/5, 5, iChain)
        h1 = rankPosterior(:,iChain,1);
        hist(h1(:))
        xticklabels({});
        yticklabels({});
    end
    suptitle(char(paraNames{iParam}));
end

end