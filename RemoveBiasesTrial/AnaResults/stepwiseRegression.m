function [b,se,pval,finalmodel,stats] = stepwiseRegression(nParticipants)
%
% A function which fits a stepwise regression model. The parameters and
% L2-L1 are the predictors and AQ score is the response, therefore finds
% which variable can predict AQ score.
%
% input: nParticipants = number of participants that have been fitted and
% whos AQ score is included. 
%
% outputs: the outputs from the built-in 'stepwisefit' function. finalmodel
% states which variables are included in the final model and therefore can
% 'predict' AQ score. 

initFitting

% Doing this to remove participants who were removed from the study before
% analysis.
path = './Data/dataGLaverages.xlsx';
subjects = readcell(path, "Sheet", "Sheet4");
subjects = subjects(4:end, 1);
subjects = cell2mat(subjects);

params = {'rate1', 'rate2', 'rate3', 'rate4', 'bias1', 'bias2', 'bias3', 'bias4', 'L1', 'L2', 'Threshold', 'NonDecisionTime', 'IOR'};
nParam = length(params);
mapParticipants = [];
mapParticipantsParams = struct();

for i = 1:nParticipants
    docu(i) = load_docufile(i);

    % Finding the participants who are were kept in for analysis from the
    % data set
    idx = regexp(docu(i).data.selector.label,'[0-9]','match');
    idx = cell2mat(idx);
    idx = str2double(idx);

    % Create a list of the participants who have their 'bp' values and
    % who were analysed in the original study and over these participants,
    % create a stucture where each field is a parameter and contains each
    % participants values.
   if isfield(docu(i).best.res, 'bp') == 1 && ismember(idx, subjects) == 1
        mapParticipants = [mapParticipants, docu(i).uid];
    
    % Array of AQ scores in same order as params
    for iMap = 1:length(mapParticipants)
        AQvector(iMap) = docu(mapParticipants(iMap)).data.selector.AQscore;
        for iParam = 1:nParam
            mapParticipantsParams.(params{iParam})(iMap) = docu(mapParticipants(iMap)).best.res.bp(iParam);
        end
    end
    end 
end 

% Each column is a predictor for our stepwise regression model.
predictors = [];
for iParam = 1:nParam
predictors = [predictors; mapParticipantsParams.(params{iParam})];
end 
predictors = predictors';

predictors(:, 14) = mapParticipantsParams.L2 - mapParticipantsParams.L1;

% Step wise regression model to find which predict AQ score
[b,se,pval,finalmodel,stats] = stepwisefit(predictors, AQvector');

y = stats.intercept+predictors(:,finalmodel)*b(finalmodel);


plot(predictors(:, finalmodel), y)
xlabel('Difference in Saliency Parameters (L2 - L1)')
ylabel("AQ score Prediction")
title("A Plot Showing the Stepwise Regression Fit (to AQ Score) of the Variable that was Included in the Final Model")
%hold on 
%scatter(predictors(:, finalmodel), AQvector)
end