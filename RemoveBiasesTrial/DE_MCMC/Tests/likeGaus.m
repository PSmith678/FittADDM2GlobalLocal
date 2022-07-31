function res=likeGaus(paraMean)


DATA = [1 2 3 4 5];
SIGMA = 1;

res = prod((normpdf(DATA,paraMean, SIGMA)));
end