function nSelector = createAllSelectors()


path = '.\Data\GL_Raw Data';
filePattern = fullfile(path, '*Globalsaliency_occ.txt');
files = dir(filePattern);


for i=1:length(files)
names{i} = files(i).name;
nSelector{1,i}.label = erase(names{i}, 'Globalsaliency_occ.txt');
nSelector{1,i}.nCondLabel = {'gcls','gcgs', 'gils', 'gigs', 'lcls', 'lcgs', 'lils', 'ligs'};
nSelector{1,i}.values = nSelector{1,i}.label;
nSelector{1,i}.multiFits = 0;
nSelector{1,i}.descr = 'CarmelGLNoTMS';
end


end