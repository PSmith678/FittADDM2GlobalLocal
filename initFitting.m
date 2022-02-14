
function initFitting()

cd DE_MCMC
initDemcmc()
cd ..

home = fileparts(mfilename('fullpath'));
addpath(fullfile(home, 'DocumentationTool'));
initDocuTool();

addpath(fullfile(home, 'OKDE4DEMCMC'));

end