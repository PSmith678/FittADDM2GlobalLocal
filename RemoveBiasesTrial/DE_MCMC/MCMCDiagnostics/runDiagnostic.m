function res = runDiagnostic(uid, varargin)
%https://github.com/avehtari/rhat_ess/blob/master/code/monitornew.R

docu = load_docufile(uid);
post_sampling = floor(docu.post.demcmc_para.generations * 0.75);
defaultDiagnostic = 'SplitRhat';
expectedDiagnostic = {'SplitRhat','ESS','BulkESS', 'FoldedsplitRhat', 'TailESS', 'plotRank'};

p = inputParser;
addOptional(p, 'sampling', post_sampling);
addParameter(p,'diagnostic',defaultDiagnostic,...
    @(x) any(validatestring(x,expectedDiagnostic)));
parse(p,uid,varargin{:});

if length(post_sampling) == 1
    sampling_cutoff = post_sampling;
    stepsize = 1;
else
    sampling_cutoff = post_sampling(1);
    stepsize = post_sampling(2);
    
end

% If more than one conditon then loop through 
nMulti = length(docu.post.res);

for iMulti = 1:nMulti
posterior = docu.post.res(iMulti).posterior;
posterior = rmSampleCutoff(posterior,sampling_cutoff, stepsize);

if strcmp(p.Results.diagnostic, 'SplitRhat') == 1
    [splitRhat, withinchainVariance, s, varPlus] = calcSplitRhat(posterior,1);
    res(iMulti,:) = splitRhat;
end

if strcmp(p.Results.diagnostic, 'ESS') == 1
    [res] = calcESS(posterior);
end

if strcmp(p.Results.diagnostic, 'BulkESS') == 1
    [splitRhat] = calcSplitRhat(posterior);
    res = calcBulkESS(posterior);
end

if strcmp(p.Results.diagnostic, 'FoldedsplitRhat') == 1
    res = calcFoldedsplitRhat(posterior);
end

if strcmp(p.Results.diagnostic, 'TailESS') == 1
    res = calcTailESS(posterior);
end

if strcmp(p.Results.diagnostic, 'plotRank') == 1
    h = plotRank(posterior, docu.model.variableName);
    res = plot(posterior, docu.model.variableName);
end


end