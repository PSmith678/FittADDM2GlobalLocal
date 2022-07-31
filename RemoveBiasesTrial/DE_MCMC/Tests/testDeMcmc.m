function testDeMcmc ()

disp('Testing whether DE_MCMC with parallel implementation works.');
dummyFunction = @(x)log(normpdf(x));
popSize = 10;
minBounds = -4;
maxBounds = 4;
nGenerations = 4;
try
    parpool(2);
catch
    poolobj = gcp('nocreate');
    if poolobj.NumWorkers ~= 2
        delete(poolobj);
        parpool(2);
    end
end
try
    fprintf('\nTrying the search without parallelisation\n');
    [a,b,acc,lastGen,lastFits] = de_mcmc(@(evalPars) feval(dummyFunction,evalPars),[minBounds;maxBounds],'OnlyBestSearch','boundedUniform','groupSize',popSize,'nGenerations',nGenerations);
    fprintf('Passed\n');
catch e
    disp('Failed');
%     throw(e);
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
%     throw(e);
end

try
    fprintf('\nTrying the search with parallelisation\n');
    [a,b,acc,lastGen,lastFits] = de_mcmc(@(evalPars) feval(dummyFunction,evalPars),[minBounds;maxBounds],'OnlyBestSearch','boundedUniform','groupSize',popSize,'nGenerations',nGenerations,'parallelOn');
    fprintf('Passed\n');
catch e
    disp('Failed');
    %     throw(e);
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
%     throw(e);
end

try
    dummyFunction = @(x)log(mvnpdf(x));
    minBounds = [-4,-4];
    maxBounds = [4,4];
    fprintf('\nTrying the search with parallelisation in multivariate function\n');
    [a,b,acc,lastGen,lastFits] = de_mcmc(@(evalPars) feval(dummyFunction,evalPars),[minBounds;maxBounds],'OnlyBestSearch','boundedUniform','groupSize',popSize,'nGenerations',nGenerations,'parallelOn');
    fprintf('Passed\n');
catch
    disp('Failed');
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
%     throw(e);
end


dummyFunction = @(x)log(normpdf(x));
popSize = 10;
minBounds = -4;
maxBounds = 4;
nGenerations = 4;
try
    fprintf('\nTrying the posterior sampling without parallelisation\n');
    [a,b,acc] = de_mcmc(@(evalPars) feval(dummyFunction,evalPars),[minBounds;maxBounds],'boundedUniform','groupSize',popSize,'nGenerations',nGenerations);
    fprintf('Passed\n');
catch e
    disp('Failed');
%     throw(e);
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
%     throw(e);
end

try
    fprintf('\nTrying the posterior with parallelisation\n');
    [a,b,acc] = de_mcmc(@(evalPars) feval(dummyFunction,evalPars),[minBounds;maxBounds],'boundedUniform','groupSize',popSize,'nGenerations',nGenerations,'parallelOn');
    fprintf('Passed\n');
catch e
    disp('Failed');
    %     throw(e);
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
%     throw(e);
end

try
    dummyFunction = @(x)log(mvnpdf(x));
    minBounds = [-4,-4];
    maxBounds = [4,4];
    nGenerations = [10,100];
    fprintf('\nTrying the posterior sampling with parallelisation in multivariate function\n');
    [a,b,acc,post,fits] = de_mcmc(@(evalPars) feval(dummyFunction,evalPars),[minBounds;maxBounds],'boundedUniform','groupSize',popSize,'nGenerations',nGenerations,'parallelOn');
    fprintf('Passed\n');
catch
    disp('Failed');
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
%     throw(e);
end

end