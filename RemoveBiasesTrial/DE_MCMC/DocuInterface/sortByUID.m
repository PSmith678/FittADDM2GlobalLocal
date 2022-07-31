function out = sortByUID()

  % List files in current directory.
files = dir('*docu.mat');
names = {files.name}; % Get names;

for iFile = 1:length(files)
    
    idx = find(contains(names,sprintf('u%d_docu',iFile))); % Loop through names and check if is uid.
  
    

    out{iFile,1} = strcat(files(idx).folder,'\',files(idx).name); % concatenate folder with name;
end
end
