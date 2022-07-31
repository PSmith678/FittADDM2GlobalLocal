function testPopGeneration ()

display('Testing whether an implementation for population generation works.');
try
    prior = [-2,2];
    priorOption = 'range';
    popSize = 2;
    initParams = [];
    nParams = 1;
    display('Check uniform parameter generation');
    rng('shuffle');
    pop = PopGeneration(priorOption, prior, popSize, initParams, nParams);
    display(sprintf('Passed\n'));
    
    display(sprintf('Check normally distributed parameter generation'));
    priorOption = 'n';
    rng('shuffle');
    pop = PopGeneration(priorOption, prior, popSize, initParams, nParams);
    display(sprintf('Passed\n'));
    
    display(sprintf('Check custom function parameter generation'));
    priorOption = 'n';
    rng('shuffle');
    pop = PopGeneration(priorOption, prior, popSize, initParams, nParams);
    display(sprintf('Passed\n'));
catch e
    display('Failed');
    throw(e);
end

end