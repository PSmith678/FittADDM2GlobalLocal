function [nModelid, uidTable] = modelid_lookuptable(nModelname)

uid_start = '\d+[_][d][o][c][u]';
uid_end = '[_][d][o][c][u]';

global DOCUDIR

uidTable = uid_lookuptable();

nFile = length(uidTable);

nModel = length(nModelname);
nModelid = nan(nFile,1);
for iModel=1:nModel
    modelnameStart = sprintf('_%s_',char(nModelname{iModel}));
    list_uid_start = contains(uidTable,modelnameStart);
    nModelid(list_uid_start) = iModel;
    
end

end