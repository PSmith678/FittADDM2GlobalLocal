function testAcceptanceRate ()

disp('Testing whether DE_MCMC acceptance rate works.');
popSize = 4;
nGenerations = 4;
nPars = 1;
customPrior = @(x) 1;
customRange = @(x) randn(1);
global spinner;
global priorVal;
spinner = 1;
priorVal = 1;
dummy = @(x) dummyFunction(x);
try
    fprintf('\nTrying the acceptance rate during the search\n');
    [a,b,acc,lastGen,lastFits] = de_mcmc(@(evalPars) feval(dummy,evalPars),{nPars,customPrior},'OnlyBestSearch','customPrior',customRange,'groupSize',popSize,'nGenerations',nGenerations,'mutationProbability',0);
    fprintf('Passed\n');
catch e
    disp('Failed');
%     throw(e);
end
try
    fprintf('\nTesting correctness of the acceptance rates\n');
    if sum(acc==0.5)==3
        fprintf('Passed\n');
    else
        e = MException('de_mcmc:bestSearch:acceptanceRateMismatch','Something went wrong with acceptance rate');
        throw(e);
    end
catch e
    disp('Failed');
%     throw(e);
end

popSize = 10;
nGenerations = [2,4];
try
    fprintf('\nTrying the acceptance rate during the posterior sampling\n');
    [a,b,acc] = de_mcmc(@(evalPars) feval(dummy,evalPars),{nPars,customPrior},'boundedUniform','customPrior',customRange,'groupSize',popSize,'nGenerations',nGenerations);
    fprintf('Passed\n');
catch e
    disp('Failed');
%     throw(e);
end
try
    fprintf('\nTesting the correctness of a returned acceptance rate during posterior sampling\n');
    if sum(acc==0.5)==3
        fprintf('Passed\n');
    else
        e = MException('de_mcmc:bestSearch:acceptanceRateMismatch','Something went wrong with acceptance rate');
        throw(e);
    end
catch e
    disp('Failed');
%     throw(e);
end
end

function y = dummyFunction(x)

global spinner;
global priorVal;
spinner = spinner*-1;
priorVal = priorVal+spinner;
y = log(priorVal);

end