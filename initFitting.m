
function initFitting()

cd DE_MCMC
initDemcmc()
cd ..

home = fileparts(mfilename('fullpath'));
addpath(fullfile(home, 'DocumentationTool'));
initDocuTool();
h1 = genpath('OKDE4DEMCMC');
addpath(h1);

end