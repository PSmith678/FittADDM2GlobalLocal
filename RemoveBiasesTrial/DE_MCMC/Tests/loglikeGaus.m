function res=loglikeGaus(paraMean)


DATA = [1 2 3 4 5];
SIGMA = 1;
res = nan(1,length(paraMean));
for i=1:length(paraMean)
res(i) = sum(log(normpdf(DATA,paraMean(i), SIGMA)));
end
end