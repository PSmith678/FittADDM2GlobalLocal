function averageParams(nParticipant)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

rates1 = nan(1 , nParticipant);
rates2 = nan(1 , nParticipant);
rates3 = nan(1 , nParticipant);
rates4 = nan(1 , nParticipant);
biases1 = nan(1, nParticipant);
biases2 = nan(1, nParticipant);
biases3 = nan(1, nParticipant);
biases4 = nan(1, nParticipant);

for iParticipant = 1 : nParticipant
    docu = load_docufile(iParticipant);
    rates1(iParticipant) = docu.post.res.map(1);
    rates2(iParticipant) = docu.post.res.map(2);
    rates3(iParticipant) = docu.post.res.map(3);
    rates4(iParticipant) = docu.post.res.map(4);

    biases1(iParticipant) = docu.post.res.map(5);
    biases2(iParticipant) = docu.post.res.map(6);
    biases3(iParticipant) = docu.post.res.map(7);
    biases4(iParticipant) = docu.post.res.map(8);
end

rate1Avg = mean(rates1);
rate2Avg = mean(rates2);
rate3Avg = mean(rates3);
rate4Avg = mean(rates4);

bias1Avg = mean(biases1);
bias2Avg = mean(biases2);
bias3Avg = mean(biases3);
bias4Avg = mean(biases4);

subplot(1, 2, 1)
plot([rate1, rate2, rate3, rate4], [rate1Avg, rate2Avg, rate3Avg, rate4Avg], "Marker","x", Color='r')
xlabel('Rates')
ylabel('Rate Values')
title('The averages of the four assumed rates across the participants')

subplot(1, 2, 2)
plot([Bias1, Bias2, Bias3, Bias4], [bias1Avg, bias2Avg, bias3Avg, bias4Avg], "Marker","x", color='b')
xlabel('Bias')
ylabel('Bias Values')
title('The averages of the four assumed biases across the participants')

end 