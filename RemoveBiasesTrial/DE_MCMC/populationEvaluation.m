function probValues = populationEvaluation(inFunction,pop,popSize,dis2,parallelOn)

probValues = ones(1,popSize)*-Inf;
if parallelOn
    for iter = 1:popSize
        if dis2(iter)>0
            fOut(iter) = parfeval(inFunction,1,pop(iter,:));
        end
    end
    for iter = 1:popSize
        try
            [~,probValues(iter)] = fetchNext(fOut(iter));
        end
    end
else
    for iter = 1:popSize
        if dis2(iter)>0
            probValues(iter) = inFunction(pop(iter,:));
        end
    end
end

end