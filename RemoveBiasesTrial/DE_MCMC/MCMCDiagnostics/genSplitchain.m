function [ret] = genSplitchain(posterior)
%GENSPLITCHAIN Summary of this function goes here
%   Detailed explanation goes here

[generations, nChain, nParam] = size(posterior);
ret = nan(generations/2, nChain*2, nParam);
for j=1:nParam
    for i=1:nChain
        post1 = squeeze(posterior(:,i,j));
        ret(:,i,j) = post1(1:generations/2);
        ret(:,i+nChain,j) = post1(generations/2+1:end);
    end
end
end

