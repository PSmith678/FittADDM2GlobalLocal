function out = mergeDocus(existingModels, newModel)
%
% copies all docu-files from source to the local repository. The process the
% the docu-files are appended to the current uid.

fprintf(1, 'Note that this function can be used only after the docu files from one branch are copied \n');
fprintf(1, 'into current branch, i.e. !git checkout <branch> Docus. This function will change the uids of the merged docus and append them to\n ');
fprintf(1, 'the existings uids (docu-files)\n.');
reply = input('Can you confirm that this is ok? Y/N [N]', 's');
if isempty(reply) || strcmp(reply, 'N')
return
end

global DOCUDIR


files = dir(sprintf('%s%s*_%s_*u*_docu.mat', DOCUDIR,filesep, newModel));

newUid = uid_lookuptable(files);

oldUids = [];
for iModels=1:length(existingModels)
    files = dir(sprintf('%s%s*_%s_*u*_docu.mat', DOCUDIR,filesep, existingModels{iModels}));
    uid = uid_lookuptable(files);
    oldUids = [oldUids uid];
end

nUid = length(newUid);

uidMax = length(oldUids);

kUid = 1;
for iUid=1:nUid
    if ~isempty(newUid{iUid})
        docu = load_docufile(char(newUid{iUid}));
        backupDocu = docu;
        docu.uid = uidMax + kUid;
        outFilename = gen_docufilename(docu.model.name, docu.data.selector.label, docu.param_label, docu.uid);
        docu.filename = outFilename;
        save_docufile(docu);
        delete_docufile(backupDocu);
        kUid = kUid + 1;
    end
    
end

end