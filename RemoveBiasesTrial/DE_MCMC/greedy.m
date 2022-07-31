function [bestParameters, varargout] = greedy (fun, prior, varargin)
%%
% Greedy algorithm [1].
%
% Author: Vilius Narbutas, Tjasa Kunavar, Dietmar Heinke (2016-2018)
% Email: viliusnarbutas90@gmail.com
%
% [1] Turner, Sederberg, Brown and Steyvers, "A Method for Efficiently
% Sampling from Distributions with Correlated Dimensions", Psychological
% methods, 2013.
%
% -------------------------------------------------------------------------

% initialise variables
if iscell(prior)
    nParameters = prior{1};
else
    nParameters=length(prior(1,:));
end
nGenerations = 1000;
nGroups=1;
dNoise=[];
priorOption='n';
dis1 = 1; dis2 = 1;
saveResults=[];
p=0;

showProgress = 0;
approxErrorPrior = [];
groupSize=nParameters*5;
initParams = [];
initGofs = [];
parallelOn = 0;
mutProb = 0.1;

%optional parameters
args = varargin;
nargs = length(args);
i = 1 ;

% options
while i <= nargs
    switch args{i}
        case 'nGroups', nGroups = args{i+1} ; i = i + 2 ;
        case 'nGenerations', nGenerations = args{i+1} ; i = i + 2 ;
        case 'transitionMethod', transM = args{i+1} ; i = i + 2 ;
        case 'groupSize', groupSize=args{i+1}; i= i+2;
        case 'boundedUniform', priorOption = 'range' ; i = i + 1 ;
        case 'saveResults', saveInfo = args{i+1} ;saveResults='save'; i = i + 2 ;
        case 'customPrior', priorOption='d'; funct = prior{2}; rFun = args{i+1}; i=i+2;
        case 'showProgress', showProgress = args{i+1}; i = i + 2;
        case 'noise', dNoise = args{i+1}; i = i+2;
        case 'initParams', initParams = args{i+1}; i=i+2;
        case 'goodnessOfFits', initGofs = args{i+1}; i=i+2;
        case 'parallelOn', parallelOn = 1; i=i+1;
        case 'mutationProbability', mutProb = args{i+1}; i = i+2;
        case 'resampleProb', resampleProb = args{i+1}; i = i+2;
        otherwise
            error('Unknown switch "%s"!',args{i}) ;
    end
end

% prior
if strcmp(priorOption, 'range')
    lowerBounds = prior(1,:);
    upperBounds = prior(2,:);
elseif strcmp(priorOption, 'n')
    mu=prior(1,:);
    sigma=prior(2,:);
end

% transistion method
if isempty(transM)
    error('No transistion method defined. It is possible that you use an old demcmc call.');
end

switch char(transM{1})
    case 'Braak'
        if length(transM) == 1
            transFlag = 1;
            transParam = 2.38/sqrt(2*nParameters);
        else
            transFlag = 1;
            transParam = transM{2};
        end
    case 'Turner'
        transFlag = 3;
        transParam(1) = transM{2};
        transParam(2) = transM{3};
    case 'Nelson'
        transFlag = 4;
        transParam(1) = transM{2};
        transParam(2) = 2.38/sqrt(2*nParameters);
        targetRate = transM{3};
    otherwise
        error ('Unknown transition method');
        
end
d=isempty(dNoise);
if d==1
    dNoise=0.001;
end

% Start counting time
if showProgress > 0
   tic;
end

% Define the number of generations
if length(nGenerations)==2
    nGenerations = nGenerations(1);
end

%create folder to save files
if strcmp(saveResults, 'save')
    if iscell(saveInfo)
        saveStep = saveInfo{1};
        if length(saveInfo)==2
            saveFolder = saveInfo{2};
        else
            saveFolder = 'Results';
        end
    else
        saveStep = saveInfo;
        saveFolder = 'Results';
    end
    ex=exist(saveFolder, 'dir');
    if ex~=7
        mkdir(saveFolder);
    else
        warning('Saving results in this folder may override results produced in previous session!');
    end
end

populationSize=nGroups*groupSize;
pop = zeros(nGenerations, populationSize, nParameters);
bestParameterSet.pars= zeros(nGroups, nParameters);
gof = -Inf * ones(nGenerations,populationSize);
bestParameterSet.gof = ones(1,nGroups)*gof(1,1);
acceptanceRate=zeros(1, nGenerations-1)';
bestPreviousGenParameters = bestParameterSet;

% First chunk: Initialisation
for group = 1:nGroups
    for j = 1:groupSize
        gr=(group-1)*groupSize;
        while gof(1,j+gr) == -Inf || isnan (gof(1,j+gr))
            
            % Compute distance values
            rng('shuffle');
            if ~isempty(initParams)
                pop(1,j+gr,:) = initParams(j+gr,:);
            elseif strcmp(priorOption, 'range')
                pop(1,j+gr,:) = rand(1, nParameters).*(upperBounds-lowerBounds)+lowerBounds;
            elseif strcmp(priorOption, 'n')
                pop(1,j+gr,:) = randn(1, nParameters).*sigma+mu;
            else
                pop(1,j+gr,:) = rFun();
            end
            
            if isempty(initGofs)
                gof(1,j+gr) = feval(fun, squeeze(pop(1,j+gr,:))');
            else
                gof(1,j+gr) = initGofs(j+gr);
            end
            if gof(1,j+gr) > bestParameterSet.gof(group)
                bestParameterSet.gof(group) = gof(1,j+gr);
                bestParameterSet.pars(group,:) = squeeze(pop(1,j+gr,:))';
                bestPreviousGenParameters = bestParameterSet;
            end
        end
    end
end

% Second chunk: Combining parameter sets to generate new.
% Sampling;
accepted=0;
for i = 2:nGenerations
    for group = 1:nGroups
        gr=(group-1)*groupSize;
        newPop = ProposalHandling(squeeze(pop(i-1,(gr+1):(gr+groupSize),:)), groupSize, dNoise, nParameters, transFlag, transParam, bestPreviousGenParameters.pars(group,:), 'greedy');
%        newPop = ProposalHandling(squeeze(pop(i-1,(gr+1):(gr+groupSize),:)), groupSize, dNoise, nParameters, gammaOrg, bestParameterSet.pars(group,:), 'greedy');
        pop(i,:,:) = newPop;
        
        % Choose mutations
        mutations = rand(1,groupSize);
        for j = 1:groupSize
            % Get Prior values.
            if mutations(j)<mutProb
                dis1(j) = 0;
                dis2(j) = 0;
            elseif strcmp(priorOption, 'd')
                dis1(j)=funct(pop(i-1,j+gr,:));
                dis2(j)=funct(newPop(j,:));
            elseif strcmp(priorOption, 'n')
                dis1(j)=normpdf(pop(i-1,j+gr,:), mu, sigma);
                dis2(j)=normpdf(newPop(j,:), mu, sigma);
            elseif (sum((newPop(j,:)>upperBounds))>0)||(sum((newPop(j,:)<lowerBounds))>0)
                dis2(j) = 0;
                dis1(j) = 0;
            else
                dis2(j) = 1;
                dis1(j) = 1;
            end
        end
        gof(i,(gr+1):(gr+groupSize)) = populationEvaluation(fun,newPop,groupSize,dis2,parallelOn);
        
        % Check if it is the new best
        for j = 1:groupSize
            if gof(i,j+gr) > bestParameterSet.gof(group)
                %                     display(gof(i,j+gr));
                bestParameterSet.gof(group) = gof(i,j+gr);
                bestParameterSet.pars(group,:) = newPop(j,:);
            end
        end
        
        % Map likelihoods through error approximation function
        rng('shuffle');
        [gofsOut, popOut, acceptOut] = ProposalAcceptance(gof((i-1):i,(gr+1):(gr+groupSize)), pop((i-1:i),(gr+1):(gr+groupSize),:), groupSize, [dis1;dis2],fun,resampleProb);
        gof(i,(gr+1):(gr+groupSize)) = gofsOut((gr+1):(gr+groupSize));
        pop(i,(gr+1):(gr+groupSize),:) = popOut((gr+1):(gr+groupSize),:);
        accepted = accepted + sum(acceptOut);
            
        % Mutate
        for j = 1:groupSize
            if mutations(j)<mutProb
                if i<=(nGenerations-5)
                    if strcmp(priorOption, 'range')
                        pop(i,j+gr,:) = rand(1, nParameters).*(upperBounds-lowerBounds)+lowerBounds;
                    elseif strcmp(priorOption, 'n')
                        pop(i,j+gr,:) = randn(1, nParameters).*sigma+mu;
                    else
                        pop(i,j+gr,:) = rFun();
                    end
                    gof(i,j+gr) = feval(fun, squeeze(pop(i,j+gr,:))');
                    while gof(i,j+gr) == -Inf || isnan (gof(i,j+gr))
                        rng('shuffle');
                        if strcmp(priorOption, 'range')
                            pop(i,j+gr,:) = rand(1, nParameters).*(upperBounds-lowerBounds)+lowerBounds;
                        elseif strcmp(priorOption, 'n')
                            pop(i,j+gr,:) = randn(1, nParameters).*sigma+mu;
                        else
                            pop(i,j+gr,:) = rFun();
                        end
                        gof(i,j+gr) = feval(fun, squeeze(pop(i,j+gr,:))');
                    end
                    rng('shuffle');
                end
            end
        end
    end
    
    %calculating acceptance rate for every generation
    acRate=accepted/((i-1)*groupSize*nGroups);
    acceptanceRate(i-1)=acRate;
    if transFlag == 4
        if acRate <= targetRate*0.5
            transParam(2) = transParam(2) * 0.9;
        end
        
        if acRate >= targetRate*1.5
            transParam(2) = transParam(2) * 1;
        end
        
        if acRate < targetRate*1.5 && acRate > targetRate*0.5
            transParam(2)  = transParam(2)  * sqrt(acRate/targetRate);
        end
    end    
    % Third chunk: Moving parameter sets between groups.
    % Migration
    % Decide how many groups will be involved in migration
    k = randi(nGroups,1);
    
    % Produce the order of groups to migrate
    order = ones(1,nGroups);
    for iter = 2:nGroups
        order(iter) = order(iter-1)+1;
    end
    order = order(randperm(nGroups));
    order = order(1:k);
    
    % Select individual members of each group based on their fitness
    if length(order) >= 2
        individual=zeros(k, nParameters);
        idxs=zeros(k);
        for iter = 1:k
            group = (order(iter)-1);
            index = gof(i,group*groupSize+1:group*groupSize+groupSize);
            probs = exp(index);
            probs = 1-(probs/sum(probs));
            for prob = 2:groupSize
                probs(prob) = probs(prob-1)+probs(prob);
            end
            r = rand(1);
            selection = find(r<=probs,1);
            individual(iter,:) = squeeze(pop(i,group*groupSize+selection,:))';
            idxs(iter) = group*groupSize+selection;
        end
        
        % Migrate
        for iter = 2:k
            pop(i,idxs(iter),:) = individual(iter-1,:);
            gof(i,idxs(iter)) = feval(fun, individual(iter-1,:));
        end
        
        pop(i,idxs(1),:) = individual(end,:);
        gof(i,idxs(1)) = feval(fun, individual(end,:));
    end
 
    % find best parameter in the current generation to be used in proposal
    % handling in the next iteration. 
    for group = 1:nGroups
        bestPreviousGenParameters.gof(group) = -inf;
        bestPreviousGenParameters.pars(group,:) = nan(1, nParameters);

        for j = 1:groupSize
            gr=(group-1)*groupSize;
            
            if gof(i,j+gr) > bestPreviousGenParameters.gof(group)
                bestPreviousGenParameters.gof(group) = gof(i,j+gr);
                bestPreviousGenParameters.pars(group,:) = squeeze(pop(i,j+gr,:))';
            end
        end
    end

    
    % show progress
    if rem(i, showProgress) == 0 && showProgress > 0
        timePassed = toc;
        pCompleted = i/nGenerations*100;
        tComplete = (nGenerations-i)/showProgress*timePassed;
        
        tName = 'seconds';
        if tComplete >= 86400
            tComplete = tComplete/86400;
            tName = 'days';
        elseif tComplete >= 3600
            tComplete = tComplete/3600;
            tName = 'hours';
        elseif tComplete >= 60
            tComplete = tComplete/60;
            tName = 'minutes';
        end
        display(sprintf('\n%.2f%% completed. \nPredicted completion of parameter search in %.2f %s.',pCompleted,tComplete,tName));
        
        if nGenerations-i >= showProgress
            tic;
        end
    end
        
    % saving results
    if strcmp(saveResults, 'save')
        if rem(i, saveStep)==0
            bestParams = bestParameterSet.pars;
            bestParamsFitness = bestParameterSet.gof;
            lastGeneration = squeeze(pop(i,:,:));
            lastFitness = gof(i,:);
            s1=sprintf('./%s/bestSearch_bestParameters_%d', saveFolder, i);
            save(s1,'bestParams','bestParamsFitness');
            s2=sprintf('./%s/bestSearch_acceptanceRate', saveFolder);
            save(s2,'acceptanceRate');
            s3 = sprintf('./%s/bestSearch_lastGeneration_%d', saveFolder, i);
            save(s3,'lastGeneration','lastFitness');
%             if count>10
%                 break;
%             end
        end
%         count = count + 1;
    end
%     subplot(3,1,1)
%     t(i)=mean(approxErrorPars(i,:));
%     plot(max([i-1000,1]):i,t(max([i-1000,1]):end));
%     subplot(3,1,2);
%     plot(max([i-1000,1]):i,acceptanceRate(max([i-1000,1]):i));
%     subplot(3,1,3);
%     t2(i)=mean(gof(i,:));
%     plot(max([i-10,2]):i,t2(max([i-10,2]):end));
%     pause(0.01);
end

% output options
bestParameters=bestParameterSet.pars;
nout = max(nargout,1) - 1;
varargout{1, length(nout)}=[];
for k = 1:nout
    if k==1; varargout{k} = bestParameterSet.gof; end
    if k==2; varargout{k} = acceptanceRate; end
    if k==3; varargout{k} = squeeze(pop(i,:,:)); end
    if k==4; varargout{k} = gof(i,:); end
end
end