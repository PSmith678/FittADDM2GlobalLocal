function pValCorr = correlations(nParticipants)
% Find correlations between each parameter and AQ score.
% The output contains whether each parameter (and L1 - L1) has a
% relationship with AQ score, if this value is less than 0.05 this suggests
% a relationship.

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

    for iMap = 1:length(mapParticipants)
        AQvector(iMap) = docu(mapParticipants(iMap)).data.selector.AQscore;
        for iParam = 1:nParam
            mapParticipantsParams.(params{iParam})(iMap) = docu(mapParticipants(iMap)).best.res.bp(iParam);
        end
    end
    end 
end 

% Find the correlation between each param and AQ score and whether these
% are significant (suggest a relationship).
pValCorr = nan(nParam + 1, 2);

for iParam = 1:nParam
    [corr, p] = corrcoef(AQvector,...
        mapParticipantsParams.(params{iParam}));
    pValCorr(iParam, 1) = round(p(1,2), 5);
    pValCorr(iParam, 2) = round(corr(1,2), 5);
end 

% L2 - L1 correlation.
[corr, p] = corrcoef(AQvector,...
        mapParticipantsParams.L2 - mapParticipantsParams.L1);
pValCorr(end, 1) = round(p(1,2), 5);
pValCorr(end, 2) = round(corr(1,2), 5);


% Plot these param values against AQ score.
figure()
counter = 1;
for iPlot = 1 : nParam
    subplot(3, 5, iPlot);
    for iParticipant = 1:length(mapParticipants)
        scatter(AQvector(iParticipant),...
            mapParticipantsParams.(params{counter})(iParticipant), MarkerEdgeColor=[0.9290 0.6940 0.1250], LineWidth=0.25)
        hold on
    end
    xlim([min(AQvector) max(AQvector)]);
    ylim([min(mapParticipantsParams.(params{counter})) max(mapParticipantsParams.(params{counter}))]);
    string = {sprintf('corr = %g\np = %g', pValCorr(iPlot, 2), pValCorr(iPlot, 1))};
    text(max(xlim), max(ylim), string, FontWeight="bold", FontSize=9, VerticalAlignment="top", HorizontalAlignment="right");
    xlabel('AQ Score')
    ylabel(sprintf('%s Values', params{counter}))
    title(sprintf('%s', params{counter}))
    counter = counter + 1;
end 

% Plot L2-L1 against AQ score
subplot(3, 5, nParam + 1)
for iParticipant = 1:length(mapParticipants)
    scatter(AQvector(iParticipant),...
        mapParticipantsParams.L2(iParticipant) - mapParticipantsParams.L1(iParticipant), MarkerEdgeColor=[0.9290 0.6940 0.1250], LineWidth=0.25)
    hold on
end
xlim([min(AQvector) max(AQvector)]);
ylim([min(mapParticipantsParams.L2 - mapParticipantsParams.L1) max(mapParticipantsParams.L2 - mapParticipantsParams.L1)]);
string = {sprintf('corr = %g\np = %g', pValCorr(end, 2), pValCorr(end, 1))};
text(max(xlim), max(ylim), string, FontWeight="bold", FontSize=9, VerticalAlignment="top", HorizontalAlignment="right");
xlabel('AQ Score')
xlabel('AQ Score')
ylabel("L2 - L1 Values")
title("L2 - L1")

sgtitle('Plots Showing the Parameter Values Against AQ Score')


end