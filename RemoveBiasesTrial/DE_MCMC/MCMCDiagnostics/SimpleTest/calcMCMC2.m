function post=calcMCMC(startValue)

%[generations, nChain, nParam] = size(posterior);

data = [2, 4, 3, 1, 6, 2, 2.5, 7, 10];

priorShape = [2 1.5];
priorScale = [5 1.5];

proposalDev = 1.5;
Nsample = 2000;

post = nan(Nsample,2);

post(1,:) = startValue;

for iSample=1:Nsample-1
    currentSample = post(iSample,:);
    proposal = currentSample + proposalDev*randn(size(startValue));
    
    likeProposal = calcLike(proposal(1), proposal(2), data) ...
        *normpdf(proposal(1), priorScale(1), priorScale(2)) ... 
        *normpdf(proposal(2), priorShape(1), priorShape(2)); 
    likeSample = calcLike(currentSample(1), proposal(2), data) ...
            *normpdf(currentSample(1), priorScale(1), priorScale(2)) ... 
        *normpdf(currentSample(1), priorShape(1), priorShape(2)); 
    if  likeProposal > likeSample
        post(iSample+1,:) = proposal;
    else
        ratio = likeProposal / likeSample;
        if rand() < ratio
            post(iSample+1,:) = proposal;
        else
            post(iSample+1,:) = currentSample;
        end
        
    end
end


end

function res = calcLike(scale, shape, data)

p = wblpdf(data, scale, shape);
res = prod(p);
end


