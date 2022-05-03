function ret = set_uid1(ret)

% label for fit
param_label = 'Wide';

% select model
model_id = 2;

% select data selector
dataSelectorId = 1;


ret = init_defaults(ret, dataSelectorId, model_id, param_label);

% Version tree
ret.versPointers.parent = 0;
ret.versPointers.parent_param_label='';

ret.versPointers.best_parent = 0;
ret.versPointers.best_parent_param_label='';

ret.versPointers.children = [];
ret.versPointers.children_param_label = {};

% Meta info
ret.descr.title = 'Models for T task';
ret.descr.parent = 'None';
ret.descr.curr = 'First attempt';
ret.descr.future =' ';

% adds a decription to the parent fit
if ret.versPointers.parent ~= 0
    addDescrFuture(ret.versPointers.parent, 'Was good');
    add_child(ret.data.selector.label, ret.model.name, this_version, param_label, ret.versPointers.parent_param_label, ret.versPointers.parent)

end


% Parameter removal rules for fixed parameters and PCA-based reduction
ret.para_rules = [];

% Best parameter
ret.best.comments = '';
paramBounds = [0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.0045, 0.0045, 1.75, 100, 0.007; ...
                    0.035, 0.035, 0.035, 0.035, 0.015, 0.015, 0.015, 0.015, 0.0099, 0.0099, 5.75, 180, 0.009];
for ibounds = 1:5

    ret.best.bounds{ibounds}.type = 'uniform';
    %                         tau    mu_c  bound_a  bound_b  sigma
    ret.best.bounds{ibounds}.values = paramBounds;

end
ret.best.comments = 'uniform-distributed priors';

ret.post.bounds = ret.best.bounds;
ret.post.comments = 'uniform-distributed priors';


end

