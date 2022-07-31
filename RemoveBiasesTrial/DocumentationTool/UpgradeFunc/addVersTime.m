function safed_docu = addVersTime(uid)

global DOCUDIR


if ~exist('uid')
    lookuptable = uid_lookuptable();
end

global versMajor
global versMinor

for uid_i=1:length(lookuptable)
    display(lookuptable(uid_i))
    %    new_docu = set_save_param(uid(uid_i), 1);
    safed_docu = load_docufile(uid_i);
    safed_docu.vers.minor = versMinor;
    safed_docu.vers.major = versMajor;
    
    if isfield(safed_docu, 'date_s')
        safed_docu.modTimes{1} = safed_docu.date_s;
        
        safed_docu.modTimes{end+1} = datestr(now);
        safed_docu = rmfield(safed_docu, 'date_s');
    end
    safed_docu.demcmc_vers.minor = 0;
    safed_docu.demcmc_vers.major = 1;
    safed_docu.UserDefined = [];
    checkDocustruct(safed_docu);
    
    save(sprintf('%s%s%s',DOCUDIR, filesep,safed_docu.filename), '-struct', 'safed_docu');
end

end