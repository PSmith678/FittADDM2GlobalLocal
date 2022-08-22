function [pAnovaRate, pAnovaBias] = averageParams(nParticipants)
% Plot how the 4 rates, biases and 2 saliency params vary. Find the average 
% of each over the participants and plot these averages.

initFitting

% Doing this to remove participants who were removed from the study before
% analysis.
path = './Data/dataGLaverages.xlsx';
subjects = readcell(path, "Sheet", "Sheet4");
subjects = subjects(4:end, 1);
subjects = cell2mat(subjects);
mapParticipants = [];

for i = 1:nParticipants
    docu(i) = load_docufile(i);
   
    % Finding the participants who are were kept in for analysis from the 
    % data set.
    idx = regexp(docu(i).data.selector.label,'[0-9]','match');
    idx = cell2mat(idx);
    idx = str2double(idx);

    % Create a list of the participants who have their 'bp' values and
    % who were analysed in the original study.
    if isfield(docu(i).best.res, 'bp') == 1 && ismember(idx, subjects) == 1
        mapParticipants = [mapParticipants, docu(i).uid];
    end 
end 


rates1 = nan(1 , length(mapParticipants));
rates2 = nan(1 , length(mapParticipants));
rates3 = nan(1 , length(mapParticipants));
rates4 = nan(1 , length(mapParticipants));
biases1 = nan(1, length(mapParticipants));
biases2 = nan(1, length(mapParticipants));
biases3 = nan(1, length(mapParticipants));
biases4 = nan(1, length(mapParticipants));
saliency1 = nan(1, length(mapParticipants));
saliency2 = nan(1, length(mapParticipants));


% Array for each rate,bias and saliency params over the participants.
for iParticipant = 1 : length(mapParticipants)
    
    rates1(iParticipant) = docu(mapParticipants(iParticipant)).best.res.bp(1);
    rates2(iParticipant) = docu(mapParticipants(iParticipant)).best.res.bp(2);
    rates3(iParticipant) = docu(mapParticipants(iParticipant)).best.res.bp(3);
    rates4(iParticipant) = docu(mapParticipants(iParticipant)).best.res.bp(4);

    biases1(iParticipant) = docu(mapParticipants(iParticipant)).best.res.bp(5);
    biases2(iParticipant) = docu(mapParticipants(iParticipant)).best.res.bp(6);
    biases3(iParticipant) = docu(mapParticipants(iParticipant)).best.res.bp(7);
    biases4(iParticipant) = docu(mapParticipants(iParticipant)).best.res.bp(8);

    saliency1(iParticipant) = docu(mapParticipants(iParticipant)).best.res.bp(9);
    saliency2(iParticipant) = docu(mapParticipants(iParticipant)).best.res.bp(10);

end

% Average of each rate and bias and saliency param.
rate1Avg = mean(rates1);
rate2Avg = mean(rates2);
rate3Avg = mean(rates3);
rate4Avg = mean(rates4);

bias1Avg = mean(biases1);
bias2Avg = mean(biases2);
bias3Avg = mean(biases3);
bias4Avg = mean(biases4);

saliency1Avg = mean(saliency1);
saliency2Avg = mean(saliency2);



figure()
subplot(1, 3, 1)
plot(categorical({'Global Task', 'Local Task'}), [rate2Avg, rate3Avg], "Marker", "x", color='b')
hold on 
plot(categorical({'Global Task', 'Local Task'}), [rate1Avg, rate4Avg], "Marker","x", color='r')
xlabel('Task (Glocal/Local)', FontSize=15)
ylabel('Rate Values', FontSize=15)
legend('Target Salient', 'Distractor Salient')
title('The Averages of the Four Rates Across the Participants', FontSize=11.5)


subplot(1, 3, 2)
plot(categorical({'Global Task', 'Local Task'}), [bias2Avg, bias3Avg], "Marker","x", color='b')
hold on
plot(categorical({'Global Task', 'Local Task'}), [bias1Avg, bias4Avg], "Marker","x", color='r')
xlabel('Task (Global/Local)', 'FontSize',15)
ylabel('Bias Values', 'FontSize',15)
legend('Target Salient', 'Distractor Salient')
title('The Averages of the Four Biases Across the Participants', FontSize=11.5)

subplot(1, 3, 3)
plot(categorical({'L1', 'L2'}), [saliency1Avg, saliency2Avg], "Marker","x", color='g')
xlabel('Saliency Parameters (L1 & L2)', 'FontSize',15)
ylabel('Saliency Parameter Values', FontSize=15)
title('The Averages of the L1 and L2 Across the Participants', FontSize=11.5)


% column = task
% row = level saliency

anovaMatrixBias = [biases2', biases3'; biases1', biases4'];
pAnovaBias = anova2(anovaMatrixBias, length(biases1));

anovaMatrixRate = [rates2', rates3'; rates1', rates4'];
pAnovaRate = anova2(anovaMatrixRate, length(rates1));



end 