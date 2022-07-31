function [ESS] = calcESS(chains)
% There is no split for tje correlation part.
%
[splitRhat, withinchainVariance, s, varPlus] = calcSplitRhat(chains);

posterior = genSplitchain(chains);


[generations, nChain, nParam] = size(posterior);

ESS  = nan(nParam,1);

for iParam=1:nParam
    ESS(iParam) = calcESSParam(squeeze(posterior(:,:,iParam)), splitRhat(iParam), withinchainVariance(iParam), s(iParam,:), varPlus(iParam));
end
end

function ESS = calcESSParam(posterior, splitRhat, withinchainVariance, s, varPlus)

[generations, nChain] = size(posterior);

P(1) = 1;
t = 1;
P(1) = calcCombindedAutocorr(withinchainVariance, posterior, s, varPlus, 2*(t-1));
t = t + 1;
P(t) = calcCombindedAutocorr(withinchainVariance, posterior, s, varPlus, 2*(t-1)+1);

while P(t-1) + P(t) > 0 && t < generations
    %    P(t)
    t = t + 1;
    % even
    P(t) = calcCombindedAutocorr(withinchainVariance, posterior, s, varPlus, t);
    t = t + 1;
    % odd
    P(t) =  calcCombindedAutocorr(withinchainVariance, posterior, s, varPlus, t);
end

if P(end-1)>0
      P(end + 1) = P(end-1);
end


for t=2:2:length(P)-3
    if P(t + 1) + P(t + 2) > P(t - 1) + P(t)
        P(t + 1) = (P(t - 1) + P(t)) / 2;
        P(t + 2) = P(t + 1);
    end
    
end

tau = -1 + 2 * sum(P(1:end-1)) + P(end);

ESS = (nChain * generations) / tau;

end

function res = calcCombindedAutocorr(withinchainVariance, post, s, varPlus, lag)

[generations, nChain] = size(post);
sum1 = 0;
mlag = 2*generations;

% cov or corr
% it works with cov but not sure if this is correct.
for iChain=1:nChain
    allcorr = xcov(squeeze(post(:,iChain)), mlag, 'coeff');
    %    allcorr = xcov(squeeze(post(:,iChain)),2*generations);
    sum1 = sum1 + (s(iChain) * allcorr(mlag+lag+1));
end

res = 1 - (withinchainVariance - (sum1  / nChain)) / varPlus;

end
