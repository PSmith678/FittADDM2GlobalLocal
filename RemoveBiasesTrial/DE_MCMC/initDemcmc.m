
function initDemcmc()

% paths to ModelFitting_Skeleton
home = fileparts(mfilename('fullpath'));
addpath(home);
addpath(fullfile(home, 'MCMCDiagnostics'));
addpath(fullfile(home, 'DocuInterface'));



global DEMCMCpara
DEMCMCpara = []; 