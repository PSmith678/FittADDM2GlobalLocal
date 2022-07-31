function ret = edit_descr(file_identifier, type_of_descr, new_text)
%
% ret = edit_descr(file_identifier, type_of_descr, new_text)
%

docu = load_docufile(file_identifier);

if isfield(docu.descr, type_of_descr)
    docu.descr = setfield(docu.descr,type_of_descr, new_text);
    ret = save_docufile(docu);
else
    error('type_of_descr does not exist');
end

end