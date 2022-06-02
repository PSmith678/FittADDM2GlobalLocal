function realDat = readdata(participantNumber)

%cd '.\Data\Data'

% Column Identifiers

%coherence = [.2 .3 .6 .9];


nCond = 8;
realDat(nCond, 1) = struct('rt_res1',[],'rt_res0',[],'response',[]);

participantFile = dir(sprintf('.%sData%sGL_Raw Data%s%sGlobalsaliency_occ.txt',filesep,filesep,filesep,participantNumber.label));
data = readtable(sprintf('.%sData%sGL_Raw Data%s%s',filesep,filesep,filesep,participantFile.name)); 
vars = [2, 4, 6, 9, 10];
data = data(:,vars); % Level, saliency, congruency, RT, accuracy
% 1 = incongruent and 0 = congruent
% 1 = local salient and 0 = global salient
% 1 = correct and 0 = incorrect
disp(participantFile.name);


% change global to 0 and local to 1.
dataLevel = table2array(data(:,1));
dataLevelArray = nan(length(dataLevel),1);
for i = 1: length(dataLevel)
if length(dataLevel{i}) == 6
    dataLevelArray(i) = 0;
else 
    dataLevelArray(i) = 1;
end
end 

data = [dataLevelArray, table2array(data(:, 2:end))];
       
       % Cond 1
       idxCorr = data(:,1) == 0 & data(:,2) == 1 & data(:,3) == 0 ...
          & data(:,5) == 1;
       idxIncorr = data(:,1) == 0 & data(:,2) == 1 & data(:,3) == 0 ...
          & data(:,5) == 0;
        realDat(1).rt_res1 = rmoutliers(data(idxCorr, 4), "mean", "ThresholdFactor", 2);
        realDat(1).rt_res0 = rmoutliers(data(idxIncorr, 4), "mean", "ThresholdFactor", 2);
        realDat(1).response = [ones(length(realDat(1).rt_res1),1); zeros(length(realDat(1).rt_res0),1)];
        
         % Cond 2
        idxCorr = data(:,1) == 0 & data(:,2) == 0 & data(:,3) == 0 ...
          & data(:,5) == 1;
       idxIncorr = data(:,1) == 0 & data(:,2) == 0 & data(:,3) == 0 ...
          & data(:,5) == 0;
        realDat(2).rt_res1 = rmoutliers(data(idxCorr, 4), "mean", "ThresholdFactor", 2);
        realDat(2).rt_res0 = rmoutliers(data(idxIncorr, 4), "mean", "ThresholdFactor", 2);
        realDat(2).response = [ones(length(realDat(2).rt_res1),1); zeros(length(realDat(2).rt_res0),1)];

        % Cond 3
        idxCorr = data(:,1) == 0 & data(:,2) == 1 & data(:,3) == 1 ...
          & data(:,5) == 1;
       idxIncorr = data(:,1) == 0 & data(:,2) == 1 & data(:,3) == 1 ...
          & data(:,5) == 0;
        realDat(3).rt_res1 = rmoutliers(data(idxCorr, 4), "mean", "ThresholdFactor", 2);
        realDat(3).rt_res0 = rmoutliers(data(idxIncorr, 4), "mean", "ThresholdFactor", 2);
        realDat(3).response = [ones(length(realDat(3).rt_res1),1); zeros(length(realDat(3).rt_res0),1)];
    
        % Cond 4
        idxCorr = data(:,1) == 0 & data(:,2) == 0 & data(:,3) == 1 ...
          & data(:,5) == 1;
       idxIncorr = data(:,1) == 0 & data(:,2) == 0 & data(:,3) == 1 ...
          & data(:,5) == 0;
        realDat(4).rt_res1 = rmoutliers(data(idxCorr, 4), "mean", "ThresholdFactor", 2);
        realDat(4).rt_res0 = rmoutliers(data(idxIncorr, 4), "mean", "ThresholdFactor", 2);
        realDat(4).response = [ones(length(realDat(4).rt_res1),1); zeros(length(realDat(4).rt_res0),1)];
        

        % Cond 5
        idxCorr = data(:,1) == 1 & data(:,2) == 1 & data(:,3) == 0 ...
          & data(:,5) == 1;
       idxIncorr = data(:,1) == 1 & data(:,2) == 1 & data(:,3) == 0 ...
          & data(:,5) == 0;
        realDat(5).rt_res1 = rmoutliers(data(idxCorr, 4), "mean", "ThresholdFactor", 2);
        realDat(5).rt_res0 = rmoutliers(data(idxIncorr, 4), "mean", "ThresholdFactor", 2);
        realDat(5).response = [ones(length(realDat(5).rt_res1),1); zeros(length(realDat(5).rt_res0),1)];
        
        % Cond 6
        idxCorr = data(:,1) == 1 & data(:,2) == 0 & data(:,3) == 0 ...
          & data(:,5) == 1;
       idxIncorr = data(:,1) == 1 & data(:,2) == 0 & data(:,3) == 0 ...
          & data(:,5) == 0;
        realDat(6).rt_res1 = rmoutliers(data(idxCorr, 4), "mean", "ThresholdFactor", 2);
        realDat(6).rt_res0 = rmoutliers(data(idxIncorr, 4), "mean", "ThresholdFactor", 2);
        realDat(6).response = [ones(length(realDat(6).rt_res1),1); zeros(length(realDat(6).rt_res0),1)];
    
        % Cond 7
        idxCorr = data(:,1) == 1 & data(:,2) == 1 & data(:,3) == 1 ...
          & data(:,5) == 1;
       idxIncorr = data(:,1) == 1 & data(:,2) == 1 & data(:,3) == 1 ...
          & data(:,5) == 0;
        realDat(7).rt_res1 = rmoutliers(data(idxCorr, 4), "mean", "ThresholdFactor", 2);
        realDat(7).rt_res0 = rmoutliers(data(idxIncorr, 4), "mean", "ThresholdFactor", 2);
        realDat(7).response = [ones(length(realDat(7).rt_res1),1); zeros(length(realDat(7).rt_res0),1)];
        
        % Cond 8
        idxCorr = data(:,1) == 1 & data(:,2) == 0 & data(:,3) == 1 ...
          & data(:,5) == 1;
       idxIncorr = data(:,1) == 1 & data(:,2) == 0 & data(:,3) == 1 ...
          & data(:,5) == 0;
        realDat(8).rt_res1 = rmoutliers(data(idxCorr, 4), "mean", "ThresholdFactor", 2);
        realDat(8).rt_res0 = rmoutliers(data(idxIncorr, 4), "mean", "ThresholdFactor", 2);
        realDat(8).response = [ones(length(realDat(8).rt_res1),1); zeros(length(realDat(8).rt_res0),1)];
       

end
