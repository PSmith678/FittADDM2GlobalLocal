function uid_table = uid_lookuptable(folder)

% global DEMCMCpara
%
% if isempty(DEMCMCpara)
%     uid_start = '\d+[_][d][o][c][u]';
%     uid_end = '[_][d][o][c][u]';
%     ending = 'docu';
% else
%     h1 = num2str(DEMCMCpara);
%     ssum = '\d+[_][d][e][';
%     for i=1:length(h1)
%         ssum=sprintf('%s%c][',ssum,h1(i));
%     end
%     uid_start=sprintf('%s',ssum(1:end-1));
%
%     ssum = '[_][d][e][';
%     for i=1:length(h1)
%         ssum=sprintf('%s%c][',ssum,h1(i));
%     end
%     uid_end=sprintf('%s',ssum(1:end-1));
%     ending = sprintf('de%d',DEMCMCpara);
%
% end

% global DEMCMCpara
%
% if isempty(DEMCMCpara)
uid_start = '\d+[_][d]';
%    uid_end = '[_][d][o][c][u]';
%     ending = 'docu';
% else
%     h1 = num2str(DEMCMCpara);
%     ssum = '\d+[_][d][e][';
%     for i=1:length(h1)
%         ssum=sprintf('%s%c][',ssum,h1(i));
%     end
%     uid_start=sprintf('%s',ssum(1:end-1));
%
%     ssum = '[_][d][e][';
%     for i=1:length(h1)
%         ssum=sprintf('%s%c][',ssum,h1(i));
%     end
%     uid_end=sprintf('%s',ssum(1:end-1));
%     ending = sprintf('de%d',DEMCMCpara);
%
% end

uid_table = [];
global DOCUDIR

if ~exist('folder')
    files = [dir(sprintf('%s%s*u*_docu.mat', DOCUDIR,filesep)); dir(sprintf('%s%s*u*_de*.mat', DOCUDIR,filesep))];
    %   files = dir(sprintf('%s%s*u*_%s.mat', DOCUDIR,filesep,ending));
else
    if ~isstruct(folder)
        files = dir(sprintf('%s%s%s%s*u*_docu.mat', DOCUDIR,filesep, folder,filesep));
    else
        files = folder;
    end
end

list_files = {files(:).name};

list_uid_start = regexp(list_files,uid_start, 'start');
%uid_table = cell(length(list_files)-1,1);

for i=1:length(list_files)
    s = list_files{i}(list_uid_start{i}:end);
    if strcmp(s(end-6:end), 'old.mat') ~= 1
        j = sscanf(char(s), '%d');
        uid_table{j} = list_files{i};
    end
end

end