#!/bin/bash

##Resource Request

#SBATCH --output ./Slurm_Logs/ardan.out
#SBATCH --partition=gpuq ## the partitions to run in (comma separated)
#SBATCH --ntasks=1 ## number of tasks to run (analyses) to run
#SBATCH --gpus-per-task=2 ##number of gpus per task
#SBATCH --mail-user={user-email}
#SBATCH --mail-type=ALL ##Get email about all updates

##Load the matlab module
module load {as-installed-on-system}

##Run the script
./execute-func.sh './woodscape-sample-data/' './nssfr-demo/' 0
./pre-processing/multi-run-analysis-preproc.sh './nssfr-demo/'
