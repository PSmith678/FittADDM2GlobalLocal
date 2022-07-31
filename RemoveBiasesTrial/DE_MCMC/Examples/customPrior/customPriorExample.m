function customPriorExample ()
%%
% A posterior sampling example with 2 free parameters and a custom prior.
% First, parameter is normally distributed and a second parameter has a
% skewed prior.
%

dummyFunction = @(x)log(mvnpdf(x));
nPars = 2;
nGenerations = [10,100];
customPrior = @(x)mixedPrior(x);
customRange = @()mixedPriorGen();
[a,b,acc,post,fits] = de_mcmc(@(evalPars) feval(dummyFunction,evalPars),{nPars,customPrior},'customPrior', customRange, 'nGenerations',nGenerations);
disp('Finished');
end