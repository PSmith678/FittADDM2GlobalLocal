function post=calcMCMC1(startValue)


% setting constants
data = [2, 4, 3, 1, 6, 2, 2.5, 7, 10];

% Priors
priorShape = [1.5 1.5];
scaleValue = 6;

proposalDev = 0.2;
Nsample = 2000;

% initialisation
post = nan(Nsample,1);
post(1) = startValue;

% chain
for iSample=1:Nsample-1
    currentSample = post(iSample);
    
    % Generate new proposal
    proposal = currentSample + proposalDev*randn(size(startValue));
    
    % calculate likelihood values for proposal and current sample
    likeProposal = calcLike(scaleValue, proposal, data) ...
        *normpdf(proposal, priorShape(1), priorShape(2)); 

    % Accept/Reject step
    likeSample = calcLike(6, currentSample, data) ...
        *normpdf(currentSample, priorShape(1), priorShape(2)); 
    if  likeProposal > likeSample
        %Accept proposal
        post(iSample+1) = proposal;
    else
        % calculate probility of accept/reject
        ratio = likeProposal / likeSample;
        if rand() < ratio
            % Accept proposal
            post(iSample+1) = proposal;
        else
            % Reject proposal
            post(iSample+1) = currentSample;
        end
        
    end
end


end

function res = calcLike(scale, shape, data)

p = wblpdf(data, scale, shape);
res = prod(p);
end