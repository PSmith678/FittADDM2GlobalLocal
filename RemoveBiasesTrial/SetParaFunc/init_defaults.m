function ret = init_defaults(ret,dataSelectorId, model_id, param_label)


ret = setModel(ret,model_id);

ret = setDataSelector(ret,dataSelectorId);

ret.model.loglikeFunc.name = 'logLike_kde';
ret.model.loglikeFunc.para.kdeThr = 0.02;
ret.model.loglikeFunc.para.prob_thres = 0.5;
ret.model.loglikeFunc.para.trials = 200;


ret.param_label = param_label;

if exist('param_label')
    filename = gen_docufilename(ret.model.name, ret.data.selector.label, ret.param_label, ret.uid);
    
    ret.filename = filename;
    if exist_docufile(filename)
        old = load(sprintf('./Docus/%s', filename));
        %    ret = old;
        if isfield(ret, 'old_ver')
            ret.old_ver{end+1} = old;
        else
            ret.old_ver{1} = old;
        end
    else
        ret.old_ver ={};
    end
else
    ret.filename = '';
    ret.old_ver ={};
end

ret.data.data = link_ModelData(ret.model, ret.data.selector);


ret.best.demcmc_para.outputfile = gen_demcmcoutputfile(ret.param_label, ret.model.name, ret.data.selector.label, ret.uid, 1);
ret.best.init_pop = [];
ret.best.res = [];

ret.post.demcmc_para.outputfile = gen_demcmcoutputfile(ret.param_label, ret.model.name, ret.data.selector.label, ret.uid, 2);
ret.post.res = [];
ret.post.init_pop = [];




%save_docufile(ret)
end


