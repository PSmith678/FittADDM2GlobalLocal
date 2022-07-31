function safed_docu = add_versPointers(uid)

global DOCUDIR

if ~exist('uid')
    lookuptable = uid_lookuptable();
end

selectorId = [10, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1];
selectors = load_selectors();

for uid_i=1:length(lookuptable)
    display(lookuptable(uid_i))
    %    new_docu = set_save_param(uid(uid_i), 1);
    safed_docu = load_docufile(uid_i);
    safed_docu.versPointers.parent = safed_docu.parent;
    safed_docu.versPointers.parent_param_label=safed_docu.parent_param_label;
    
    safed_docu.versPointers.best_parent =  safed_docu.best_parent;
    safed_docu.versPointers.best_parent_param_label=safed_docu.best_parent_param_label;
    
    safed_docu.versPointers.children = safed_docu.children;
    safed_docu.versPointers.children_param_label = safed_docu.children_param_label;
    safed_docu = rmfield(safed_docu, {'parent', 'parent_param_label','best_parent','best_parent_param_label', 'children', 'children_param_label'});
    save(sprintf('%s%s%s',DOCUDIR, filesep,safed_docu.filename), '-struct', 'safed_docu');
end

end


