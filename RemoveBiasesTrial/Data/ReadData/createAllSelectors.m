function nSelector = createAllSelectors()


path = './Data/GL_Raw Data';
filePattern = fullfile(path, '*Globalsaliency_occ.txt');
files = dir(filePattern);

path2 = './Data/dataGLaverages.xlsx';
lowerCaseNames = readcell(path2, "Sheet", "RT");
aqGroup = readcell(path2, "Sheet", "Sheet4");


for i=1:length(files)
    names{i} = files(i).name;
    nSelector{1,i}.label = erase(names{i}, 'Globalsaliency_occ.txt');
    nSelector{1,i}.nCondLabel = {'G-Con-LS','G-Con-GS', 'G-Incon-LS', 'G-Incon-GS', 'L-Con-LS', 'L-Con-GS', 'L-Incon-LS', 'L-Incon-GS'};
    nSelector{1,i}.values = nSelector{1,i}.label;
    nSelector{1,i}.multiFits = 0;
    nSelector{1,i}.descr = 'CarmelGLNoTMS2BiasTrial';
    idx = regexp(nSelector{1,i}.label,'[0-9]','match');
    idx = cell2mat(idx);
    idx = str2double(idx);
    if lowerCaseNames{idx + 1, 28} >= 19
        nSelector{1,i}.AQgroup = 'High';
    else
        nSelector{1,i}.AQgroup = 'Low';
    end
    nSelector{1, i}.AQscore = lowerCaseNames{idx + 1, 28};
end


