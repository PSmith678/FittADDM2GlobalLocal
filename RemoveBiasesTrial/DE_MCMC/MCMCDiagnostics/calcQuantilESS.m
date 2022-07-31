function res = calcQuantilESS(posterior, quant)


if exist('splitFlag') == 0
    splitFlag = 1;
end

if splitFlag == 1
    posterior = genSplitchain(posterior);
end

[generations, nChain, nParam] = size(posterior);

for iParam=1:nParam
    post1 = squeeze(posterior(:,:,iParam));
    thres = quantile(post1(:), quant);
    post2 = double(post1 < thres);
    res(iParam) = calcESS(post2);
end
end