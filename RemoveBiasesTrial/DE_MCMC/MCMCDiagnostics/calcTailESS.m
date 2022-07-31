function res = calcTailESS(posterior)


[generations, nChain, nParam] = size(posterior);

for iParam=1:nParam
    post1 = squeeze(posterior(:,:,iParam));
    q05 = quantile(post1(:), 0.05);
    post205 = post1 < q05;
        
    q95 = quantile(post1(:), 0.95);
    post295 = post1 < q95;
    res(iParam) = min(calcESS(post205), calcESS(post295));
end
end