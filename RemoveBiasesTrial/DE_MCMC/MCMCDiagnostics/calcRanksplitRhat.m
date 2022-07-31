function [splitRhat, withinchainVariance, sm, varPlus] = calcRanksplitRhat(posterior)

normalScores = calcNormalscores(posterior);

[splitRhat, withinchainVariance, sm, varPlus] = calcSplitRhat(normalScores);

end