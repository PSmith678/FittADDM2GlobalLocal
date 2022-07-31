function [marginalLikelihood, pop, gof,varargout] = runTide(fun, prior, startParameters, varargin)
%%
% Implementation of TIDE [1].
%
% Author:Dietmar Heinke (2020-)
% Email: d.g.heinke@bham.ac.uk
%
% [1] Annis et al. (2019)
%
% -------------------------------------------------------------------------

% initialise parameters
if iscell(prior)
    nParameters = prior{1};
else
    nParameters=length(prior(1,:));
end

nGenerations = 1000;
nGroups = 1;
dNoise=[];
optionGof=[];
priorOption='n';
dis1 = 1; dis2 = 1;
saveResults=[];
transM = {};
showProgress = 0;
parallelOn = 0;

% optional parameters
args = varargin;
nargs = length(args);
i = 1 ;

groupSize=nParameters*5;

%options
while i <= nargs
    if ischar(args{i})
        switch args{i}
            case 'nGroups', nGroups = args{i+1} ; i = i + 2 ;
            case 'nGenerations', nGenerations = args{i+1} ; i = i + 2 ;
            case 'transitionMethod', transM = args{i+1} ; i = i + 2 ;
            case 'groupSize', groupSize=args{i+1}; i= i+2;
            case 'saveResults', saveInfo = args{i+1} ;saveResults='save'; i = i + 2 ;
            case 'boundedUniform', priorOption = 'range'; i = i + 1;
            case 'goodnessOfFit', startGof = args{i+1}; optionGof='gof' ; i = i + 2 ;
            case 'customPrior', priorOption='d'; funct = prior{2}; i=i+1;
            case 'showProgress', showProgress = args{i+1}; i = i + 2;
            case 'noise', dNoise = args{i+1}; i=i+2;
            case 'parallelOn', parallelOn = 1; i=i+1;
            case 'resampleProb', resampleProb = args{i+1}; i = i + 2;
            otherwise
                %                 error('Unknown switch "%s"!',args{i}) ;
                i = i + 1;
        end
    else
        i = i + 1;
    end
end

% prior
if strcmp(priorOption, 'range')
    lowerBounds = prior(1,:);
    upperBounds = prior(2,:);
    
    % DH: added to check whether startParameters fall into the bounds.
    % If not remove them and replace them with random existing values and issue a warning.
    if length(size(startParameters))==3
        startParameters = squeeze(startParameters);
    elseif size(startParameters,1)==1
        startParameters = startParameters';
    end
    [generations_n, para_n] = size(startParameters);
    k = 1;
    outside_generation = [];
    for generations_i=1:generations_n
        flag = 0;
        for para_i=1:para_n
            if startParameters(generations_i,para_i) < lowerBounds(para_i) || startParameters(generations_i,para_i) > upperBounds(para_i)
                flag = 1;
            end
        end
        if flag > 0
            outside_generation(k) = generations_i;
            k = k + 1;
        end
        
        
    end
    
    if k > 1
        warning('Some startparameters are being replaced because they fell outside the bounds of the prior');
        for i=k-1:-1:1
            startParameters(outside_generation(i),:) = [];
            if strcmp(optionGof, 'gof')
                startGof(outside_generation(i)) = [];
            end
        end
        [generations_n, para_n] = size(startParameters);
        for i=1:k-1
            j = randi(generations_n,1,1);
            startParameters(end+1,:) = startParameters(j, :);
            if strcmp(optionGof, 'gof')
                startGof(end+1) = startGof(j);
            end
            
        end
        
    end
    
    
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
    nGenerations = nGenerations(2);
end

%create folder to save files
if strcmp(saveResults, 'save')
    if iscell(saveInfo)
        saveStep = saveInfo{1};
        if length(saveInfo)==2
            saveFolder = saveInfo{2};
        else
            saveFolder = 'Results';
            warning('Saving results with a default option may override results produced in previous session!');
        end
    else
        saveStep = saveInfo;
        saveFolder = 'Results';
        warning('Saving results with a default option may override results produced in previous session!');
    end
    ex=exist(saveFolder, 'dir');
    if ex~=7
        mkdir(saveFolder);
    end
end

populationSize=nGroups*groupSize;
pop = zeros(nGenerations, populationSize, nParameters);
pop(1,:,:)=startParameters;
gof = -Inf * ones(nGenerations,populationSize);
p = 0;
acceptanceRate=zeros(1,nGenerations-1);

if strcmp(optionGof, 'gof')
    gof(1,:)=startGof;
else
    if length(size(startParameters))==3
        startParameters = squeeze(startParameters);
    elseif size(startParameters,1)==1
        startParameters = startParameters';
    end
    for iter = 1:populationSize
        gof(1,iter) = feval(fun, startParameters(iter,:));
    end
end

% Second chunk: Combining parameter sets to generate new.
% Posterior sampling;
sGof = gof(1,:)';
% post = reshape(pop(1,:,1:nParameters),[length(sGof),nParameters]);
% post = [post, sGof];

[bestParameterSet.gof,loc] = max(gof(1,:));
bestParameterSet.pars = squeeze(pop(1,loc,:))';

% set up temporal schedule
ALPHA = 0.3;
temperature = (((1:groupSize) - 1) / (groupSize-1)).^ (1/ALPHA);


accepted=0;
for i = 2:nGenerations
    for group = 1:nGroups
        gr=(group-1)*groupSize;
        newPop = ProposalHandling(squeeze(pop(i-1,(gr+1):(gr+groupSize),:)), groupSize, dNoise, nParameters, transFlag, transParam, bestParameterSet.pars(group,:), 'post');
        pop(i,:,:) = newPop;
        
        % Choose mutations
        mutations = rand(1,groupSize);
        for j = 1:groupSize
            % Get Prior values.
            if mutations(j)<0
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
        [gofsOut, popOut, acceptOut] = ProposalAcceptanceTIDE(gof((i-1):i,(gr+1):(gr+groupSize)), pop((i-1:i),(gr+1):(gr+groupSize),:), groupSize, [dis1;dis2], temperature,fun,resampleProb);
        gof(i,(gr+1):(gr+groupSize)) = gofsOut((gr+1):(gr+groupSize));
        pop(i,(gr+1):(gr+groupSize),:) = popOut((gr+1):(gr+groupSize),:);
        accepted = accepted + sum(acceptOut);
        
        % Mutate
        for j = 1:groupSize
            if mutations(j)<0
                pop(i,j+gr,:) = rand(1, nParameters).*(upperBounds-lowerBounds)+lowerBounds;
                gof(i,j+gr) = feval(fun, squeeze(pop(i,j+gr,:))');
                while gof(i,j+gr) == -Inf || isnan (gof(i,j+gr))
                    rng('shuffle');
                    pop(i,j+gr,:) = rand(1, nParameters).*(upperBounds-lowerBounds)+lowerBounds;
                    gof(i,j+gr) = feval(fun, squeeze(pop(i,j+gr,:))');
                end
                rng('shuffle');
            end
        end
    end
    
    % calculating acceptance rate
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
    
    % Select individual members of each group based on their
    % fitness
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
    
    % show progress
    if rem(i, showProgress) == 0 && showProgress > 0
        timePassed = toc;
        pCompleted = i/nGenerations*100;
        tComplete = (nGenerations-i)/showProgress*timePassed;
        
        tName = 'seconds';
        if tComplete >= 86400
            tComplete = tComplete/86400;
            tName = 'days';
        elseif tComplete >= 3600;
            tComplete = tComplete/3600;
            tName = 'hours';
        elseif tComplete >= 60
            tComplete = tComplete/60;
            tName = 'minutes';
        end
        display(sprintf('\n%.2f%% completed. \nPredicted completion of posterior sampling in %.2f %s.',pCompleted,tComplete, tName));
        
        if nGenerations-i >= showProgress
            tic;
        end
    end
    
    % option to save intermidiate results (not finished)
    if strcmp(saveResults, 'save')
        if rem(i, saveStep)==0
            s1=sprintf('./%s/posterior_%d', saveFolder, i);
            posteriorSubset=pop((i-saveStep+1):i,:,:);
            lastPopulation = pop(i,:,:);
            save(s1,'posteriorSubset', 'lastPopulation');
            s2=sprintf('./%s/posterior_gof_%d', saveFolder, i);
            goodnessOfFitSubset=gof((i-saveStep+1):i,:);
            lastGoodnessOfFit = gof(i,:);
            save(s2,'goodnessOfFitSubset', 'lastGoodnessOfFit');
            s3=sprintf('./%s/posterior_acceptanceRate', saveFolder);
            save(s3,'acceptanceRate');
        end
    end
end
if strcmp(saveResults, 'save')
    s1=sprintf('./%s/posterior_final', saveFolder);
    lastPopulation = pop(nGenerations,:,:);
    lastGoodnessOfFit = gof(nGenerations,:);
    save(s1,'pop', 'gof', 'lastPopulation','lastGoodnessOfFit');
end

% output options
nout = max(nargout,1) - 1;
varargout{1, length(nout)}=[];
for k = 1:nout
    if k==1; varargout{k} = gof; end
    if k==2; varargout{k} = acceptanceRate; end
end

marginalLikelihood = 0;
for k=2:groupSize
    marginalLikelihood = marginalLikelihood + ((temperature(k) - temperature(k-1))/2 * (mean((squeeze(gof(:,k)))) + mean((squeeze(gof(:,k-1))))));
end
marginalLikelihood = exp(marginalLikelihood);
end
