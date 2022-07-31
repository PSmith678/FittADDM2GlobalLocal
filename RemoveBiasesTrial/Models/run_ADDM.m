function simDat= run_ADDM(param, nTrial)
% Parameters:
%%%%%%% target, distractor, boundary, none_decision_t, rateS % OLD
%
% rate, bias, L, G, threshold, non-decision time, reselect
% param vector = [rate1, rate2, rate3, rate4, bias1, bias2,
%                  B1, B2, threshold, non-decision time, reselect]

rt_correct = nan(nTrial,1);
resp_correct = nan(nTrial,1);
stepsize = 1;
interTrialSigma = 0.1;
timesteps = 10000;
rateSVariance = 0.01;
nCond = 8;

% Set up the parameters 
threshold = param(9);
nonDecisionTime = param(10);
reselect = param(11);
targetVec = [param(7), param(8), param(7), param(8), param(8), param(7), param(8), param(7)];
distractorVec = [param(8), param(7), -param(8), -param(7), param(7), param(8), -param(7), -param(8)];
biasVec = [param(5), param(6)];
% this needs another loop to adapt the model to the task - for all
% different conditions.
simDat = repmat(struct('rt_res1', [], 'rt_res0', [], 'response', []), nCond, 1);


for iCond = 1:nCond
    if iCond == 1 || iCond == 2
        h1 = param(iCond);
        bias = biasVec(1);

    elseif iCond == 3 || iCond == 4 
        h1 = param(iCond - 2);
        bias = biasVec(1);

    elseif iCond == 5 || iCond == 6
        h1 = param(iCond - 2);
        bias = biasVec(2);

    elseif iCond == 7 || iCond == 8
        h1 = param(iCond - 4);
        bias = biasVec(2);

    end

    target = targetVec(iCond);
    distractor = distractorVec(iCond);

    for iTrials=1:nTrial
        h2 = h1 + rateSVariance*randn;
        
        %disp([target, ...
            %distractor, threshold, nonDecisionTime, interTrialSigma, h2, stepsize, bias, reselect])
       
        [rt_correct(iTrials),resp_correct(iTrials)] = res_ADDM(timesteps, target, ...
            distractor, threshold, nonDecisionTime, interTrialSigma, h2, stepsize, bias, reselect);
        % timesteps,target, distractor, boundary, none_decision_t, sigma, rateS, stepsize
        % timesteps,target, distractor, boundary, none_decision_t, sigma, rateS, stepsize
    end
    j = find(resp_correct == 0);
    rt_incorrect = rt_correct(j);
    rt_correct(j) = [];

    simDat(iCond).rt_res1 = rt_correct;
    simDat(iCond).rt_res0 = rt_incorrect;
    simDat(iCond).response = resp_correct;
    
    %plot(eviS)
    %hold on 

    
    %plot(eviI)
    %hold on
    %plot(eviI)
    
    
    
    

end



end




