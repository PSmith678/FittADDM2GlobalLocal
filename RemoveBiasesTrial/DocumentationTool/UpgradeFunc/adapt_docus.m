function safed_docu = adapt_docus(uid)

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
    safed_docu.data.selector = selectors.nSelector{selectorId(uid_i)};
    out_filename = gen_docufilename(safed_docu.model.name, safed_docu.data.selector.label, safed_docu.param_label, uid_i);
    safed_docu.filename = out_filename;
       save(sprintf('%s%s',DOCUDIR, safed_docu.filename), '-struct', 'safed_docu');
end

end


