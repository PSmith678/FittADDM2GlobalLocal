function res = rmSampleCutoff(posterior,sampling_cutoff, stepsize)

if ~exist('stepsize')
    stepsize = 1;
end

[generations, nChain, nParam] = size(posterior);
res = nan(sampling_cutoff/stepsize, nChain, nParam);

for j=1:nParam
    for i=1:nChain
        post1 = squeeze(posterior(:,i,j));
        res(:,i,j) = post1(end-sampling_cutoff+1:stepsize:end);
    end
end
end
