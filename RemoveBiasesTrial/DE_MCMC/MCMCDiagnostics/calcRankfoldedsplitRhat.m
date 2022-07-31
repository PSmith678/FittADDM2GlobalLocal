function [splitRhat, withinchainVariance, sm, varPlus] = calcRankfoldedsplitRhat(posterior, splitFlag)

if exist('splitFlag') == 0
    splitFlag = 1;
end
med = median(posterior(:));
dev = abs(posterior - med);

[splitRhat, withinchainVariance, sm, varPlus] = calcRanksplitRhat(dev, splitFlag);
end