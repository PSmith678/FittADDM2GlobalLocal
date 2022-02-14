function res = logbinoApprox(n,k)

%res = (n*log(n)-n)-((n-k) * log(n-k)-(n-k))-(k *log(k)-k);
res = (n*log(n)-n) + 0.5 * log(n) + 0.5 * log(2*pi);

end