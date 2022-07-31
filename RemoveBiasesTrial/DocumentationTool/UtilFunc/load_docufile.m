function [ret, warningFlag] = load_docufile(model_name, participant, param_label, uid, checkFlag)
%
% [ret, warningFlag] = load_docufile(model_name, participant, param_label, uid)
%
% no parameter loads the file with the hight uid from the Docu folder
%
% A single numeric parameter is interpreted as uid number and loads the
% corresponding file from the Docus folder
%
% If there model_name is a struct a fieldname docudir specifies an
% alternative docu folder
%
global DOCUDIR

if ~exist('model_name')
    n_uid = uid_lookuptable();
    model_name = char(n_uid{end});
end

if isnumeric(model_name)
    n_uid = uid_lookuptable();
    i = numel(n_uid);
    if i >= model_name
        model_name = char(n_uid{model_name});
    else
        error('version does not exist');
    end
% else
%     [~, ~, ext] = fileparts(model_name);
%     if isempty(ext)
%         model_name = sprintf('%s.mat', model_name);
%     end
    
end

if isstruct(model_name)
    folder = sprintf('%s%s%s',DOCUDIR,filesep,model_name.docudir);
    n_uid = uid_lookuptable(model_name.docudir);
    model_name = model_name.uid;
    model_name = char(n_uid{model_name});
else
    folder = DOCUDIR;
end


if nargin <= 2
    ret = load(sprintf('%s%s%s',folder,filesep, model_name));
end

if nargin > 2
    filename = gen_docufilename(model_name, participant, param_label, uid);
    ret = load(sprintf('%s%s%s.mat',folder,filesep,filename));
end

if nargin == 2 || nargin == 5
    if nargin == 2
        flag = participant;
    else
        flag =  checkFlag;
    end
else
    flag = 1;
end

if flag ~= 0
    warningFlag = checkDocustruct(ret);
else
    warningFlag = true;
end


end


