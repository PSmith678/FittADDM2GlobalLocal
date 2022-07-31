function h = plotChains(posterior, nChains, seed)

if ~exist('seed') == 0
    seed = 1;
end
rng(seed);

[generations, nChain, nParam] = size(posterior);

iChains = randi(nChain,nChains,1);
post = posterior(:,[iChains],:);

for iParam=1:nParam
    subplot(nParam,1,iParam);
    for iChain=1:nChains
        plot(post(:,iChain,iParam)); hold on
    end
end
end