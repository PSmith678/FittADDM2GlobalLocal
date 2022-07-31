function testProposalAcceptance()

disp('Testing whether an implementation for proposal acceptance works.');
try
    popSize = 3;
    nParams = 2;
    pop(1,:,:) = rand(popSize,nParams);
    pop(2,:,:) = rand(popSize,nParams);
    gofs = ones(2,popSize);
    gofs(1,:) = log(gofs(1,:)*2);
    gofs(2,:) = log(gofs(2,:));
    prior = ones(2,popSize);
    disp('Check proposal acceptance with 2 parameters');
    rng('shuffle');
    [gofs,pop] = ProposalAcceptance(gofs, pop, popSize, prior);
    fprintf('Passed\n');
    
    popSize = 3;
    nParams = 1;
    clear pop;
    pop(1,:,:) = rand(popSize,nParams);
    pop(2,:,:) = rand(popSize,nParams);
    gofs = ones(2,popSize);
    gofs(1,:) = log(gofs(1,:)*2);
    gofs(2,:) = log(gofs(2,:));
    prior = ones(2,popSize);
    disp('Check proposal acceptance with one parameter');
    rng('shuffle');
    [gofs,pop] = ProposalAcceptance(gofs, pop, popSize, prior);
    fprintf('Passed\n');
catch e
    disp('Failed');
    throw(e);
end

end