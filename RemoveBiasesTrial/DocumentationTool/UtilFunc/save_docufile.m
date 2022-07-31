function ret = save_docufile(data, flag)
% flag zero means not checking

global DOCUDIR

if ~exist('flag')
    ret = checkDocustruct(data);
else
    ret = true;
end

data.modTimes{end+1} = datestr(now);

lookuptable = uid_lookuptable();

i = find(strcmp(lookuptable, sprintf('%s.mat', data.filename)) == 1);

if isempty(i) 
 %&& length(lookuptable) + 1 == data.uid
    save(sprintf('%s%s%s',DOCUDIR, filesep, data.filename), '-struct', 'data');
    return;
end

if data.uid == i && strcmp(sprintf('%s.mat', data.filename), char(lookuptable{i})) == 1
    save(sprintf('%s%s%s',DOCUDIR, filesep,data.filename), '-struct', 'data');
else
    error('Inconsistency of uid in struct with uid in filename');
    ret = false;
end
