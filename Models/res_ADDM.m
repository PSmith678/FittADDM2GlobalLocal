function [rt,acc, eviI, eviS] = res_addm(timesteps,target, distractor, boundary, none_decision_t, sigma, rateS, stepsize)
%
%   [rt,acc, evidence] = res_addm(timesteps,boundary, none_decision_t, sigma, rate, stepsize)
%

flagSel = 0;

if nargout > 2

    eviI = nan(timesteps,1);
    eviS = nan(timesteps,1);
    eviS(1) = 0;
    eviI(1) = 0;
    for i=2:timesteps
        if flagSel == 0
            eviS(i) = eviS(i-1)+  (stepsize * rateS + sqrt(stepsize) * sigma * randn);
            if abs(eviS(i)) > 1
                flagSel = 1;
                eviS(i) = sign(eviS(i));
            end
        end
        rate =  target * 0.5 * (eviS(i)+1) +  distractor * (1-0.5 * (eviS(i)+1));

        eviI(i) = eviI(i-1) + stepsize * rate + sqrt(stepsize) * sigma * randn;

        if eviI(i) < -boundary || eviI(i) > boundary
            break
        end
    end


    %    rt1 = min([find(isnan(evidence),1) timesteps]);
    rt = i*stepsize + none_decision_t;

    if eviI(i) >= boundary
        acc = 1;
    else
        acc = 0;
    end
else
    eviI = 0;
    eviS = 0;
    i = 0;
    while eviI > -boundary && eviI < boundary && i < timesteps

        if flagSel == 0
            eviS = eviS +  (stepsize*rateS + sqrt(stepsize)*sigma*randn);
            if abs(eviS) > 1
                flagSel = 1;
                eviS = sign(eviS);

            end
        end

        rate =  target * 0.5 * (eviS+1) +  distractor * (1-0.5 * (eviS+1));


        eviI = eviI + stepsize * rate + sqrt(stepsize) * sigma * randn;
        i = i + 1;
    end



    rt = i*stepsize + none_decision_t;

    if eviI > boundary
        acc = 1;
    else
        acc = 0;
    end
end


end

