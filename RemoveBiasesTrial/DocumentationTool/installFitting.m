
function installFitting()


mkdir('Models');
path = fullfile(pwd, 'Models');
mkdir(path, 'Priors');

mkdir('Data');
path = fullfile(pwd, 'Data');
mkdir(path, 'ReadData');

mkdir('SetParaFunc');
mkdir('AnaResults');
mkdir('AnaModels');
mkdir('LocalUtil');
mkdir('GraphicsFunc');

mkdir('Docus');
path = fullfile(pwd, 'Docus');
mkdir(path, 'Figures');

%mkdir('DEMCMC_Outputs');
