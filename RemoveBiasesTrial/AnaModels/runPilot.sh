#!/bin/bash

#SBATCH --job-name=TestTwoBiases
#SBATCH --account=heinkedg-esrc-nsf
#SBATCH --time 100:0:0
#SBATCH --qos castlespriority1
#SBATCH --array 1-3
#SBATCH --cpus-per-task=12
#SBATCH --output=TestTwoBiases-%a.out
#SBATCH --error=TestTwoBiases-%a.err

set -e
module purge; module load bluebear
module load MATLAB/2021b



matlab -nodisplay<<-EOF

    idx = $SLURM_ARRAY_TASK_ID;
docuFold = 'PilotData/sdaAll'
mainFolder = '/rds/homes/p/pxs906/Repository/FittADDM2GlobalLocal/RemoveBiasesTrial' ;

settings

rng('default');
delete(gcp('nocreate'));
        
    
%% Add Paths & Start Pool
cd(mainFolder);
cd(docuFold)
addpath(genpath('OKDE4DEMCMC'));
initFitting;
runFitting(idx);

EOF