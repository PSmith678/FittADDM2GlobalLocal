function chooseNCores (fun, nCores, prior, popSize)

nGenerations = 4;
try
    parpool(nCores);
catch
    poolobj = gcp('nocreate');
    if poolobj.NumWorkers ~= nCores
        delete(poolobj);
        parpool(nCores);
    end
end
tic;
de_mcmc(@(evalPars) feval(fun,evalPars),prior,'boundedUniform','groupSize',popSize,'nGenerations',nGenerations);
toc

end