param = [0.015, 0.025, 0.025, 0.015, 0.01, 0.01, 0.01, 0.01, 0.004, 0.0042, 2, 110, 0.0085];
simDat = run_ADDM(param, 1000);

%[rate1, rate2, rate3, rate4, bias1, bias2, bias3, bias4,
%      B1, B2, threshold, non-decision time, reselect]


yTimes = nan(1,8);
for iCond = 1:8
    yTimes(iCond) = mean(simDat(iCond).rt_res1);
end 
subplot(2,1,1)
xlim([0 9])
xTimes = 1:8;
bar(xTimes, yTimes)
xlabel('Condition Number')
ylabel('Mean Reaction Times (ms)')
title('Mean Reaction Times of Correct Responses for each Condition for 1000 trials')

yError = nan(1,8);
for iCond = 1:8
    yError(iCond) = length(simDat(iCond).rt_res0);
end 
subplot(2,1,2)
xlim([0 9])
xError = 1:8;
bar(xError, yError)
xlabel('Condition Number')
ylabel('Number of Errors')
title('Number of Errors for each Condition for 1000 trials')

%yTimes = nan(1,8);
%for iCond = 1:8
   % yTimes(iCond) = median(simDat(iCond).rt_res1);
%end 
%subplot(3,1,3)
%xlim([0 9])
%xTimes = 1:8;
%bar(xTimes, yTimes)
%xlabel('Condition')
%ylabel('Median Reaction Times')
%title('Median Reaction Times of Correct Responses for each Condition')



prior.values = [0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.0045, 0.0045, 1.75, 100, 0.007; ...
                    0.035, 0.035, 0.035, 0.035, 0.015, 0.015, 0.015, 0.015, 0.0099, 0.0099, 5.75, 180, 0.009];
prior.type = "uniform";
prior.paramNames = ["rate1", "rate2", "rate3", "rate4", "bias1", "bias2", "bias3" ...
    "bias4", "L1", "L2", "threshold", "non-decision time", "reselect"];

