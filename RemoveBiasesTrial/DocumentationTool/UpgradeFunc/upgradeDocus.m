function safed_docu = upgradeDocus()

global DOCUDIR

lookuptable = uid_lookuptable();


for uidI=1:length(lookuptable)
    display(lookuptable(uidI))
    %    pause
    
    if ~isempty(lookuptable{uidI})
        docu = load_docufile(uidI);
        if isfield(docu.best, 'generations')
            docu.best.demcmc_para.generations = docu.best.generations;
            docu.best = rmfield(docu.best, 'generations');
        end
        if isfield(docu.post, 'generations')
            docu.post.demcmc_para.generations = docu.post.generations;
            docu.post = rmfield(docu.post, 'generations');
        end
        
        if isfield(docu.best.demcmc_para, 'transitionWeight')
            if ~isfield(docu.best.demcmc_para, 'transitionMethod')
                docu.best.demcmc_para.transitionMethod = {'Turner', docu.best.demcmc_para.transitionWeight(1), docu.best.demcmc_para.transitionWeight(2)};
            end
            docu.best.demcmc_para = rmfield(docu.best.demcmc_para, 'transitionWeight');
        end
        
        if isfield(docu.post.demcmc_para, 'transitionWeight')
            if ~isfield(docu.post.demcmc_para, 'transitionMethod')
                docu.post.demcmc_para.transitionMethod = {'Turner', docu.post.demcmc_para.transitionWeight(1), docu.post.demcmc_para.transitionWeight(2)};
            end
            docu.post.demcmc_para = rmfield(docu.post.demcmc_para, 'transitionWeight');
        end
        docu.demcmc_vers.minor = 0;
        docu.demcmc_vers.major = 2;
        docu.vers.minor = 0;
        docu.vers.major = 2;
        save_docufile(docu);
    end
end
end


