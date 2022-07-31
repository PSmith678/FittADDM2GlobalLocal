function upgradeFolders()


[status,msg] = movefile('AnaFunc', 'LocalAnaResults');

if status == 0
    error(msg);
end

mkdir('LocalAnaModels');

lookuptable = uid_lookuptable();

for uidI=1:length(lookuptable)
    display(lookuptable(uidI))
    if ~isempty(lookuptable{uidI})
        docu = load_docufile(uidI);
        docu.demcmc_vers.minor = 0;
        docu.demcmc_vers.major = 3;
        save_docufile(docu);
        
    end
end
fprintf(1, 'Please remember to delete m-files if they are now copies of them in the skeleton folder.\n');
fprintf(1, 'Also remember to move m-files that analysis the model into LocalAnaModels.\n')
end