function [retData, para] = link_ModelData(model, selector)

[retData] = readdata(selector);

%if length(retData) ~= size(model.variable2condition,1)
%    error('Data does not match to model specification');
%end
nCond = length(retData);

 para = 0;
% for iCond=1:nCond
%     para = max([para; retData(iCond).rt_res1]) ;
%     para = max([para; retData(iCond).rt_res0]) ;
% 
% end


retData = computeThresholds(retData, model.loglikeFunc.para.kdeThr);



end