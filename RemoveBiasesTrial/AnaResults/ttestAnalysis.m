function ttests = ttestAnalysis(nParticipants)
% t-tests on each parameter to compare the 'low' and 'high' AQ groups.
% The output ttests is a structure where each field is an item that ttests
% were conducted on, in these fields are the results from these ttests.
% Also plots the averages of the significant params across the two groups
% to compare.

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
mapParticipantsHighAQ = [];
mapParticipantsLowAQ = [];
mapParticipantsHighAQParams = struct();
mapParticipantsLowAQParams = struct();

for i = 1:nParticipants
    docu(i) = load_docufile(i);

    % Finding the participants who are were kept in for analysis from the
    % data set.
    idx = regexp(docu(i).data.selector.label,'[0-9]','match');
    idx = cell2mat(idx);
    idx = str2double(idx);

    % Create a list of the participants who have their 'bp' values and
    % who were analysed in the original study. Then seperate these
    % participants into High and Low AQ scores.
    if isfield(docu(i).best.res, 'bp') == 1 && ismember(idx, subjects) == 1
        mapParticipants = [mapParticipants, docu(i).uid];
    end
   
    if isfield(docu(i).best.res, 'bp') == 1 && docu(i).data.selector.AQgroup == "High" && ismember(idx, subjects) == 1 
        mapParticipantsHighAQ = [mapParticipantsHighAQ, docu(i).uid];

        % Create a structure where each field is a parameter and list these
        % values for the 'High' participants. 
        for iMap = 1:length(mapParticipantsHighAQ)
            for iParam = 1:nParam
                mapParticipantsHighAQParams.(params{iParam})(iMap) = docu(mapParticipantsHighAQ(iMap)).best.res.bp(iParam);
            end
        end
   
    elseif isfield(docu(i).best.res, 'bp') == 1 && docu(i).data.selector.AQgroup == "Low" && ismember(idx, subjects) == 1
        mapParticipantsLowAQ = [mapParticipantsLowAQ, docu(i).uid];

        % Same structure for 'Low' participants
        for iMap = 1:length(mapParticipantsLowAQ)
            for iParam = 1:nParam
                mapParticipantsLowAQParams.(params{iParam})(iMap) = docu(mapParticipantsLowAQ(iMap)).best.res.bp(iParam);
            end
        end
    end
end

% ttests over each parameter
for iTest = 1:nParam
    [h, p, ci, stats] = ttest2(mapParticipantsLowAQParams.(params{iTest}), mapParticipantsHighAQParams.(params{iTest}));
    ttests.(params{iTest}).Decision = h;
    ttests.(params{iTest}).pValue = p;
    ttests.(params{iTest}).confidenceInterval = ci;
    ttests.(params{iTest}).testStats = stats;
end

% ttests over L2-L1 (saliency params difference)
[hDiff, pDiff, ciDiff, statsDiff]= ttest2(mapParticipantsLowAQParams.L2 - mapParticipantsLowAQParams.L1, mapParticipantsHighAQParams.L2 - mapParticipantsHighAQParams.L1);
ttests.differenceBetweenSaliencyParameters.Decision = hDiff;
ttests.differenceBetweenSaliencyParameters.pValue = pDiff;
ttests.differenceBetweenSaliencyParameters.confidenceInterval = ciDiff;
ttests.differenceBetweenSaliencyParameters.testStats = statsDiff;

sig = [];
counter = 0;
for iParam = 1:nParam
    if ttests.(params{iParam}).Decision == 1
        counter = counter + 1;
        sig = [sig, string(params{iParam})];
    end
end

if ttests.differenceBetweenSaliencyParameters.Decision == 1
   sig = [sig, "differenceBetweenSaliencyParameters"];
end 

figure()
for iPlot = 1:length(sig)
    if sig(iPlot) == "differenceBetweenSaliencyParameters"
        subplot(1, length(sig), iPlot)
       diff = bar(categorical({'High AQ', 'Low AQ'}), ...
            [mean(mapParticipantsHighAQParams.L2 - mapParticipantsHighAQParams.L1), mean(mapParticipantsLowAQParams.L2 - mapParticipantsLowAQParams.L1)], FaceColor="flat" );
       set(gca, Fontsize = 14)
       diff.CData(1, :) = [0.8500 0.3250 0.0980];
       diff.CData(2, :) = [0 0.4470 0.7410];
        title("L2 - L1")
        xlabel('AQ Group')
        ylabel('Average Parameter Value')


    else
        subplot(1, length(sig), iPlot)
        b = bar(categorical({'High AQ', 'Low AQ'}), [mean(mapParticipantsHighAQParams.(sig(iPlot))), mean(mapParticipantsLowAQParams.(sig(iPlot)))], FaceColor="flat");
        title(string(sig(iPlot)))
        set(gca, Fontsize = 14)
        b.CData(1, :) = [0.8500 0.3250 0.0980];
        b.CData(2, :) = [0 0.4470 0.7410];
        xlabel('AQ Group')
        ylabel('Average Parameter Value')

    end
end
sgtitle("Bar Charts Comparing the Average Parameter Values Across the High and Low AQ Groups for the Statistically Significant Parameters")

end