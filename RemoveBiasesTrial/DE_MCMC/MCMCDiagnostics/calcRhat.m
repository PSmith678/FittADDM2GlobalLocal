function [rhat] = calcRhat(posterior)
%CALCRHAT Summary of this function goes here
%   Detailed explanation goes here

[bulkRhat] = calcRanksplitRhat(posterior);
[tailRhat] = calcFoldedsplitRhat(posterior);

rhat = max(bulkRhat, tailRhat);
end

