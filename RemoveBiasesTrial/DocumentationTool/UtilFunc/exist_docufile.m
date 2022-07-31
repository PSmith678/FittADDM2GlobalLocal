function [ret, name] = exist_docufile(filename)
%
% ret = exist_docufile(file_identifier)
%
global DOCUDIR

name = [];
if isnumeric(filename)
    n_uid = uid_lookuptable();
    if filename > length(n_uid) || isempty(n_uid{filename}) 
        ret = 0;
    else
        ret = 2;
        name = n_uid{filename};
    end
else
    name = sprintf('%s%s%s.mat',DOCUDIR, filesep, filename);
    ret = exist(name, 'file');
    
end