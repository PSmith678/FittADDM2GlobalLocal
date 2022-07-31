function h= plotIterative(uid, measure, post_sampling,draws)

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
[generations, nChain, nParam] = size(posterior);

res = nan(length(draws),1);
for iParam=1:nParam
    subplot(nParam, 1, iParam);
    for iDraw=1:length(draws)
        post1 = squeeze(posterior(1:draws(iDraw),:,iParam));
        eval(sprintf('res(iDraw) = %s(post1);', measure));
    end
    plot(draws,res, '-x');
    title(docu.model.variableName{iParam});

    drawnow
end
xlabel('number of draws');

end