% Normal Priors
tic
prior.values = [.2 .4 .5 .5 %mu
    .2 .3 .5 .5; %sigma
    0 0 0 0; % left truncation
    Inf Inf Inf Inf]; % right truncation.

prior.type = 'normal';
prior.paramNames = {'a','ter','p','rd'};
priorSummaryCheck(prior,'normal');
clear

% Uniform Priors
prior.values = [0 0 0 0 %lower 
    1 1 1 1]; %upper
prior.type = 'uniform';
prior.paramNames = {'a','ter','p','rd'};
priorSummaryCheck(prior,'uniform');
clear

% Custom Prior
prior.priorRand = {'normTruncRnd','normTruncRnd','normTruncRnd','unifrnd'};
prior.values{1} = {.2 .5 0 Inf}; % A
prior.values{2} = {.4 .4 0 Inf}; % ter
prior.values{3} = {.5 .5 0 Inf}; %p
prior.values{4} = {.01 2.5};% rd
prior.type = 'custom';
prior.paramNames = {'a','ter','p','rd'};
priorSummaryCheck(prior,'custom');

toc

