function pop = ProposalHandling(initPop, popSize, dNoise, nParameters, transMethod, transParam, bestPars, algState)

s = size(initPop);
if s(1)==1
    initPop = initPop';
end

choice = randi(popSize-1,2,popSize);
choice(1,choice(1,:) >= choice(2,:)) = choice(1,choice(1,:) >= choice(2,:))+1;
choice(2,choice(1,:) <= choice(2,:)) = choice(2,choice(1,:) <= choice(2,:))+1;

%err = (rand(1, nParameters)-0.5)*dNoise;
if transMethod == 1 
    gammaOrg = transParam(1);
end
if transMethod == 3
    gammaOrg = (transParam(2) - transParam(1)) * rand(popSize,1) + transParam(1) + dNoise*rand(popSize,1);
end

if transMethod == 4
    gammaOrg=transParam(2)*(1+transParam(1)*randn(popSize,1));
end

part1 = bsxfun(@times, initPop(choice(1,:),:)-initPop(choice(2,:),:),gammaOrg);
if strcmp(algState,'greedy')
    part2 = bsxfun(@times, bsxfun(@minus,bestPars,initPop),gammaOrg);
else
    part2 = 0;
end
pop = initPop+part1+part2;
%pop = initPop+part1+part2+err;

end