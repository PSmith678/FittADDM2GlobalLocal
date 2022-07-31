function ret = addInit(uid, initValues)

docu = load_docufile(uid);

docu.best.init = initValues;
save_docufile(docu);
end


