function docu = runFitting(uid, folder)
%
% ret = runFitting(docu_identifier)
%
% 'docu_identifier' - can be either a UID or a filename
%

%dbstop if error

if exist('folder')
    h(length(uid)) = struct('docudir', [], 'uid', []);
    
    for i=1:length(uid)
        h(i).docudir = folder;
        h(i).uid = uid(i);
        
    end
    uid = h;
end




rng('default');
delete(gcp('nocreate'));


slurmID = getenv('SLURM_JOB_ID');
if ~isempty(slurmID)
    cl = parcluster();
    storage_folder = strcat('./matlabtemp/', slurmID);
    mkdir(storage_folder)
    cl.JobStorageLocation = storage_folder;
    parpool(cl);
    
    
else
    pool = parpool('IdleTimeout', 60);
end







% p = gcp


docu = load_docufile(uid);

if ~isfield(docu.data.selector, 'multiFits') || docu.data.selector.multiFits == 0
    docu = runBestPosterior(docu);
    save_docufile(docu);
    
else
    nSizeData = nan(ndims(docu.data.data),1);
    nSizeData = size(docu.data.data);
    nData = nSizeData(end);
    if length(nSizeData) == 2
        nSizeData = [1 nSizeData];
    end
    docu1 = docu;
    docu2 = docu;
    docu1.post.res = struct('posterior', [], 'gof_post', [], 'ar_post', [], 'modTimes', {});
    docu1.best.res = struct('bp', [], 'bg', 0.0, 'ar', [], 'finalPop', [], 'finalgof', [], 'modTimes', {});
    docu.post.res = struct('posterior', [], 'gof_post', [], 'ar_post', [], 'modTimes', {});
    if docu.post_from_best == 0
        docu.best.res = struct('bp', [], 'bg', 0.0, 'ar', [], 'finalPop', [], 'finalgof', [], 'modTimes', {});
    end
    for iData=1:nData
        docu1.data.data = reshape(docu.data.data(:,iData), nSizeData(1:end-1));
        %        docu1.post.bounds = [];
        %        docu1.best.bounds = [];
        docu1.post.res = struct('posterior', [], 'gof_post', [], 'ar_post', [], 'modTimes', {});
        docu1.best.res = struct('bp', [], 'bg', 0.0, 'ar', [], 'finalPop', [], 'finalgof', [], 'modTimes', {});
        if docu.post_from_best == 1
            if length(docu.best.res) == nData
                docu1.best.res = docu.best.res(iData);
                if length(docu.best.bounds) > 1
                    docu1.best.bounds = docu.best.bounds{iData};
                    docu1.post.bounds = docu.post.bounds{iData};
                end
                docu1 = runBestPosterior(docu1);
                docu.post.res(iData) = docu1.post.res;
            else
                error('not enough best results');
            end
        else
            if length(docu.post.bounds) > 1
                docu1.post.bounds = docu.post.bounds{iData};
                docu1.best.bounds = docu.best.bounds{iData};
            end
            docu1 = runBestPosterior(docu1);
            docu.best.res(iData) = docu1.best.res;
            docu.post.res(iData) = docu1.post.res;
            
        end
        save_docufile(docu);
        docu1 = docu2;
    end
end


end
% ----------------------------------------------------------------------------------------------------------------------

function docu = runBestPosterior(docu)

if docu.post_from_best == 0
    
    if isempty(docu.best.res) == 1
        
        startDate = datestr(now);
        ret = run_BestParameterSearch(docu);
        
        docu.best.res = ret;
        docu.best.res.modTimes = {startDate, datestr(now)};
    else
        error('best is already determined.');
    end
end

if isempty(docu.post.res) == 1
    if ~isempty(docu.best.res)
        startDate = datestr(now);
        docu.post.init_pop = docu.best.res.finalPop;
        ret = run_Posterior(docu);
        
        docu.post.res = ret;
        docu.post.res.modTimes = {startDate, datestr(now)};
    else
        error('best best fit detemined');
    end
else
    error('best fit and posterior already determined');
end

end

% ----------------------------------------------------------------------------------------------------------------------

function ret = run_BestParameterSearch(docu)
%
% ret = run_BestParameterSearch(model, bounds, generations, init_pop, data, para_rules, demcmc_para)
%

call_name = sprintf('run_%s', docu.model.name);

if ~isfield(docu.best.demcmc_para, 'transitionMethod')
    docu.best.demcmc_para.best.transitionMethod = {'Turner', docu.best.demcmc_para.transitionWeight(1), docu.best.demcmc_para.transitionWeight(2)};
    docu.best.demcmc_para.best.transitionMethod = {'Braak'};
    
end
if ~isfield(docu.post.demcmc_para, 'transitionMethod')
    docu.best.demcmc_para.post.transitionMethod = {'Turner', docu.post.demcmc_para.transitionWeight(1), docu.post.demcmc_para.transitionWeight(2)};
    docu.best.demcmc_para.best.transitionMethod = {'Braak'};
end

if strcmp(docu.post.bounds.type, 'uniform')
    if isempty(docu.best.init_pop)
        if isfield(docu.best, 'init') && ~isempty(docu.best.init)
            for i=1:docu.best.demcmc_para.groupSize
                delta = (1+0.1*(rand(1,length(docu.best.init)) - 0.5));
                init(i,:) = docu.best.init.*delta;
            end
            [bp, bg, ar, finalPop, finalgof] = de_mcmc(@(x) feval(docu.model.loglikeFunc.name, call_name,x, docu.para_rules, docu.model.loglikeFunc.para, docu.data.data), ...
                docu.best.bounds.values,'boundedUniform', 'OnlyBestSearch',docu.best.demcmc_para.parallel_flag,'initParams', init, 'nGenerations', ...
                docu.best.demcmc_para.generations,'showProgress',docu.best.demcmc_para.showProgress_steps,'saveResults',...
                {docu.best.demcmc_para.showProgress_steps, docu.best.demcmc_para.outputfile}, 'transitionMethod', docu.best.demcmc_para.transitionMethod, ...
                'groupSize', docu.best.demcmc_para.groupSize,'resampleProb',docu.best.demcmc_para.resampleProb);
        else
            [bp, bg, ar, finalPop, finalgof] = de_mcmc(@(x) feval(docu.model.loglikeFunc.name, call_name,x, docu.para_rules, docu.model.loglikeFunc.para, docu.data.data), ...
                docu.best.bounds.values,'boundedUniform', 'OnlyBestSearch',docu.best.demcmc_para.parallel_flag,'nGenerations', ...
                docu.best.demcmc_para.generations,'showProgress',docu.best.demcmc_para.showProgress_steps,'saveResults',...
                {docu.best.demcmc_para.showProgress_steps, docu.best.demcmc_para.outputfile}, 'transitionMethod', docu.best.demcmc_para.transitionMethod, ...
                'groupSize', docu.best.demcmc_para.groupSize,'resampleProb',docu.best.demcmc_para.resampleProb);
        end
    else
        [bp, bg, ar, finalPop, finalgof] = de_mcmc(@(x) feval(docu.model.loglikeFunc.name,call_name,x, docu.para_rules, docu.model.loglikeFunc.para, docu.data.data), ...
            docu.best.bounds.values,'boundedUniform', 'OnlyBestSearch','initParams', docu.best.init_pop, docu.best.demcmc_para.parallel_flag,'nGenerations', ...
            docu.best.demcmc_para.generations,'showProgress',docu.best.demcmc_para.showProgress_steps,'saveResults',...
            {docu.best.demcmc_para.showProgress_steps, docu.best.demcmc_para.outputfile}, 'transitionMethod', docu.best.demcmc_para.transitionMethod, ...
            'groupSize', docu.best.demcmc_para.groupSize,'resampleProb',docu.best.demcmc_para.resampleProb);
        
    end
else
    
    [bp, bg, ar, finalPop, finalgof] = de_mcmc(@(x) feval(docu.model.loglikeFunc.name,call_name,x, docu.para_rules, docu.model.loglikeFunc.para, docu.data.data), ...
        {2 docu.best.bounds.callPdf},'customPrior',docu.best.bounds.callRnd , 'OnlyBestSearch',docu.best.demcmc_para.parallel_flag,'nGenerations', ...
        docu.best.demcmc_para.generations,'showProgress',docu.best.demcmc_para.showProgress_steps,'saveResults',...
        {docu.best.demcmc_para.showProgress_steps, docu.best.demcmc_para.outputfile}, 'transitionMethod', docu.best.demcmc_para.transitionMethod, ...
        'groupSize', docu.best.demcmc_para.groupSize,'resampleProb',docu.best.demcmc_para.resampleProb);
end

ret.bp = bp;
ret.bg = bg;
ret.ar = ar;
ret.finalPop = finalPop;
ret.finalgof = finalgof;

end

% ----------------------------------------------------------------------------------------------------------

function ret = run_Posterior(docu)
%
% ret = run_Posterior(model, bounds, demcmc_para.generations, init_pop, data, para_rules, demcmc_para)
%

call_name = sprintf('run_%s', docu.model.name);


if strcmp(docu.post.bounds.type, 'uniform')
    [posterior, gof_post, ar_post] = de_mcmc(@(x) feval(docu.model.loglikeFunc.name,call_name,x, docu.para_rules, docu.model.loglikeFunc.para, docu.data.data), ...
        docu.post.bounds.values,'boundedUniform', 'OnlyPosterior', docu.post.init_pop,docu.post.demcmc_para.parallel_flag,'nGenerations', ...
        docu.post.demcmc_para.generations,'showProgress',docu.post.demcmc_para.showProgress_steps,'saveResults',...
        {docu.post.demcmc_para.showProgress_steps, docu.post.demcmc_para.outputfile},'transitionMethod', docu.post.demcmc_para.transitionMethod, ...
        'groupSize', docu.post.demcmc_para.groupSize,'resampleProb',docu.post.demcmc_para.resampleProb);
else
    [posterior, gof_post, ar_post] = de_mcmc(@(x) feval(docu.model.loglikeFunc.name,call_name,x, docu.para_rules, docu.model.loglikeFunc.para, docu.data.data), ...
        {2 docu.post.bounds.callPdf},'customPrior', 'OnlyPosterior', docu.post.init_pop,docu.post.demcmc_para.parallel_flag,'nGenerations', ...
        docu.post.demcmc_para.generations,'showProgress',docu.post.demcmc_para.showProgress_steps,'saveResults',...
        {docu.post.demcmc_para.showProgress_steps, docu.post.demcmc_para.outputfile},'transitionMethod', docu.post.demcmc_para.transitionMethod, ...
        'groupSize', docu.post.demcmc_para.groupSize,'resampleProb',docu.post.demcmc_para.resampleProb);
    
end

ret.posterior = posterior;
ret.gof_post = gof_post;
ret.ar_post = ar_post;
end

