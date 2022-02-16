function nSelector = createAllSelectors()

pNumbers = [1:6 8:25];
pNumbers2 = [1:23 25:26];

nidCount = 1;
otherCount = 1;
for i = 1:length(pNumbers)
    nSelector{1,nidCount}.descr = 'Wide';
    nSelector{1,nidCount}.nid = nidCount;
    nSelector{1,nidCount}.label= sprintf('Participant %d',pNumbers(otherCount));
    nSelector{1,nidCount}.nCondLabel = {'congruent','incongruent'};
    nSelector{1,nidCount}.values = {strcat('W',string(pNumbers(otherCount))),1:4};
    nSelector{1,nidCount}.multiFits = 1;
    nidCount = nidCount+ 1;
    otherCount = otherCount + 1;
end

nidCount = 25;
otherCount = 1;
for i = 1:length(pNumbers2)
    nSelector{1,nidCount}.descr = 'Narrow';
    nSelector{1,nidCount}.nid = nidCount;
    nSelector{1,nidCount}.label= sprintf('Participant %d',pNumbers2(otherCount));
    nSelector{1,nidCount}.nCondLabel = {'congruent','incongruent'};
    nSelector{1,nidCount}.values = {strcat('N',string(pNumbers2(otherCount))),1:4};
    nSelector{1,nidCount}.multiFits = 1;
    nidCount = nidCount+ 1;
    otherCount = otherCount + 1;
end
end