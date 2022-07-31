
function out = normTruncRnd(mu,sigma,leftTrunc,rightTrunc,n)


out = zeros(n,length(mu));
for i = 1:length(mu)
distObj = makedist('Normal',mu(i),sigma(i));

distObj = truncate(distObj,leftTrunc(i),rightTrunc(i));

out(:,i) = random(distObj,n,1);
end


end