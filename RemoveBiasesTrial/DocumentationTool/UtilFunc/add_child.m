function ret = add_child(participant, model_name, uid, param_label, parent_simuname, parent_version)

ret = 0;
filename = gen_docufilename(model_name, participant, parent_simuname,parent_version);
if exist_docufile(filename)
    ret = 1;
    parent = load_docufile(filename, 0);
    save_flag = 0;
    if ismember(parent.versPointers.children, uid) == 1
        warning('Parent has already this child registered');
    else
        parent.versPointers.children = [parent.versPointers.children uid];
        save_flag = 1;
    end
    
    if ismember(parent.versPointers.children_param_label, param_label) == 1
        warning('Parent has already this child registered');
    else
        parent.versPointers.children_param_label{end+1} = param_label;
        save_flag = 1;
    end
    
    if save_flag == 1
        save(sprintf('.%sDocus%s%s',filesep,filesep, filename), '-struct', 'parent');
    end
end
if ret == 0
    error('Was not able to add child to parent');
end
end