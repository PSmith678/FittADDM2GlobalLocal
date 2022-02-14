%%
% This function computes points existance probability for each reaction
% time distribution. This function has to be used before fitting begins to
% avoid costly overhead.
%
%       kdeThr - an accuracy threshold of oKDE. Its default value is 0.02
%   though smaller may be desirable for higher precision. It highly depends
%   on the amount of data per distribution. I recommend using 0.02 when
%   simulated data is relatively small (~100 points) and reduce when
%   higher number of simulations are used. Values that are too small may
%   also be detriment to the performance I generally limit the threshold to
%   0.001 as the lowest value.
%
function out = computeThresholds(realDat, kdeThr)

[nCond, mCond] = size(realDat);
thresholds = nan(nCond,mCond);
for iCond=1:nCond
    for jCond = 1:mCond
        % realDat(iter).rt_res0 = realDat(iter).response == 0;
        kde_rt = quickStart_oKDE(realDat(iCond,jCond).rt_res0, kdeThr, []);%quickStart_oKDE
        if isempty(kde_rt.pdf.smod.H)
            thresholds(iCond,jCond) = 0;
        else
            thresholds(iCond,jCond) = kde_rt.pdf.smod.H;
        end
    end
end
out = realDat;
for iCond=1:nCond
    for jCond = 1:mCond
        out(iCond,jCond).thr_res0 = normpdf(0,0,thresholds(iCond,jCond));
    end
end

for iCond=1:nCond
    for jCond = 1:mCond
        %out(iter).rt_res1 = realDat(iter).response ~= 0;
        % realDat(iter).rt_res1 = realDat(iter).response ~= 0;
        
        kde_rt = quickStart_oKDE(realDat(iCond,jCond).rt_res1, kdeThr, []);%quickStart_oKDE
        if isempty(kde_rt.pdf.smod.H)
            thresholds(iCond,jCond) = 0;
        else
            thresholds(iCond,jCond) = kde_rt.pdf.smod.H;
        end
    end
end

for iCond=1:nCond
    for jCond = 1:mCond
        out(iCond,jCond).thr_res1 = normpdf(0,0,thresholds(iCond,jCond));
    end
end
end