path = '\Users\polly\OneDrive\Documents\Polly MSc\Research Project\Repository\FittADDM2GlobalLocal\Data\GL_Raw Data';
filePattern = fullfile(path, '*Globalsaliency_occ.txt');
files = dir(filePattern);


for i=1:length(files)
names{i} = files(i).name;
names{i} = erase(names{i}, 'Globalsaliency_occ.txt');
end