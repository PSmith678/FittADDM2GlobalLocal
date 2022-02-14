function [rt,res,xS,xI] = res_ADDM(param,iCond)
T = param(1);

if iCond == 2
    F = -param(2);
   rateS = param(4);
else
    F = param(2);
   rateS = param(3);
end

sigma = param(5);
boundary = param(6);

xS(1) = 0;
xI(1) = 0;

for t = 1:10000
    
    xS(t+1) = xS(t) + rateS + sigma*randn;
    
    % If xS = 0, attention focuses on both target and flanker.
    % If xS=1 attention focus on target only
    target(t) =  T * 0.5 * (xS(t)+1);
    
    % If attention focused on target, flanker does not influence drift rate.
    % xS=1 flanker does not influence identification.
    flanker(t) = F * (1-0.5*(xS(t)+1));
    
    rateI(t) = target(t) + flanker(t);
    xI(t+1) = xI(t) + rateI(t) + sigma*randn;
    
    if xS(t+1) >= boundary || xS(t+1) <= -boundary
        break
    end
    
    
end
rt = t;

if xI(t+1) >= 0
    res = 1;
else
    res = 0;
end

%      subplot(2,1,1);
%  plot(xS);
%  title('xS');
%  subplot(2,1,2);
%  plot(xI);
%  title('xI');
%  yline(boundary);
%  hold on
% yline(-boundary)
%  drawnow
%   WaitSecs(5);
%  clf
end
%
% %if showPlot == 1
% subplot(2,1,1);
% plot(xS);
% title('xS');
% subplot(2,1,2);
% plot(xI);
% title('xI');
% %end

