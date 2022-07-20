function [corrSample, sigPercentParams] = randomSampleAnalysis(nParticipants, nCorrs)
% Random sample from each posterior (across particiapnts) conduct ttests
% and correlations on these, find confidence interval.

%% Set up Participants who can be analysed
nSamples = 1;
path = './Data/dataGLaverages.xlsx';
subjects = readcell(path, "Sheet", "Sheet4");
subjects = subjects(4:end, 1);
subjects = cell2mat(subjects);

params = {'rate1', 'rate2', 'rate3', 'rate4', 'bias1', 'bias2', 'bias3', ...
    'bias4', 'L1', 'L2', 'Threshold', 'NonDecisionTime', 'IOR', 'differenceBetweenSaliencyParameters'};
nParam = length(params);
mapParticipants = [];
mapParticipantsHighAQ = [];
mapParticipantsLowAQ = [];
sampledParamsHigh = struct();
sampledParamsLow = struct();
samplesParams = struct();

for i = 1:nParticipants
    docu(i) = load_docufile(i);

    % Finding the participants who are were kept in for analysis from the
    % data set
    idx = regexp(docu(i).data.selector.label,'[0-9]','match');
    idx = cell2mat(idx);
    idx = str2double(idx);

    % Create a list of the participants who have their 'bp' values and
    % who were analysed in the original study and over these participants.
    if isfield(docu(i).best.res, 'bp') == 1 && ismember(idx, subjects) == 1
        mapParticipants = [mapParticipants, docu(i).uid];
    end
    
    for iParticipant = 1:length(mapParticipants)
        AQvector((iParticipant - 1) * nSamples + 1 : iParticipant * nSamples) = docu(mapParticipants(iParticipant)).data.selector.AQscore;
    end 
    
    if isfield(docu(i).best.res, 'bp') == 1 && docu(i).data.selector.AQgroup == "High" && ismember(idx, subjects) == 1
        mapParticipantsHighAQ = [mapParticipantsHighAQ, docu(i).uid];

    elseif isfield(docu(i).best.res, 'bp') == 1 && docu(i).data.selector.AQgroup == "Low" && ismember(idx, subjects) == 1
        mapParticipantsLowAQ = [mapParticipantsLowAQ, docu(i).uid];

    end
end

%% Get randomly sampled param values

% All participants for correlations

for iCorr = 1:nCorrs
    for iParam = 1:nParam - 1
        for iParticipant = 1:length(mapParticipants)
            posterior = docu(mapParticipants(iParticipant)).post.res.posterior(501:end,:,iParam);
            pSize = numel(posterior);
            sampledValues = posterior(randperm(pSize, 1));
            sampledParams{iCorr}.(params{iParam})((iParticipant - 1) * 1 + 1 : iParticipant * 1) = sampledValues;
        end
    end

    for iParticipant = 1:length(mapParticipants)
        posterior = docu(mapParticipants(iParticipant)).post.res.posterior(501:end,:,10) - docu(mapParticipants(iParticipant)).post.res.posterior(501:end,:,9);
        pSize = numel(posterior);
        sampledValues = posterior(randperm(pSize, nSamples));
        sampledParams{iCorr}.differenceBetweenSaliencyParameters((iParticipant - 1) * nSamples + 1 : iParticipant * nSamples) = sampledValues;
    end
end
% High and Low AQ groups separately for comparision
%for iParam = 1:nParam - 1
    %for iParticipant = 1:length(mapParticipantsHighAQ)
        %posterior = docu(mapParticipantsHighAQ(iParticipant)).post.res.posterior(501:end,:,iParam);
        %pSize = numel(posterior);
        %sampledValuesHigh = posterior(randperm(pSize, nSamples));
        %sampledParamsHigh.(params{iParam})((iParticipant - 1) * nSamples + 1 : iParticipant * nSamples) = sampledValuesHigh;
    %end
%end

%for iParam = 1:nParam - 1
    %for iParticipant = 1:length(mapParticipantsLowAQ)
        %posterior = docu(mapParticipantsLowAQ(iParticipant)).post.res.posterior(501:end,:,iParam);
        %pSize = numel(posterior);
        %sampledValuesLow = posterior(randperm(pSize, nSamples));
        %sampledParamsLow.(params{iParam})((iParticipant - 1) * nSamples + 1 : iParticipant * nSamples) = sampledValuesLow;
    %end
%end

%for iParticipant = 1:length(mapParticipantsHighAQ)
        %posterior = docu(mapParticipantsHighAQ(iParticipant)).post.res.posterior(501:end,:,10) - docu(mapParticipantsHighAQ(iParticipant)).post.res.posterior(501:end,:,9);
        %pSize = numel(posterior);
        %sampledValuesHigh = posterior(randperm(pSize, nSamples));
        %sampledParamsHigh.differenceBetweenSaliencyParameters((iParticipant - 1) * nSamples + 1 : iParticipant * nSamples) = sampledValuesHigh;       
%end

%for iParticipant = 1:length(mapParticipantsLowAQ)
        %posterior = docu(mapParticipantsLowAQ(iParticipant)).post.res.posterior(501:end,:,10) - docu(mapParticipantsLowAQ(iParticipant)).post.res.posterior(501:end,:,9);
        %pSize = numel(posterior);
        %sampledValuesLow = posterior(randperm(pSize, nSamples));
        %sampledParamsLow.differenceBetweenSaliencyParameters((iParticipant - 1) * nSamples + 1 : iParticipant * nSamples) = sampledValuesLow;       
%end
%% Analysis
%for iTest = 1:nParam
    %[h, p, ci, stats] = ttest2(sampledParamsLow.(params{iTest}), sampledParamsHigh.(params{iTest}), Alpha=0.01, Vartype="unequal");
    %ttestsSample.(params{iTest}).Decision = h;
    %ttestsSample.(params{iTest}).pValue = p;
    %ttestsSample.(params{iTest}).confidenceInterval = ci;
    %ttestsSample.(params{iTest}).testStats = stats;
%end

sigPercentParams = zeros(nParam, 1);

for iCorr = 1:nCorrs
    corrSample{iCorr} = nan(nParam, 2);

    for iParam = 1:nParam
        [corr, p] = corrcoef(AQvector,...
            sampledParams{iCorr}.(params{iParam}));
        corrSample{iCorr}(iParam, 1) = round(p(1,2), 5);
        corrSample{iCorr}(iParam, 2) = round(corr(1,2), 5);
        if p(1,2) < 0.05
           sigPercentParams(iParam) = sigPercentParams(iParam) + 1;
        end 
    end

end

sigPercentParams = (sigPercentParams/nCorrs) * 100;



%figure()
%counter = 1;
%for iPlot = 1 : nParam
    %subplot(3, 5, iPlot);
    %for iParticipant = 1:length(AQvector)
        %scatter(AQvector(iParticipant),...
           % sampledParams.(params{counter})(iParticipant), MarkerEdgeColor=[0.9290 0.6940 0.1250], LineWidth=0.25)
        %hold on
    %end
   % xlim([min(AQvector) max(AQvector)]);
   % ylim([min(sampledParams.(params{counter})) max(sampledParams.(params{counter}))]);
   % string = {sprintf('corr = %g\np = %g', corrSample(iPlot, 2), corrSample(iPlot, 1))};
    %text(max(xlim), max(ylim), string, FontWeight="bold", FontSize=9, VerticalAlignment="top", HorizontalAlignment="right");
   % xlabel('AQ Score')
   % ylabel(sprintf('%s Values', params{counter}))
   % title(sprintf('%s', params{counter}))
   % counter = counter + 1;
%end 

end