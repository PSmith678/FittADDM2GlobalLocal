#!/bin/bash

#SBATCH --job-Test
#SBATCH --account=heinkedg-modeling-esrc-nsf
#SBATCH --time 100:0:0
#SBATCH --qos castles
#SBATCH --array 1-34
#SBATCH --cpus-per-task=12
#SBATCH --output=Test-%a.out
#SBATCH --error=Test-%a.err

set -e
module purge; module load bluebear
module load MATLAB/2021b



matlab -nodisplay<<-EOF

    idx = $SLURM_ARRAY_TASK_ID;
docuFold = 'PilotData/sdaAll';
mainFolder = '/rds/projects/h/heinkedg-modeling-visual-search/jordan/' ;



rng('default');
delete(gcp('nocreate'));
        
    
%% Add Paths & Start Pool
cd(mainFolder);
cd(docuFold)
addpath(genpath('OKDE4DEMCMC'));
initFitting;
runFitting(idx);
EOF