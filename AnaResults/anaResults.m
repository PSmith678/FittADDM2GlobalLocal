function anaResults(uid)

% Load in docufile
docu = load_docufile(uid);

nCond = 1;
% Extract stuff for plot.
%nCond = length(docu.post.res);
nParam = size(docu.post.res.posterior, 3);
plotDim = [4, 6];
plotGrid = reshape(1:nCond*(nParam+10),nParam+10,[])';

% Open figure
figure(uid)

% Loop through conditions
for iCond = 1:nCond
    
    % Loop through and plot parameters.
for iParam = 1:nParam
subplot(plotDim(1),plotDim(2),plotGrid(iCond,iParam))
post = docu.post.res(iCond).posterior(501:end,:,iParam);
histogram(post(:));hold on
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
title(sprintf('Gof = %.3f for %s',like(iCond), docu.data.selector.nCondLabel{iCondition}));
hold on



%% Acc
subplot(plotDim(1),plotDim(2),plotGrid(iCond,nParam + 9))

for iCondition = 1:8

Err(iCondition, 1)  = length(docu.data.data(iCondition).rt_res0)/length(docu.data.data(iCondition).response);


Err(iCondition, 2) = length(simDat(iCondition).rt_res0)/length(simDat(iCondition).response);
end 



bar(1:8, Err);
xticklabels(docu.data.selector.nCondLabel);
ylim([0 1]);hold on;


%% Acceptance Rate
subplot(plotDim(1),plotDim(2),plotGrid(iCond,nParam + 10))
plot(1:500,docu.post.res(iCond).ar_post(1:500),'r-','LineWidth',2);
hold on
plot(501:3000-1,docu.post.res(iCond).ar_post(501:end),'k-','LineWidth',2);
title('Acceptance Rate')
end
drawnow

end

%set(gcf,'WindowStyle','docked');drawnow