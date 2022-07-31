function res= plotQuantilESS(uid, post_sampling,quants)

if isscalar(uid)
    docu = load_docufile(uid);
    posterior = docu.post.res.posterior;
    if length(post_sampling) == 1
        sampling_cutoff = post_sampling;
        stepsize = 1;
    else
        sampling_cutoff = post_sampling(1);
        stepsize = post_sampling(2);
        
    end
    
    posterior = rmSampleCutoff(posterior,sampling_cutoff, stepsize);
else
    posterior = uid;
    docu.model.variableName={'param1', 'param2'};
end
[generations, nChain, nParam] = size(posterior);


res = nan(length(quants),nParam);
for iQuants=1:length(quants)
    res(iQuants,:) = calcQuantilESS(posterior, quants(iQuants));
end

for iParam=1:nParam
    subplot(nParam,1,iParam);
    plot(quants,res(:,iParam), '-x');
    title(docu.model.variableName{iParam});
end


xlabel('Quantils');

end