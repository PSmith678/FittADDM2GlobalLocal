function out = mergeRepository(source)
%
% copies all docu-files from source to the local repository. The process the
% the docu-files are appended to the current uid.

sourceUid = uid_lookuptable(source);
nUid = length(sourceUid);

targetUid = uid_lookuptable();
uidMax = length(targetUid);

kUid = 1;
for iUid=1:nUid
    sourceDocu.docudir= source;
    if ~isempty(sourceUid{iUid})
        sourceDocu.uid= iUid;
        docu = load_docufile(sourceDocu);
        docu.uid = uidMax + kUid;
        outFilename = gen_docufilename(docu.model.name, docu.data.selector.label, docu.param_label, docu.uid);
        docu.filename = outFilename;
        save_docufile(docu);
        kUid = kUid + 1;
    end
    
end