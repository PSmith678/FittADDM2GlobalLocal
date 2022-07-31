function pars = mixedPriorGen()
%%
% An example for generating a prior. In this case there's 2 parameters.
% First, parameter is normally distributed and a second parameter has a
% skewed prior.
%

pars(1) = randn(1)*2+0.5;
pars(2) = wblrnd(1,0.5,1);

end