function [ESS] = calcBulkESS(posterior)

normalScores = calcNormalscores(posterior);

[ESS] = calcESS(normalScores);

end