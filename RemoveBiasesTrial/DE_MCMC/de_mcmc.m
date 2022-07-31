function [p, varargout] = de_mcmc (fun, prior, varargin)
%%
% Differential evolution Markov chain Monte Carlo (DE-MCMC) algorithm [1]
%
% [] = de_mcmc (fun, prior) based on prior distribution finds
% posterior distribution and goodness of fit for the given function.
% FUN is a function handler. PRIOR is a 2-by-N matrix whose first row
% contains mean values for every parameter and second row contains standard
% deviations for every parameter.
%
% [] = de_mcmc (fun, prior, options) OPTIONS provide additional control
% over this algorithm.
%
% Inputs:
%           fun   - a likelihood function of the problem of interest.
%       Example: de_mcmc(@(x) fun(x,c))
%
%           prior - information for prior distribution. This could be a 2xN
%       matrix with first row containing mean values and second row
%       containing standard deviations for each variable. An interpretation
%       can be changed to the bounds of uniform distribution or additional
%       inputs to custom distribution. Check options for more information.
%
% options:
%           OnlyBestSearch - a choice to perform only parameter search and
%       return best solutions that were found.
%               Example: de_mcmc(@(x) fun(x), prior, 'OnlyBestSearch', ...)
%
%           OnlyPosterior - a choice to skip best parameter search. This
%       option has to follow with nGroups*groupSize by number of parameters
%       matrix for initialisation.
%               Example: de_mcmc(@(x) fun(x), prior, 'OnlyPosterior', X,
%       ...)
%           
%           goodnessOfFits - a choice to set goodness of fit values to the
%       initial parameters. This option is followed by a vector of a length 
%       equivalent to nGroups*groupSize.
%               Example: de_mcmc(@(x) fun(x), prior, 'OnlyPosterior', X,
%       'goodnessOfFists', Y)
%
%           nGenerations - a number of generations (DEFAULT value is 1000
%       and the same value is used for parameter search as well as
%       posterior sampling). In the event a different number of generations
%       is desired for two sampling modes. A list of two values can be
%       provided with first used for parameter fitting and second used for
%       posterior sampling.
%               Example: de_mcmc(@(x) fun(x), prior,, 'nGenerations', X,
%       ...)
%
%           nGroups - a number of groups (DEFAULT value is 1. Use more than
%       one group if multiple modes are expected. If unsure, run parameter
%       search with multiple groups and test if any groups are mutually
%       exclusive. This would be a good indication of possible
%       multi-modality in the system).
%               Example: de_mcmc(@(x) fun(x), prior, 'nGroups', X, ...)
%
%           groupSize - a preferred group size (DEFAULT value is a
%       multiplier 5 over the number of parameters. This value may not be
%       enough for highly complex posterior distributions but a very large
%       value can significantly slow sampling process. We recommend having
%       a look at acceptance rate after running parameter search. You
%       should expect it to settle to a fairly large value (e.g. 0.8). In
%       the event it is much lower, consider increasing it).
%               Example: de_mcmc(@(x) fun(x), prior, 'groupSize', X, ...)
%
%           noise - this value perturbs proposals by some noise value
%       (DEFAULT value is 0.001 and the same value is used for all
%       parameter values).
%               Example: de_mcmc(@(x) fun(x), prior, 'noise', X, ...)
%
%           boundedUniform - This option replaces a meaning of values
%       within PRIOR 2-by-N matrix where means with standard deviations are
%       replaced with a hard-bounded uniformal distribution for each
%       parameter. Upper row becomes a lower bound and bottom row an upper
%       bound.
%               Example: de_mcmc(@(x) fun(x), prior, 'prior', ...)
%
%           customPrior - This option replaces prior normal distribution
%       with some function provided by the user. This also replaces a
%       meaning of prior parameter values. This variable has to be a
%       cell with first value indicating the number of variables in the
%       model and the function of the custom prior distribution. In case 
%       a parameter fitting is being performed, another function should 
%       be provided for initial parameter generation.
%               Examples: 1) de_mcmc(@(x) fun(x), {1,@(x)wblpdf(x,A,B)},
%       'customPrior', 'OnlyPosterior', X, ...) - in this example
%       we use weibull distribution as prior where 'prior' parameter has
%       been replaced with scale and shift (A and B) values for weibull and
%       1 for the number of parameters.
%                         2) de_mcmc(@(x) fun(x), {1,@(x)wblpdf(x,A,B)},
%       'customPrior', @()wblrnd(A,B,1), ...) - here we also provided
%       'wblrnd' function for generating initial parameter values.
%
%           saveResults - An information indicating saving frequancy of the
%       results and the location the results have to be stored at. It
%       accepts either a number or a cell as an input. Providing a number
%       will use a default folder name. A cell should contain either a
%       number or a number with a string for the path to some folder.
%       (DEFAULT saving frequancy is 0 and folder is 'Results' within
%       working directory).
%               Example: de_mcmc(@(x) fun(x), prior, 'saveResults', {10,
%       'OverTheRainbow'},...). This will make an algorithm to save results
%       every tenth generation in the folder named 'OverTheRainbow'.
%
%           showProgress - provide this option if you want intermediate
%       results to be displayed (DEFAULT value is 0).
%               Example: de_mcmc(@(x) fun(x), prior, 'showProgress', 10,
%       ...). This command makes an algorithm display results every 10th
%       generation.
%
%           initParams - provide initial parameters for best solution
%       search instead of generating from prior distribution. This is a
%       useful feature when algorithm has failed to converge to some common
%       solution. It can be used in conjunction 'goodnessOfFits' to provide
%       likelihood values for these initial parameters. This option is 
%       followed by a vector of a length equivalent to nGroups*groupSize by 
%       number of parameters matrix for initialisation. Note that the
%       algorithm will handle nxm as well as 1xnxm situations.
%               Example: de_mcmc(@(x) fun(x), prior, 'initParams', X,
%       'goodnessOfFits', Y,....);
%
%           transitionMethod - There are three methods implemented. They are 
%             named after the paper we found them in. At present the Nelson
%             method is our favorite
%           'transitionMethod', {'method', params}
%            {'Braak'}  sets gamma to 2.38 / sqrt(2*n) togehether with
%            the noise parameter
%            {'Braak', gamma} togehether with
%            the noise parameter
%            {'Turner', min, max} gamma is uniformly disubuted between min
%            and max together with the noise parameter.
%            {'Nelson', sigma, targetRate}. This method
%            adjusts gamma to meet the target rate. If rate is below
%            0.5*targetRate it increases gamma by 1.1. If it is above
%            1.5*rate it decrease it by 0.9. If it is inbetween gamma is
%            changed by sqrt(actual rate/target rate.). The initial gamma
%            is  2.38 / sqrt(2*n). Gaussian noise (sigma) is also added to gamma.
%
%           parallelOn - this option turns on parallelisation feature that
%       distributes model evaluations acros CPU cores. If a specific number
%       of cores is desired, you should initialise worker pool before
%       running the code.
%               Example 1: de_mcmc(@(x) fun(x), prior, 'parallelOn');
%
%           mutationProbability - this option specifies the probability for
%       the mutation to occur within the chain. This option is only used 
%       for searching for best solutions and is very useful for global 
%       solution search in complex parameter space. A default mutation 
%       probability is 10%. This options takes values between in the range 
%       [0,1] though high probabilities are not recommended.
%               Example 1: de_mcmc(@(x) fun(x), prior,...
%       'mutationProbability', 0.05);
%
% Outputs:
%           posterior/finalPop  - posterior distribution/final population
%       of the simulations.
%           gof                 - corresponding goodness-of-fit
%           acceptanceRate      - acceptance rate over generations
%           bestParameterValues - best parameter values that were found
%           bestGOF             - best corresponding goodness-of-fit.
%
% Only Parameter search:
%   [bestParameterValues, bestGOF, acceptanceRate, finalPop, gof] =
% de_mcmc (...) returns posterior, goodness of fit, acceptance rate,
% best parameter values and best goodness of fit.
%
% Only Posterior sampling:
%   [posterior, gof, acceptanceRate] = de_mcmc (...) returns posterior,
% goodness of fit, acceptance rate, best parameter values and best goodness
% of fit.
%
% Both algorithms:
%   [bestParameterValues, bestGOF, acceptanceRate, posterior, gof] =
% de_mcmc (...) returns posterior, goodness of fit, acceptance rate,
% best parameter values and best goodness of fit.
%
% Author: Vilius Narbutas, Tjasa Kunavar, Dietmar Heinke (2016-2018)
% Email: viliusnarbutas90@gmail.com
% References: [1] Turner, Sederberg, Brown and Steyvers, "A Method for
% Efficiently Sampling from Distributions with Correlated Dimensions",
% Psychological methods, 2013.

%initial parameters
option=[];
postsam='on';
startParameters=[];

%going through options
args = varargin;
nargs = length(args);
i = 1 ;
while i<=nargs
    if ischar(args{i})
        switch args{i}
            case 'OnlyPosterior'
                startParameters = args{i+1};
                option='onlyPosterior';
                args(i+1)=[];
                args(i)=[];
                i = i + 1;
                break;
            case 'OnlyBestSearch'
                postsam = 'off';
                args(i)=[];
                break;
        end
    end
    i = i + 1;
end

%option 1: greedy part
if strcmp(postsam, 'off')
    [p,g,a,bp,bg]=greedy(fun, prior, args{:});
    
    %various outputs
    nout = max(nargout,1) - 1;
    varargout{1, length(nout)}=[];
    for k = 1:nout
        if k==1; varargout{k} = g; end
        if k==2; varargout{k} = a; end
        if k==3; varargout{k} = bp; end
        if k==4; varargout{k} = bg; end
    end
    
    %option 2: posterior sampling
elseif strcmp(option,'onlyPosterior')
    
    if max(nargout)>3
        error('Error: Too many outputs provided. Posterior sampling does not produce best solutions!');
    end
        
    [p,g,a]=posteriorsampling(fun, prior, startParameters, args{:});
    
    %various outputs
    nout = max(nargout,1) - 1;
    varargout{1, length(nout)}=[];
    for k = 1:nout
        if k==1; varargout{k} = g; end
        if k==2; varargout{k} = a; end
    end
    
    %option 3: greedy + posterior sampling
else
    [p, g, ~, pop, gof]=greedy(fun, prior, args{:});
    [bp,bg,a]=posteriorsampling(fun, prior, pop, args{:}, 'goodnessOfFit', gof);%,'approxErrorSigma',min(apErr));
    
    %various outputs
    nout = max(nargout,1) - 1;
    varargout{1, length(nout)}=[];
    for k = 1:nout
        if k==1; varargout{k} = g; end
        if k==2; varargout{k} = a; end
        if k==3; varargout{k} = bp; end
        if k==4; varargout{k} = bg; end
    end
end
end

