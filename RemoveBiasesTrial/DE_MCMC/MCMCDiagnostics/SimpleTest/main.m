function post = main()

post = nan(2000,10, 2);

for iChain=1:10
    
    rng(iChain);
    h=calcMCMC2([2 5]);
    for i=1:2000
        post(i,iChain,:) = h(i,:);
    end
end

%[generations, nChain, nParam] = size(posterior);
%            post(iSample+1,:) = currentSample;

return
burnin= 100;
interval{1} = [3:0.5:11];
interval{2} = [0:0.5:9];

set_plot_default();

figure
subplot(2,1,1);
h = histogram(post(:,1), interval{1}); hold on
xlabel('scale');
ylabel('frequency');

subplot(2,1,2);
plot(post(:,1));
xlabel('samples');
ylabel('scale');

figure
subplot(2,1,1);
h = histogram(post(:,2), interval{2}); hold on
xlabel('shape');
ylabel('frequency');

subplot(2,1,2);
plot(post(:,2));
xlabel('samples');
ylabel('shape');

