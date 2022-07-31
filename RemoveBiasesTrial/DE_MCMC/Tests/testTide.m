function [error, evTIDE, evInt, evHM] = testTide()


startGof = [3.05 3.2 3.1 3.05 3.001 3.002 3.02 3.0105 3.0101 3 3.0005 3.022 3.0013 3.05 2.9 2.8 2.85];
groupSize = length(startGof);
prior = [-5 10]';

% TIDE
[evTIDE, pop, gof] = runTide(@(x) loglikeGaus(x), prior, startGof, 'groupSize', groupSize, 'boundedUniform', 'transitionMethod', {'Braak'});

% 
evInt = integral(@(x) exp(loglikeGaus(x)), prior(1),prior(2)) / (prior(2) - prior(1));

% Harmonic mean
[pop, gof] = posteriorsampling(@(x) loglikeGaus(x), prior,startGof, 'groupSize', groupSize, 'boundedUniform', 'transitionMethod', {'Braak'});
evHM = length(gof(:)) / sum(1./exp(gof(:)));

error(1) = abs(evInt - evTIDE) / evInt;
error(2) = abs(evInt - evHM) / evInt;

end