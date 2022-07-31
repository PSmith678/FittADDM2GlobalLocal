function testPopulationEvaluation ()

disp('Testing whether an implementation for evaluating provided function works.');
pop = randn(3,1);
dummyFunction = @(x)normpdf(x);
popSize = 3;
dis = ones(1,popSize);
parallelOn = 0;
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
    fprintf('\nTrying the function without parallelisation\n');
    populationEvaluation(dummyFunction,pop,popSize,dis,parallelOn);
    fprintf('Passed\n');
    
    parallelOn = 1;
    fprintf('\nTrying the function with parallelisation');
    probValues = populationEvaluation(dummyFunction,pop,popSize,dis,parallelOn);
    fprintf('Passed\n');
    
    fprintf('\nTesting correctness of the returned fitness values\n');
    testOutput = dummyFunction(pop(1));
    if testOutput == probValues(1)
        fprintf('Passed\n');
    else
        e = MException('Fitness:PopulationEvaluation:valueMismatch','Something went wrong with evaluting the fitness');
        throw(e);
    end
    
    dis(2) = 0;
    fprintf('\nTrying the function with partial parallelisation');
    probValues = populationEvaluation(dummyFunction,pop,popSize,dis,parallelOn);
    fprintf('Passed\n');
catch e
    disp('Failed');
%     throw(e);
end

end