function testCustomPrior ()

disp('Test custom prior implementation');
try
    dummyFunction = @(x)log(mvnpdf(x));
    nPars = 1;
    nGenerations = 100;
    mu = 0.5;
    cov = 2;
    customPrior = @(x)mvnpdf(x,mu,cov);
    customRange = @()randn(1)*cov+mu;
    fprintf('\nTrying the best search sampling combined with custom multivariate function as a prior\n');
    [a,b,acc,post,fits] = de_mcmc(@(evalPars) feval(dummyFunction,evalPars),{nPars,customPrior}, 'OnlyBestSearch','customPrior', customRange, 'nGenerations',nGenerations);
    fprintf('Passed\n');
catch e
    disp('Failed');
    for iter = 1:length(e.stack)
        disp(e.stack(iter).file);
        fprintf('function name: %s\n',e.stack(iter).name);
        fprintf('line number: %d\n',e.stack(iter).line);
    end
    disp(e.message);
end

try
    fprintf('\nTesting correctness of the returned best solutions\n');
    testOutput = dummyFunction(a);
    if testOutput == b
        fprintf('Passed\n');
    else
        e = MException('Fitness:PopulationEvaluation:valueMismatch','Something went wrong with evaluting the fitness');
        throw(e);
    end
catch e
    disp('Failed');
    for iter = 1:length(e.stack)
        disp(e.stack(iter).file);
        fprintf('function name: %s\n',e.stack(iter).name);
        fprintf('line number: %d\n',e.stack(iter).line);
    end
    disp(e.message);
end


try
    nGenerations = 100;
    fprintf('\nTrying only posterior sampling with custom multivariate function as a prior\n');
    [a,b,acc] = de_mcmc(@(evalPars) feval(dummyFunction,evalPars),{nPars,customPrior},'OnlyPosterior',post, 'customPrior', 'nGenerations',nGenerations);
    fprintf('Passed\n');
catch e
    disp('Failed');
    for iter = 1:length(e.stack)
        disp(e.stack(iter).file);
        fprintf('function name: %s\n',e.stack(iter).name);
        fprintf('line number: %d\n',e.stack(iter).line);
    end
    disp(e.message);
end

try
    fprintf('\nTesting correctness of the returned best solutions\n');
    testOutput = dummyFunction(a(1,1));
    if testOutput == b(1,1)
        fprintf('Passed\n');
    else
        e = MException('Fitness:PopulationEvaluation:valueMismatch','Something went wrong with evaluting the fitness');
        throw(e);
    end
catch e
    disp('Failed');
    for iter = 1:length(e.stack)
        disp(e.stack(iter).file);
        fprintf('function name: %s\n',e.stack(iter).name);
        fprintf('line number: %d\n',e.stack(iter).line);
    end
    disp(e.message);
end

end