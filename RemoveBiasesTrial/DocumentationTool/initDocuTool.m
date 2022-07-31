
function initDocuTool()

% paths to ModelFitting_Skeleton
home = fileparts(mfilename('fullpath'));
addpath(fullfile(home, 'UtilFunc'));


% paths local 
addpath(fullfile(pwd, 'Models'));
%addpath(fullfile(pwd, 'Models/Priors'));
addpath(fullfile(pwd, 'Data/ReadData'));
addpath(fullfile(pwd, 'SetParaFunc'));
addpath(fullfile(pwd, 'AnaResults'));

addpath(fullfile(pwd, 'LocalUtil'));
addpath(fullfile(pwd, 'GraphicsFunc'));




global DOCUDIR
global FIGUREDIR

DOCUDIR = fullfile(pwd, 'Docus');
FIGUREDIR = fullfile(pwd, 'Docus/Figures');

global versMajor
versMajor = 4;

global versMinor
versMinor = 0;

