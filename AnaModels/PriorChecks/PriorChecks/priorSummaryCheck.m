function [summary_table, helpfulStats, percentageGood, new_idx] = priorSummaryCheck(prior,fileName,fun)
%%Instructions
% The function can be used to simulate datasets from normal priors, uniform priors and custom priors.
%
% It expects 3 inputs:
% 1) prior: struct
% 2) filename: string (what to save results under)
% 3) name of function to be evaluated: string
%
% Normal Priors
% values
% Should be set out as follows, where each column represents a parameter.
% row1: mean of priors
% row2: sigma of priors
% row3: left truncations
% row4: right truncations
%
% type: "normal"
%
% paramNames: names of parameters as cell array;
%
%
%
% Uniform Priors
% values:
% Should be set out as follows, where each column represents a parameter.
% row1: lowerBound of Prior
% row2: upperBound of Prior
%
% type: "uniform"
%
% paramNames: names of parameters as cell array;
%
%
% Custom Priors
% Specify different priors for different parameters.
%
%  prior.priorRand = functions to generate random numbers.{'normTruncRnd','normTruncRnd','normTruncRnd','unifrnd'}
%
% values:
% prior.values{1} = {.2 .5 0 Inf}; % A
% prior.values{2} = {.4 .4 0 Inf}; % ter
% prior.values{3} = {.5 .5 0 Inf}; %p
% prior.values{4} = {.01 2.5};% rd
%
% paramNames: names of parameters as cell array;
%
% type: "custom"
%
%


% Number of Samples
N = 3000;
trialsPerSet = 200;
priorArgin = prior.values;
priorType = prior.type;
parameterNames = prior.paramNames;
[~,nParam] = size(priorArgin);
congruentColour = 'g';
incongruentColour = 'r';

switch priorType
    case 'uniform'
        
        % If uniform, sample from uniform priors.
        lowerBounds = priorArgin(1,:);
        upperBounds = priorArgin(2,:);
        inputNames = {'lowerBounds','upperBounds'};
        samples = rand(N, nParam).*(upperBounds-lowerBounds)+lowerBounds;
        
    case 'normal'
        
        % If normal, sample from normal priors.
        mu = priorArgin(1,:);
        sigma = priorArgin(2,:);
        leftTrunc = priorArgin(3,:);
        rightTrunc = priorArgin(4,:);
        inputNames = {'mu','sigma','leftTrunc','rightTrunc'};
        samples = normTruncRnd(mu,sigma,leftTrunc,rightTrunc,N);
        
    case 'custom'
        for iii = 1:nParam
            for iSample = 1:N
                funCall = str2func(prior.priorRand{iii});
                input = priorArgin{iii};
                input{1,end+1} = 1; % size input. we want 1 value...
                samples(iSample,iii) = funCall(input{:});
            end
            
        end
        
        % inputNames =prior.priorRand;
        
end


% Show Prior Samples
figure()
for iParam = 1:nParam
    subplot(1,nParam,iParam);
    histogram(samples(:,iParam));
    title(parameterNames{iParam});
    xlabel('Parameter Value');
end
sgtitle('Prior Samples');
set(gcf,'WindowStyle','docked');
drawnow


%% Create Summary Statistics
nCond = 8;
%Simulate Data for Each Parameter Set
parfor iSample = 1:N
    simDat(:,iSample) = feval(fun,samples(iSample,:),trialsPerSet)%,100);
end
% Summary Statistics: Change to adapt to task.
% Current setup: Flanker Task:
%simDat(1) = congruentTrials
%simDat(2) = incongruent Trials;

for iSample = 1:N
    for iCond = 1:nCond
    summary_table.Skew(iSample,iCond) = mean(simDat(iCond,iSample).rt_res1) - median(simDat(iCond,iSample).rt_res1);
    %summary_table.SkewIncon(iSample, :) = mean(simDat(2,iSample).rt_res1) - median(simDat(2,iSample).rt_res1);
    
    
    summary_table.MedianRT(iSample,iCond) = median(checkIfEmpty(simDat(iCond,iSample).rt_res1));
    %summary_table.MedianInconRT(iSample,:) = median(checkIfEmpty(simDat(2,iSample).rt_res1));
    summary_table.MinRT(iSample,iCond) = min(checkIfEmpty(simDat(iCond,iSample).rt_res1));
    %summary_table.MinInconRT(iSample,:) = min(checkIfEmpty(simDat(2,iSample).rt_res1));
    summary_table.MaxRT(iSample,iCond) = max(checkIfEmpty(simDat(iCond,iSample).rt_res1));
    %summary_table.MaxInconRT(iSample,:) = max(checkIfEmpty(simDat(2,iSample).rt_res1));
    
    
    rt(iSample).RT = simDat(iCond,iSample).rt_res1;
    %rt(iSample).InconRT = simDat(2,iSample).rt_res1;
    summary_table.Acc(iSample,iCond) = mean(simDat(iCond,iSample).response)*100;
    %summary_table.AccIncon(iSample,:) = mean(simDat(2,iSample).response)*100;
    end 
end
summary_table = [struct2table(summary_table) struct2table(rt)];




% classify good and bad
idx =  summary_table.Acc > 50 &... % Good accuracy
...%summary_table.AccIncon > 50 &  Good accuracy
summary_table.MedianRT < 2000 & ... % 
...%summary_table.MedianInconRT < 2000 & 
summary_table.MedianRT > 300 & ... % 
...%summary_table.MedianInconRT > 400 
...%summary_table.AccIncon - summary_table.AccCon < 50&... % accuracy CE is
...%sensible 
summary_table.Skew < 200 & summary_table.Skew > 0 & ... % good skewness (taken from rouselett paper but bit more liberal)
...%summary_table.SkewIncon < 100 & summary_table.SkewIncon > 0&...
summary_table.MinRT > 100  & ...
... %summary_table.MinInconRT > 100 & ... % based on idea that non decision time is at least 100ms
92 <= mean(summary_table.Acc, 1) & mean(summary_table.Acc, 1) <= 99 & ...
67 <= min(summary_table.Acc, [], 1) & min(summary_table.Acc, [], 1) <= 87 & ...
98 <= max(summary_table.Acc, [], 1) & max(summary_table.Acc, [], 1) <= 100;


for k = 1:height(summary_table)
    
    if idx(k, :)
    class{k} = "good";
    else
    class{k} = "bad";
    end     
    
end

figure()
new_idx = floor(sum(idx, 2)/8);
for iParam = 1:13
subplot(2,7,iParam)
boxplot(samples(find(new_idx), iParam), 'Color','g')
hold on
boxplot(samples(find(~new_idx), iParam), 'Color','r')
ylim([lowerBounds(1, iParam), upperBounds(1, iParam)])
end 




summary_table.class = class';
% %% Summary Figures
% %Plot individual samples: Not recommended for large N.
% 
% figure()
% fp = factorpairs(N);
% subLayout = fp(abs(fp(:,1) - fp(:,2)) == min(abs(fp(:,1) - fp(:,2))),:);
% for iSample = 1:N
% if N < 100
%     subplot(subLayout(2),subLayout(1),iSample);
% else
%     subplot(10,10,iSample);
% end
% 
% histogram(summary_table.ConRT{iSample},'FaceColor',congruentColour); hold on
% histogram(summary_table.InconRT{iSample},'FaceColor',incongruentColour);
% 
% title(sprintf('%.2f | %.2f | %.2f %.2f',samples(iSample,:)));
% %xlim([0 10000]);
% if mod(iSample,100) == 0
%     figure();
% end
% drawnow
% set(gcf,'WindowStyle','docked');
% end
% 

figure();
% Settings Table
if ~strcmp(priorType,'custom')
    hAx =  subplot(2,7,[6 7]);
    T = array2table(priorArgin','RowNames',parameterNames,'VariableNames',inputNames);
    uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
        'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',hAx.Position);
    delete(hAx)
end

% Summary Table
hAx =  subplot(2,7,[13 14]);
Array = nan(nCond,3);
for iCond = 1:nCond
 Array(iCond, :) = [mean(summary_table.Skew(:, iCond),'omitnan'),mean(summary_table.MedianRT(:, iCond),'omitnan'),mean(summary_table.Acc(:, iCond),'omitnan')];
end 
T = array2table(Array, 'RowNames', {'Condition1', 'Condition2', 'Condition3', 'Condition4','Condition5', ...
    'Condition6', 'Condition7', 'Condition8'}, 'VariableNames',{'Skew', 'MedianRT', 'Acc'});
uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
    'RowName',T.Properties.RowNames,'Units', 'Normalized', 'Position',hAx.Position);
delete(hAx)



% Skew
subplot(2,7,[1 8])
histogram(summary_table.Skew,'FaceColor',congruentColour); hold on
%histogram(summary_table.SkewIncon,'FaceColor',incongruentColour);
xline(mean(summary_table.Skew,'omitnan'),'-','Color',congruentColour,'LineWidth',2);
%xline(mean(summary_table.SkewIncon,'omitnan'),':','Color',incongruentColour,'LineWidth',2);
xlabel('Skewness')

% Median RT
subplot(2,7,[3 10])
histogram(summary_table.MedianRT,'FaceColor',congruentColour);hold on
%histogram(summary_table.MedianInconRT,'FaceColor',incongruentColour);
xline(mean(summary_table.MedianRT,'omitnan'),'-','Color',congruentColour,'LineWidth',2);
%xline(mean(summary_table.MedianInconRT,'omitnan'),':','Color',incongruentColour,'LineWidth',2);
xlabel('Average RT (ms)')

% Min RT
subplot(2,7,[2 9])
histogram(summary_table.MinRT,'FaceColor',congruentColour);hold on
%histogram(summary_table.MinInconRT,'FaceColor',incongruentColour);
xline(mean(summary_table.MinRT,'omitnan'),'-','Color',congruentColour,'LineWidth',2);
%xline(mean(summary_table.MinInconRT,'omitnan'),':','Color',incongruentColour,'LineWidth',2);
xlabel('Min RT (ms)')

% Max RT
subplot(2,7,[4 11])
histogram(summary_table.MaxRT,'FaceColor',congruentColour);hold on
%histogram(summary_table.MaxInconRT,'FaceColor',incongruentColour);
xline(mean(summary_table.MaxRT,'omitnan'),'-','Color',congruentColour,'LineWidth',2);
%xline(mean(summary_table.MaxInconRT,'omitnan'),':','Color',incongruentColour,'LineWidth',2);
xlabel('Max RT (ms)')

%
subplot(2,7,[5 12])
histogram(summary_table.Acc,'FaceColor',congruentColour);hold on
%histogram(summary_table.AccIncon,'FaceColor',incongruentColour);
xline(mean(summary_table.Acc),'-','Color',congruentColour,'LineWidth',2);
%xline(mean(summary_table.AccIncon),':','Color',incongruentColour,'LineWidth',2);
xlabel('Average Accuracy (%)');
sgtitle(sprintf('N = %d',N))
set(gcf,'WindowStyle','docked')


save(sprintf('PriorCheck_%s',fileName),'summary_table','prior')
savefig(gcf,sprintf('PriorCheck_%s',fileName))

helpfulStats = [mean(summary_table.Acc, 1); max(summary_table.Acc, [], 1); min(summary_table.Acc, [], 1)];
percentageGood = ((length(find(new_idx))/N) * 100);




%% Other Functions
    function pq = factorpairs(N)
        if nargin ~= 1
            error('FACTORPAIRS:invalidarguments','Exactly one argument must be provided.')
        end
        if isempty(N)
            % empty begets empty
            pq = [];
            return
        end
        % verify that N is scalar, positive integer
        if (numel(N) > 1) || (N <= 0) || (N~= round(N))
            error('FACTORPAIRS:invalidarguments','N must be scalar, positive, integer.')
        end
        % a few simple special cases
        if N == 1
            pq = [1 1];
            return;
        elseif isprime(N)
            pq = [1 N];
            return;
        end
        % N must now be composite. Extract the factors of N
        % This is why N must be no more than 2^32, as factor
        % will not accept any larger number. I could allow vpi
        % numbers here, I suppose...
        F = factor(N).';
        % Determine multiplicities of those factors
        [unikF,I,J] = unique(F);
        countF = accumarray(J,1);
        nF = numel(unikF);
        % for each unique factor, get the factor pairs
        pqF = cell(1,nF);
        for i = 1:nF
            % ni must always be at least 1
            ni = countF(i);
            Fi = unikF(i);
            if ni == 1
                % special case, a single prime factor
                fpows = [0 1];
            elseif mod(ni,2) == 0
                % general case: ni is even
                n2 = ni/2;
                fpows = [0:n2;ni:-1:n2].';
            else
                % general case: ni is odd
                n2 = (ni - 1)/2;
                fpows = [0:n2;ni:-1:(n2+1)].';
            end
            pqF{i} = Fi.^fpows;
        end
        % combine the factor pairs in pqF into one
        % set of factor pairs
        pq = pqF{1};
        for i = 2:nF
            pqi = pqF{i};
            pq = [[kron(pq(:,1),pqi(:,1)),kron(pq(:,2),pqi(:,2))]; ...
                [kron(pq(:,1),pqi(:,2)),kron(pq(:,2),pqi(:,1))]];
            pq = unique(sort(pq,2),'rows');
        end
    end


    function out = checkIfEmpty(in)
        
        if isempty(in)
            out = NaN;
        else
            out = in;
        end
    end


end
