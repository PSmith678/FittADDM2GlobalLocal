function modelLabels = load_modellabel(id)

load(sprintf('.%sModels%sall_models', filesep, filesep));

n = length(Nmodel);
modelLabels = [];

for i=1:n
    if exist('id')
        if Nmodel{i}.nid == id
            modelLabels = Nmodel{i}.name;
        end
    else
        modelLabels{i} = Nmodel{i}.name;
    end
end
end