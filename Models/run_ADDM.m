function simDat = run_ADDM(param, nTrial)
% Parameters:
% target, distractor, boundary, none_decision_t, rateS
rt_correct = nan(nTrial,1);
resp_correct = nan(nTrial,1);
stepsize = 1;
interTrialSigma = 0.01;
timesteps = 10000;
rateSVariance = 1;

% this needs another loop to adapt the model to the task
for iTrials=1:nTrial
    h1 = param(5) + rateSVariance*randn;
    [rt_correct(iTrials),resp_correct(iTrials)] = res_ddm(timesteps, param(1), param(2), param(3), param(4), interTrialSigma, h1, stepsize);
    % timesteps,target, distractor, boundary, none_decision_t, sigma, rateS, stepsize
    % timesteps,target, distractor, boundary, none_decision_t, sigma, rateS, stepsize

end

j = find(resp_correct == 0);
rt_incorrect = rt_correct(j);
rt_correct(j) = [];

simDat = struct('rt_res1',rt_correct,'rt_res0',rt_incorrect,'response',resp_correct);

end




