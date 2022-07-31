function docu = runTideDocu(uid,folder)
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
    if isempty(docu.post.res) == 1
        error('no posterior results present');
    end

    if isfield(docu.post.res(1), 'posterior') == false
        error('no posterior results present');
    end
else
    if isfield(docu.post.res(1), 'posterior') == false
        error('no posterior results present');
    end
end

if ~isfield(docu.data.selector, 'multiFits') || docu.data.selector.multiFits == 0
    docu = runSingleTide(docu);
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
    for iData=1:nData
        docu1.data.data = reshape(docu.data.data(:,iData), nSizeData(1:end-1));
        docu1.post.res =  docu1.post.res(iData);
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
            docu1 = runSingleTide(docu1);
            docu.post.res(iData).marginal = docu1.post.res.marginal;
            
        end
        save_docufile(docu);
        docu1 = docu2;
    end
end


end
% ----------------------------------------------------------------------------------------------------------------------



function ret = runSingleTide(docu)
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
              [marginalLikelihood,tidePop,tideGof] = runTide(@(x) feval(docu.model.loglikeFunc.name, call_name,x, docu.para_rules, docu.model.loglikeFunc.para, docu.data.data), ...
                docu.best.bounds.values, squeeze(docu.post.res.posterior(end,:,:)),'boundedUniform','nGenerations', ...
                docu.best.demcmc_para.generations,'showProgress',docu.best.demcmc_para.showProgress_steps,'saveResults',...
                {docu.best.demcmc_para.showProgress_steps, docu.best.demcmc_para.outputfile}, 'transitionMethod', docu.best.demcmc_para.transitionMethod, ...
                'groupSize', docu.best.demcmc_para.groupSize,'resampleProb',docu.best.demcmc_para.resampleProb);
else  
     [marginalLikelihood,tidePop,tideGof] = runTide(@(x) feval(docu.model.loglikeFunc.name,call_name,x, docu.para_rules, docu.model.loglikeFunc.para, docu.data.data), ...
        {2 docu.best.bounds.callPdf}, squeeze(docu.post.res.posterior(end,:,:)),'customPrior',docu.best.bounds.callRnd ,docu.best.demcmc_para.parallel_flag,'nGenerations', ...
        docu.best.demcmc_para.generations,'showProgress',docu.best.demcmc_para.showProgress_steps,'saveResults',...
        {docu.best.demcmc_para.showProgress_steps, docu.best.demcmc_para.outputfile}, 'transitionMethod', docu.best.demcmc_para.transitionMethod, ...
        'groupSize', docu.best.demcmc_para.groupSize,'resampleProb',docu.best.demcmc_para.resampleProb);
end

ret = docu;
ret.post.res.marginal = marginalLikelihood;
ret.post.res.tidePop = tidePop;
ret.post.res.tideGof = tideGof;

end
