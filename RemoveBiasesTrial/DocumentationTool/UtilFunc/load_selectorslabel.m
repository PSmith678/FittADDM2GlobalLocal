function selectorLabels = load_selectorslabel(id)

load('./Data/ReadData/all_selectors.mat')
dbstop if error

n = length(nSelector);
selectorLabels = [];

for i=1:n
    if exist('id')
        if nSelector{i}.nid == id
            selectorLabels = nSelector{i}.label;
        end
    else
        selectorLabels{i} = nSelector{i}.label;
    end
end
end