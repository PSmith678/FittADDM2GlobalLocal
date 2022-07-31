function ret = addDescrFuture(id, new_text)

docu = load_docu

n = length(docu.post.nfigure);
docu.post.nfigure{n}.caption2 = new_text;

ret = save_docufile(docu);
end