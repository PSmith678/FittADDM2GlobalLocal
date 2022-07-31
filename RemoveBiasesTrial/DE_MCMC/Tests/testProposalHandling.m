function testProposalHandling ()

disp('Testing whether an implementation for proposal handling works.');
try
    popSize = 3;
    nParams = 1;
    initPop = rand(popSize,nParams);
    initPop = initPop';
    dNoise = 0.001;
    bestPars = zeros(1,nParams);
    gamma = 1;%2.38/sqrt(2*nParams);
    algState = 'greedy';
    disp('Check proposal generation with one parameter');
    rng('shuffle');
    pop = ProposalHandling(initPop, popSize, dNoise, nParams, gamma, bestPars, algState);
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
    popSize = 3;
    nParams = 2;
    initPop = rand(popSize,nParams);
    dNoise = 0.001;
    bestPars = zeros(1,nParams);
    gamma = 1;%2.38/sqrt(2*nParams);
    algState = 'greedy';
    fprintf('\nCheck proposal generation with two parameter');
    rng('shuffle');
    pop = ProposalHandling(initPop, popSize, dNoise, nParams, gamma, bestPars, algState);
    fprintf('\nPassed\n');
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
    algState = 'post';
    fprintf('\nCheck posterior proposal generation');
    rng('shuffle');
    pop = ProposalHandling(initPop, popSize, dNoise, nParams, gamma, bestPars, algState);
    fprintf('\nPassed\n');
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
    fprintf('\nCheck proposal generation with random transition weight\n');
    rng('shuffle');
    gamma = [0.1,0.8];
    pop = ProposalHandling(initPop, popSize, dNoise, nParams, gamma, bestPars, algState);
    fprintf('\nPassed\n');
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