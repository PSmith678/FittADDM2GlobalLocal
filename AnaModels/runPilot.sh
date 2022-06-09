#!/bin/bash

#SBATCH --job-name=Test
#SBATCH --account=heinkedg-esrc-nsf
#SBATCH --time 100:0:0
#SBATCH --qos castles
#SBATCH --array 1-10
#SBATCH --cpus-per-task=12
#SBATCH --output=Test-%a.out
#SBATCH --error=Test-%a.err

set -e
module purge; module load bluebear
module load MATLAB/2021b



matlab -nodisplay<<-EOF

    idx = $SLURM_ARRAY_TASK_ID;
docuFold = 'PilotData/sdaAll'
mainFolder = '/rds/homes/p/pxs906/Repository/FittADDM2GlobalLocal' ;

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