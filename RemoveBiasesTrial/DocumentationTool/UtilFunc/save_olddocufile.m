function ret = save_olddocufile(filename, data)

if nargin == 2
 save(sprintf('./Docus/%s_old',filename), '-struct', 'data');
end

