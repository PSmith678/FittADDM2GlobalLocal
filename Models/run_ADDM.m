function simDat = run_ADDM(param,nTrial)

nCond=2;
simDat = repmat(struct( 'res',  (nan(nTrial,1)), 'rt',  nan(nTrial,1)), nCond);

for iCond=1:nCond
    
    % Target Flanker rateS(concurent) rateS(inconcurent) sigma boundary
    
    for iTrial=1:nTrial
        [simDat(iCond).rt(iTrial), simDat(iCond).res(iTrial),~]  = res_ADDM(param,iCond);
        
    end
end
%end
