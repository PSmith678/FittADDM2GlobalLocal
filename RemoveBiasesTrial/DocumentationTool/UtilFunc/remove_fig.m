function ret = remove_fig(file_identifier, fig_id)

docu = load_docufile(file_identifier);

if ~exist('fig_id')
fig_id = length(docu.post.nfigure);
end

docu.post.nfigure(fig_id) = [];

ret = save_docufile(docu);

end