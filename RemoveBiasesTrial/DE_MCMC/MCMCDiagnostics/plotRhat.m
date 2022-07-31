function plotRhat(uids,conditions,plotType) 

% uids: vector of uids 
% conditions: which conditions to plot (1:length of docu.post.res)
% plotType: 'box' or 'line'
docu = load_docufile(uids(1));
parameterNames = docu.model.variableName;



for iUid = 1:length(uids)
   
    rHats(:,:,iUid) = runDiagnostic(uids(iUid));

end

rHats = permute(rHats,[3 2 1]);



for iMulti = 1:length(conditions)
            subplot(1,length(conditions),iMulti)
    switch plotType
        case 'box'
    boxplot(rHats(:,:,iMulti));
    xticklabels(parameterNames);
    ylabel('Split rHat');
    xlabel('Parameter')
    title(sprintf('Condition %d',iMulti));
    

        case 'line'
        for iUid = 1:length(uids)
    plot(rHats(iUid,:,iMulti),'*-','LineWidth',2);
    hold on 
    xticks(1:length(parameterNames))
    xticklabels(parameterNames)
    
    ylabel('Split rHat');%ylabel('split $$\hat{R}$$','Interpreter','LaTeX');
    xlabel('Parameter');
    title(sprintf('Condition %d',iMulti));
    %sgtitle(sprintf('Uid %d',uids));
        end
        legend(string(uids))
    end
    plotbrowser('on')
end
end









   