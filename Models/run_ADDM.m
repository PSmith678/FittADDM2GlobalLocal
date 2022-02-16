function simDat = run_ADDM(param,nTrial)
%simDat = run_ADDM(param,nTrial)
% maps parameters to conditions
%
nCond=2;
simDat = repmat(struct( 'res',  (nan(nTrial,1)), 'rt',  nan(nTrial,1)), nCond);

for iCond=1:nCond
    
    % Target Flanker rateS(concurent) rateS(inconcurent) sigma boundary
    
    for iTrial=1:nTrial
        [simDat(iCond).rt(iTrial), simDat(iCond).res(iTrial),~]  = res_ADDM(param,iCond);
% res_addm(timesteps,target, distractor, boundary, none_decision_t, sigma, rateS, stepsize)        
    end
end
%end
