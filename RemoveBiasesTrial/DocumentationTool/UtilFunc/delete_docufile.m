function ret = delete_docufile(data)
% flag zero means not checking

global DOCUDIR


eval(sprintf('''delete %s%s%s.mat'';',DOCUDIR, filesep, data.filename));


end
