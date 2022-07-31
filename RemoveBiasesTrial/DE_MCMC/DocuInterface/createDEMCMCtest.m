function ret = createDEMCMCtest(DEMCMCvers,uid, oldDEMCMCvers, post_best_flag)

global DEMCMCpara

if ~exist('oldDEMCMCvers')
    DEMCMCpara = [];
else
    DEMCMCpara = oldDEMCMCvers;
end



if exist('uid')
    ret = load_docufile(uid);
else
    ret = load_docufile;
end

if post_best_flag == 1
    ret = deletePost(ret, 1);
else
    ret = deleteData(ret, 1);
    ret.uid = length(uid_lookuptable())+1;
end


ret1 = setDEMCMC(ret,DEMCMCvers);

if post_best_flag == 1
    if ret1.post.demcmc_para.groupSize < ret1.best.demcmc_para.groupSize
        ret = reduceChains(ret1, ret1.post.demcmc_para.groupSize);
    end
    if ret1.post.demcmc_para.groupSize == ret1.best.demcmc_para.groupSize
        ret = ret1;
    end
    
    if ret1.post.demcmc_para.groupSize > ret1.best.demcmc_para.groupSize
        error('not enough chain from greedy sampling available');
    end
end



DEMCMCpara = DEMCMCvers;

ret.filename = gen_docufilename(ret.model.name, ret.data.selector.label, ret.param_label, ret.uid);
ret.best.demcmc_para.outputfile = gen_demcmcoutputfile(ret.param_label, ret.model.name, ret.data.selector.label, ret.uid, 1);
ret.post.demcmc_para.outputfile = gen_demcmcoutputfile(ret.param_label, ret.model.name, ret.data.selector.label, ret.uid, 2);
save_docufile(ret);
DEMCMCpara = [];

end
