function ret = finalizeDEMCMCpara(uid, demcmcid)


global DEMCMCpara
DEMCMCpara = demcmcid;

docu = load_docufile(uid);


docu.versPointers.parent = uid;
docu.post.res=[];
docu.best.res=[];
docu.post_from_best = 0;
docu.uid = length(uid_lookuptable())+1;

% adds a decription to the parent fit
addDescrFuture(docu.versPointers.parent, 'There must be a word-file explainig why these parameters were chosen.');
add_child(docu.data.selector.label, docu.model.name, uid, docu.param_label, docu.param_label, docu.versPointers.parent);

DEMCMCpara = [];
docu.filename = gen_docufilename(docu.model.name, docu.data.selector.label, docu.param_label, docu.uid);
docu.post.demcmc_para.outputfile = gen_demcmcoutputfile(docu.param_label, docu.model.name, docu.data.selector.label, docu.uid, 2);

save_docufile(docu);
