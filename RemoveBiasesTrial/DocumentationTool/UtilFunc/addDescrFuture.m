function ret = addDescrFuture(id, new_text)

docu = load_docufile(id, 0);

if ~isempty(docu.descr.future)
    docu.descr.future = sprintf('%s; %s', docu.descr.future, new_text);
else
    docu.descr.future = new_text;
end

ret = save_docufile(docu, 0);
end