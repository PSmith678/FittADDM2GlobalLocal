function pop = PopGeneration(priorOption,prior,popSize,initParams,nParameters)

pop = zeros(popSize,nParameters);
for iter = 1:popSize
    if ~isempty(initParams)
        pop(iter,:) = initParams(iter,:);
    elseif strcmp(priorOption, 'range')
        pop(iter,:) = rand(1, nParameters).*(prior(2)-prior(1))+prior(1);
    elseif strcmp(priorOption, 'n')
        pop(iter,:) = randn(1, nParameters).*prior(2)+prior(1);
    else
        pop(iter,:) = rFun(prior{2:end});
    end
end

end