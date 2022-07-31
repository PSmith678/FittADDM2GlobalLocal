function [splitRhat, withinchainVariance, sm, varPlus] = calcSplitRhat(posterior, splitFlag)

if exist('splitFlag') == 0
    splitFlag = 1;
end


if splitFlag == 1
    chains = genSplitchain(posterior);
else
    chains = posterior;
end

[N, M, nParam] = size(chains);
% generations    chains
sm = nan(1,nParam);

splitRhat= nan(1,nParam);
withinchainVariance=nan(1,nParam);
sm = nan(nParam, M);
varPlus = nan(1,nParam);

for iParam=1:nParam
    [splitRhat(iParam), withinchainVariance(iParam), sm(iParam,:), varPlus(iParam)] = calcSplitRhatParam(squeeze(chains(:,:,iParam)));
end


end

function [splitRhat, W, sm, varPlus] = calcSplitRhatParam(chainParam)

[N, M] = size(chainParam);
% generations    chains

totalTheta = mean(chainParam(:));
thetam = mean(chainParam,1);
B = N / (M-1) * sum((thetam - totalTheta).^2);

for iChain=1:M
    sm(iChain) = 1 / (N - 1) * sum((chainParam(:,iChain) - thetam(iChain)).^2);
end

W =  mean(sm);
varPlus = (N - 1) / N * W + 1 / N * B;
splitRhat = sqrt(varPlus / W);

end

