function p = mixedPrior(pars)
%%
% An example for computing a probability value for the given parameter set
% and their respective prior functions. In this case there's 2 parameters.
% First, parameter is normally distributed and a second parameter has a
% skewed prior.
%

p1 = normpdf(pars(1),0.5,2);
p2 = wblpdf(pars(2),1,0.5);
p = (p1+p2)/2;

end