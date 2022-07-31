%%
% [final_like, simDat,kde_rt] = logLike_kde(modelFunction, pars, ~, kde_para, realDat)
% Function that returns log-likelihood value combined from all conditions.
% Note that conditions have to have the same number of trials.
%
% Input: realDat - real data represented as a struct array. Each struct
%   contains rt and accuracy components (Example: realDat(2).rt and
%   realDat(2).accuracy). The realDat parameter also has threshold
%   component to indicate the probability of the point existing.
%        kdeThr - an accuracy threshold of oKDE. Its default value is 0.02
%   though smaller may be desirable for higher precision. It highly depends
%   on the amount of data per distribution. I recommend using 0.02 when
%   simulated data is relatively small (~100 points) and reduce when
%   higher number of simulations are used. Values that are too small may
%   also be detriment to the performance I generally limit the threshold to
%   0.001 as the lowest value.
%        modelFunction - the command for initiating model simulations.
%        pars - the parameters of the model
%

function [final_like, simDat,kde_rt,like] = logLike_kde(modelFunction, pars, ~, kde_para, realDat)%


simDat = feval(modelFunction,pars, kde_para.trials);

nConditions = length(realDat);
like =  nan(1,nConditions);
kde_rt = repmat(struct('kde_rt_res1', [], 'kde_rt_res0', []), nConditions, 1);

for k = 1:nConditions

    nTotalSim = length(simDat(k).rt_res1) + length(simDat(k).rt_res0);
    nTotalReal = length(realDat(k).rt_res1) + length(realDat(k).rt_res0);

    % This block deals with res1, typically accurate responses.
    try
        nSim1 = length(simDat(k).rt_res1);
        pSim1 = nSim1 / nTotalSim;

        kde_rt_res1 = quickStart_oKDE(simDat(k).rt_res1, kde_para.kdeThr, []);
        kde_rt(k).kde_rt_res1 = kde_rt_res1;

        [~, m] = size(realDat(k).rt_res1);

        % Calculating the probabilities that the model generates the data
        % points for res1
        if m == 1
            probsRes1 = evaluateDistributionAt(kde_rt_res1.pdf.Mu, kde_rt_res1.pdf.w, kde_rt_res1.pdf.Cov, realDat(k).rt_res1');
        else
            probsRes1 = evaluateDistributionAt(kde_rt_res1.pdf.Mu, kde_rt_res1.pdf.w, kde_rt_res1.pdf.Cov, realDat(k).rt_res1);

        end

        % If the calculation of the probabilities is not sensical replace
        % them with a meaningful value.
        idx = find(probsRes1<realDat(k).thr_res1*kde_para.prob_thres | isnan(probsRes1));
        probsRes1(idx) = kde_para.prob_thres*realDat(k).thr_res1;

        % The mulitplication with pSim1 takes into account the model's probility of
        % generating res1-responses (res1 is typically accurate
        % responses).
        probsRes1 = log(pSim1 * probsRes1);



    catch ME
        % in case the kde fails the probabilies for probsRes1 are replace
        % with a meaningful value.
        probsRes1 = nan(length(realDat(k).rt_res1),1);
        probsRes1(1:length(realDat(k).rt_res1)) = (kde_para.prob_thres*realDat(k).thr_res1);
        probsRes1 =  log(pSim1* probsRes1);
    end

    % This block deals with res0 typically incorrect responses.
    n0 = length(simDat(k).rt_res0);
    pSim0 = n0 / nTotalSim;

    if isnan(realDat(k).thr_res0)
        % In case there are not enough data to determine likelihoods for
        % RTs in res0 only the likelihood for responses (accuracy) is determined.
        % Normally the equation for this is log(p(model))*(number of res0).
        % However, if the model does not produce any res0-responses the
        % p(model) needs to be replace with a meaningful value.
        model_prob = max([pSim0,kde_para.prob_thres *(length(realDat(k).rt_res0) / nTotalReal), realmin]);
        probsRes0 = log(model_prob)*length(realDat(k).rt_res0);

    else
        % enought RTs to determine to take RTs into account for the
        % likelihood.
        try
            if ~isempty(simDat(k).rt_res0)
                kde_rt_res0 = quickStart_oKDE(simDat(k).rt_res0, kde_para.kdeThr, []);
                kde_rt(k).kde_rt_res0 = kde_rt_res0;

                [~, m] = size(realDat(k).rt_res0);
                if m == 1
                    probsRes0 = evaluateDistributionAt(kde_rt_res0.pdf.Mu, kde_rt_res0.pdf.w, kde_rt_res0.pdf.Cov, realDat(k).rt_res0');
                else
                    probsRes0 = evaluateDistributionAt(kde_rt_res0.pdf.Mu, kde_rt_res0.pdf.w, kde_rt_res0.pdf.Cov, realDat(k).rt_res0);

                end

                % If KDE does not produce meaningful values, they are
                % replaced with meaningful values.
                if any(~isreal(kde_rt_res0.pdf.Mu)) || any(~isreal(probsRes0)) || any(~isreal(log(probsRes0)) || any(isnan(probsRes0)))

                    probsRes0(1:length(realDat(k).rt_res0)) = kde_para.prob_thres*realDat(k).thr_res0;
                else

                    probsRes0(probsRes0<realDat(k).thr_res0*kde_para.prob_thres) = kde_para.prob_thres*realDat(k).thr_res0;

                end
                probsRes0 = pSim0 * probsRes0;
            else
                % if the model has not produced any res0-responses, replace
                % with meanngful value.
                probsRes0 = nan(length(realDat(k).rt_res0),1);
                %                probsRes0(1:length(realDat(k).rt_res0)) = kde_para.prob_thres * (length(realDat(k).rt_res0) / (nTotalReal))^(length(realDat(k).rt_res0) + length(realDat(k).rt_res1)) * kde_para.prob_thres*realDat(k).thr_res0;
                probsRes0(1:length(realDat(k).rt_res0)) = (kde_para.prob_thres * length(realDat(k).rt_res0) / (nTotalReal)) * kde_para.prob_thres*realDat(k).thr_res0;
            end
            probsRes0 = log(probsRes0);

        catch ME
            probsRes0 = nan(length(realDat(k).rt_res0),1);

            probsRes0(1:length(realDat(k).rt_res0)) = kde_para.prob_thres * length(realDat(k).rt_res0) / (nTotalReal) * kde_para.prob_thres*realDat(k).thr_res0;
            probsRes0 = log(probsRes0);


        end

    end
    % logbinoApprox determines the binomial coefficient to take into
    % account the number of res0- and res1-responses.
    like(k) = logbinoApprox(nTotalReal, length(realDat(k).rt_res1)) + sum(probsRes0) + sum(probsRes1);
    simDat(k).tmax = max([realDat(k).rt_res0; realDat(k).rt_res1]);
    simDat(k).delta = 1;


  %  nTotalSim = length(simDat(k).rt_res1) + length(simDat(k).rt_res0);
  %  nSim1 = length(simDat(k).rt_res1);
  %  pSim1 = nSim1 / nTotalSim;
  %  simDat(k).pdf1 = pSim1 * evaluateDistributionAt(kde_rt_res1.pdf.Mu, kde_rt_res1.pdf.w, kde_rt_res1.pdf.Cov, 1:simDat(k).tmax);
  %  nSim0 = length(simDat(k).rt_res0);
  %  pSim0 = nSim0 / nTotalSim;
  %  simDat(k).pdf0 = pSim0 * evaluateDistributionAt(kde_rt_res0.pdf.Mu, kde_rt_res0.pdf.w, kde_rt_res0.pdf.Cov, 1:simDat(k).tmax);
    %     figure
    %     plot(evaluateDistributionAt(kde_rt_res1.pdf.Mu, kde_rt_res1.pdf.w, kde_rt_res1.pdf.Cov, 1:50000));
    %
    %     pause
end

final_like = sum(like) ;
if ~isreal(final_like) || isnan(final_like)
    save('complex_debug2');
    error('complex likelihood');
end
end




