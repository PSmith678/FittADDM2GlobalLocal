function [normalScores, rankPosterior] = calcNormalscores(posterior)

h1 = posterior(:);
S = length(h1);

h2 = tiedrank(h1);
rankPosterior = reshape(h2,size(posterior));

normalScores = norminv((rankPosterior - 3/8) / (S-1/4));
end