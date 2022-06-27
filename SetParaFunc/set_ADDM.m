function ret = set_ADDM(ret)


%if ret.uid > 18
    % Model info
param_label = 'NonTMS';
%else
    %param_label = 'Wide';
%end
% Exp
model_id = 1;
dataSelectorId = ret.uid;


ret = init_defaults(ret, dataSelectorId, model_id, param_label);

% Version tree
ret.versPointers.parent = 0;
ret.versPointers.parent_param_label='';

ret.versPointers.best_parent = 0;
ret.versPointers.best_parent_param_label='';

ret.versPointers.children = [];
ret.versPointers.children_param_label = {};

% Meta info
ret.descr.title = 'Models for Flanker tasks';
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

paramBounds = [0.0001, 0.0001, 0.0001, 0.0001, -0.02, -0.02, -0.02, -0.02, 0.0061, 0.0061, 1.53, 100, 0.006; ...
                    0.095, 0.095, 0.095, 0.095, 0.045, 0.045, 0.045, 0.045, 0.0235, 0.0245, 5.35, 450, 0.01];
%for ibounds = 1:5

    ret.best.bounds.type = 'uniform';
    %                         tau    mu_c  bound_a  bound_b  sigma
    ret.best.bounds.values = paramBounds;

%end
ret.best.comments = 'uniform-distributed priors';

ret.post.bounds = ret.best.bounds;
ret.post.comments = 'uniform-distributed priors';
%  paramBounds = [.2 .4 .5 .2 1;...
%                 .15 .4 .3 .2 .5;
%                 0  0  0  0 .001;
%                 Inf Inf Inf Inf Inf];

% x = {'normTruncPdf','normTruncPdf','normTruncPdf','unifpdf'; %pdf function
%     'normTruncRnd','normTruncRnd','normTruncRnd','unifrnd'}; % random number function
% 
% for ii = 1:5
%     ret.best.bounds{ii}.type = 'custom';
%     ret.best.bounds{ii}.callPdf = x(1,:);
%     ret.best.bounds{ii}.callRnd = x(2,:);
%     ret.best.bounds{ii}.values{1} = {.2 .5 0 Inf}; % A 
%     ret.best.bounds{ii}.values{2} = {.4 .4 0 Inf}; % ter
%     ret.best.bounds{ii}.values{3} = {.1 .5 0 Inf}; %p
%     ret.best.bounds{ii}.values{4} = {.01 2.5};% rd
%  end
%for ii = 1:5

%    ret.best.bounds{ii}.type = 'normal';
    %                         tau    mu_c  bound_a  bound_b  sigma
%    ret.best.bounds{ii}.values = paramBounds;

ret.post_from_best = 0;
ret.post.bounds = ret.best.bounds;
ret.post.bounds = ret.best.bounds;
ret.post.demcmc_para.resampleProb = 0.3;
% ret.best.generations = 1000;
% 
% % posterior sampling
% ret.post.comments = '';
% ret.post.generations = 3000;



end

