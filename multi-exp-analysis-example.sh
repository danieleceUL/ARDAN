#!/bin/bash

##Resource Request

#SBATCH --output ./Slurm_Logs/ardan-analysis.out
#SBATCH --partition=gpuq ## the partitions to run in (comma separated)
#SBATCH --ntasks=1 ## number of tasks to run (analyses) to run
#SBATCH --gpus-per-task=4 ##number of gpus per task
#SBATCH --mail-user={user-email}
#SBATCH --mail-type=ALL ##Get email about all updates

##Load the matlab module
module load {as-installed-on-system}

##Run the script
./execute-analysis-func.sh './nssfr-demo/FV/'
./execute-analysis-func.sh './nssfr-demo/MVL/'
./execute-analysis-func.sh './nssfr-demo/MVR/'
./execute-analysis-func.sh './nssfr-demo/RV/'

