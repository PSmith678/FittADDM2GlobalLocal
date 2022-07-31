function ret = addDocuFields(ret)

ret.post = [];
ret.para_rules = [];
ret.demcmc_vers = [];

ret.post_from_best = 0;


ret.demcmc_vers.minor = 0;
ret.demcmc_vers.major = 3;
vers = 11;

ret.best.demcmc_para.comments = 'default-setting with Turner and no pureification';
ret.best.demcmc_para.parallel_flag = 'parallelOn';
ret.best.demcmc_para.showProgress_steps = 20;
ret.best.demcmc_para.transitionMethod = {'Turner', 0.5, 1};
ret.best.demcmc_para.groupSize = 30;
ret.best.demcmc_para.id = vers;
ret.best.demcmc_para.generations = 1000;
ret.best.demcmc_para.resampleProb = 0;

ret.best.demcmc_para.comments = 'default-setting with Turner and no pureification';
ret.post.demcmc_para.parallel_flag = 'parallelOn';
ret.post.demcmc_para.showProgress_steps = 20;
ret.post.demcmc_para.transitionMethod = {'Turner', 0.5, 1};
ret.post.demcmc_para.groupSize = 30;
ret.post.demcmc_para.id = vers;
ret.post.demcmc_para.generations = 3000;
ret.post.demcmc_para.resampleProb = 0;
end