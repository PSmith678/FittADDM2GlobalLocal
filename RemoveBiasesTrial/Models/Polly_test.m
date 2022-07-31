param = [0.015 0.025 0.025 0.015 0.01 0.01 0.004 0.0042 2 110 0.0085];
simDat = run_ADDM(param, 1000);

%[rate1, rate2, rate3, rate4, bias1, bias2, bias3, bias4,
%      B1, B2, threshold, non-decision time, reselect]

figure()
yTimes = nan(1,8);
for iCond = 1:8
    yTimes(iCond) = mean(simDat(iCond).rt_res1);
end 
gray = '#D3D3D3';
blue = '#0072BD';
colours = {gray, gray, blue, gray, gray, gray, gray, blue};
subplot(2,1,1)
xlim([0 9])
xTimes = 1:8;
b = bar(xTimes, yTimes);

xlabel('Condition Number')
ylabel('Mean Reaction Times (ms)')

title('Mean Reaction Times of Correct Responses for each Condition Over 1000 trials')
set(gca, FontSize = 12)


yError = nan(1,8);
for iCond = 1:8
    yError(iCond) = length(simDat(iCond).rt_res0);
end 
subplot(2,1,2)
xlim([0 9])
xError = 1:8;

bar(xError, yError);

xlabel('Condition Number')
ylabel('Number of Errors')

title('Number of Errors in each Condition Over 1000 trials')

sgtitle('Simulated Data Showing the Mean Reaction Times and Error Rates over 1000 trials', FontSize = 16)
set(gca, FontSize = 12)
%yTimes = nan(1,8);
%for iCond = 1:8
   % yTimes(iCond) = median(simDat(iCond).rt_res1);
%end 
%subplot(3,1,3)
%xlim([0 9])        `
%xTimes = 1:8;
%bar(xTimes, yTimes)
%xlabel('Condition')
%ylabel('Median Reaction Times')
%title('Median Reaction Times of Correct Responses for each Condition')

workedWellMostRecent2 = [0.0001, 0.0001, 0.0001, 0.0001, -0.02, -0.02, -0.02, -0.02, 0.0056, 0.0056, 1.51, 100, 0.0055; ...
                    0.09, 0.09, 0.09, 0.09, 0.05, 0.05, 0.05, 0.05, 0.022, 0.022, 5.15, 500, 0.01];

workedWellMostRecent =[0.0001, 0.0001, 0.0001, 0.0001, -0.02, -0.02, -0.02, -0.02, 0.0058, 0.0058, 1.51, 100, 0.0055; ...
                    0.095, 0.095, 0.095, 0.095, 0.05, 0.05, 0.05, 0.05, 0.0235, 0.0235, 5.2, 500, 0.01];


workedWell3 = [0.0001, 0.0001, 0.0001, 0.0001, -0.02, -0.02, -0.02, -0.02, 0.0051, 0.0051, 1.54, 100, 0.0055; ...
                    0.09, 0.09, 0.09, 0.09, 0.05, 0.05, 0.05, 0.05, 0.0185, 0.0185, 5.1, 500, 0.01];


prior.values = [0.0001, 0.0001, 0.0001, 0.0001, -0.015, -0.015, -0.015, -0.015, 0.0061, 0.0061, 1.53, 100, 0.006; ...
                    0.095, 0.095, 0.095, 0.095, 0.04, 0.04, 0.04, 0.04, 0.0235, 0.0245, 5.35, 450, 0.01];
prior.type = "uniform";
prior.paramNames = ["rate1", "rate2", "rate3", "rate4", "bias1", "bias2", "bias3" ...
    "bias4", "L1", "L2", "threshold", "non-decision time", "reselect"];


[t,h, p, n] = priorSummaryCheck(prior, 'test', 'run_ADDM');

