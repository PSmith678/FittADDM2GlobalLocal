function [gofsOut, popOut, accept] = ProposalAcceptanceTIDE(gofs, pop, popSize, prior, temperature,fun,resamplingProb)
% Resampling Step
[~,nChain] = size(gofs);

% Resample likelihood with probability resamplingProb
if rand() < resamplingProb
    gofs(1,:) = populationEvaluation(fun,squeeze(pop(1,:,:)),nChain,ones(nChain,1),1);
end

alpha = rand(1,popSize);
%accept = alpha<=(exp(gofs(2,:)-gofs(1,:))./(prior(2,:)./prior(1,:)));

gofs_h1 = exp(gofs(1,:)).^temperature;
gofs_h2 = exp(gofs(2,:)).^temperature;


accept = alpha<=((gofs_h2 .* prior(2,:)) ./ (gofs_h1 .* prior(1,:)) );
infIdx = gofs(2,:) == -Inf;
accept(infIdx) = 0;


gofsOut = gofs(1,:);
gofsOut(accept) = gofs(2,accept);
popOut = pop(1,:,:);
popOut(1,accept,:) = pop(2,accept,:);

popOut = squeeze(popOut);
s = size(popOut);
if s(1)==1
    popOut = popOut';
end

end