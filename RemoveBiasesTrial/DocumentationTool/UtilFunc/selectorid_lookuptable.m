function [selectorIds, uidTable] = selectorid_lookuptable(selectorLabels)

uid_start = '\d+[_][d][o][c][u]';
uid_end = '[_][d][o][c][u]';

global DOCUDIR

uidTable = uid_lookuptable();

nFile = length(uidTable);

NselectorLabels = length(selectorLabels);
selectorIds = nan(nFile,1);
for iModel=1:NselectorLabels
    modelnameStart = sprintf('_%s_',char(selectorLabels{iModel}));
    list_uid_start = contains(uidTable,modelnameStart);
    selectorIds(list_uid_start) = iModel;
    
end

end