function selector = load_selectors(id)

h1 = load(sprintf('.%sData%sReadData%sall_selectors.mat',filesep, filesep, filesep));

if exist('id')
    selector = h1.nSelector{id};
else
    selector = h1;
end
