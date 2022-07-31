function safed_docu = addMultiFits(multifits)

global DOCUDIR


lookuptable = uid_lookuptable();

for uid_i=1:length(lookuptable)
    display(lookuptable(uid_i))
    %    new_docu = set_save_param(uid(uid_i), 1);
    safed_docu = load_docufile(uid_i);
    safed_docu.data.selector.multiFits = multifits;
    
    save(sprintf('%s%s%s',DOCUDIR, filesep,safed_docu.filename), '-struct', 'safed_docu');
end

end