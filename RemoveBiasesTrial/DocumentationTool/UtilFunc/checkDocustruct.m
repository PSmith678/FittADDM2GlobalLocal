function ret = checkDocustruct(docu)

ret = true;

docuDefault = createDocustruct();
fDocuDefault = fieldnames(docuDefault);

fDocu = fieldnames(docu);





if length(fDocu) > length(fDocuDefault)
    warning('not allowed fields in this docu struct');
    setdiff(fDocu,fDocuDefault)
    ret = false;
 else
    if length(fDocu) < length(fDocuDefault)
        warning('incomplete docu struct')
        setdiff(fDocuDefault,fDocu)
        ret = false;
    end
    
end

[versMajor, versMinor] = getVersion();

if isfield(docu, 'vers')
    if versMajor > docu.vers.major
        warning('docu file contains struct from an old major version')
        ret = false;
    end
    
    if versMajor ==  docu.vers.major && versMinor > docu.vers.minor
        warning('docu file contains struct from an old Minor version')
        ret = false;
    end
else
    warning('no version info available')
    ret = false;
end


