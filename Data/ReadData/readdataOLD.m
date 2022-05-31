function realDat = readdataOLD(participantNumber, coherenceCondition)

%cd '.\Data\Data'

% Column Identifiers

coherence = [.2 .3 .6 .9];

realDat(2,length(coherence)) = struct('rt_res1',[],'rt_res0',[],'response',[]);

participantFile = dir(sprintf('.%sData%sData%s%s.csv',filesep,filesep,filesep,participantNumber));
data = readtable(sprintf('.%sData%sData%s%s',filesep,filesep,filesep,participantFile.name)); 
disp(participantFile.name);


    
    for iCoh = 1:length(coherence)
        
        % Congruent
        idxCorr = data.Coherence == coherence(iCoh) & data.ACC == 1 & data.Congruency == 1;
        idxIncorr = data.Coherence == coherence(iCoh) & data.ACC == 0 & data.Congruency == 1;
        realDat(1,iCoh).rt_res1 = rmoutliers(data.RT(idxCorr));
        realDat(1,iCoh).rt_res0 = rmoutliers(data.RT(idxIncorr));
        realDat(1,iCoh).response = [ones(length(realDat(1,iCoh).rt_res1),1); zeros(length(realDat(1,iCoh).rt_res0),1)];
        
         % Incongruent
        idxCorr = data.Coherence == coherence(iCoh) & data.ACC == 1 & data.Congruency == 0;
        idxIncorr = data.Coherence == coherence(iCoh) & data.ACC == 0 & data.Congruency == 0;
         realDat(2,iCoh).rt_res1 = rmoutliers(data.RT(idxCorr));
         realDat(2,iCoh).rt_res0 = rmoutliers(data.RT(idxIncorr));     
        realDat(2,iCoh).response = [ones(length(realDat(2,iCoh).rt_res1),1); zeros(length(realDat(2,iCoh).rt_res0),1)];
        
        
       
    end
    realDat = realDat(:,coherenceCondition);
end
