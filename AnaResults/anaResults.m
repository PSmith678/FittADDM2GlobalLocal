function anaResults(uid)

% Load in docufile
docu = load_docufile(uid);

nCond = 1;
% Extract stuff for plot.
%nCond = length(docu.post.res);
nParam = size(docu.post.res.posterior, 3);
plotDim = [4, 6];
plotGrid = reshape(1:nCond*(nParam+11),nParam+11,[])';

% Open figure
figure()

% Loop through conditions
for iCond = 1:nCond
    
    % Loop through and plot parameters.
params = {'Rate1', 'Rate2', 'Rate3', 'Rate4', 'Bias1', 'Bias2', 'Bias3', 'Bias4', 'L1', 'L2', 'Threshold', 'Non-Decision Time', 'IOR'};
for iParam = 1:nParam
subplot(plotDim(1),plotDim(2),plotGrid(iCond,iParam))
post = docu.post.res(iCond).posterior(501:end,:,iParam);
histogram(post(:)); title(sprintf('%s', params{iParam})); hold on;
param(iParam) = docu.best.res(iCond).bp(iParam);


% Uncomment this line if docufile has map estimates.
%param(iParam) = docu.post.res(iCond).map(iParam);

xline(param(iParam),'r','LineWidth',2);hold on
end


% Get simulated data
[like(iCond),simDat(:,iCond)] = logLike_kde(strcat('run_',docu.model.name),param,[],docu.model.loglikeFunc.para,docu.data.data(:,iCond));


%% CDF

for iCondition = 1:8
subplot(plotDim(1),plotDim(2),plotGrid(iCond,nParam+iCondition));
quantiles = .1:.2:1;


simCond = quantile(simDat(iCondition).rt_res1,quantiles);

datCon = quantile(docu.data.data(iCondition).rt_res1,quantiles);

plot(simCond,quantiles,'r-','LineWidth',2);hold on

plot(datCon,quantiles,'o','MarkerFaceColor','b');

ylabel('cdf');
title(sprintf('For %s', docu.data.selector.nCondLabel{iCondition}));
hold on



%% Acc
subplot(plotDim(1),plotDim(2),plotGrid(iCond,nParam + 9))

for iCondition = 1:8

Err(iCondition, 1)  = length(docu.data.data(iCondition).rt_res0)/length(docu.data.data(iCondition).response);


Err(iCondition, 2) = length(simDat(iCondition).rt_res0)/length(simDat(iCondition).response);
end 



bar(1:8, Err);
xticklabels(docu.data.selector.nCondLabel);
ylim([0 0.3]); title('Real and Predicted Error Rates');hold on;


%% Acceptance Rate
subplot(plotDim(1),plotDim(2),plotGrid(iCond,nParam + 10))
plot(1:500,docu.post.res(iCond).ar_post(1:500),'r-','LineWidth',2);
hold on
plot(501:3000-1,docu.post.res(iCond).ar_post(501:end),'k-','LineWidth',2);
title('Acceptance Rate')

end
%subplot(plotDim(1), plotDim(2), plotGrid(iCond, nParam + 11))
%title(sprintf('Gof =  %f', like(iCond)));
drawnow
sgtitle(sprintf('Participant %d with an AQ score of %d', uid, docu.data.selector.AQscore))
end

%set(gcf,'WindowStyle','docked');drawnow