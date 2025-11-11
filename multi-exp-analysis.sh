#!/bin/bash

##Resource Request

#SBATCH --output /home/daniel.jakab/ARDAN/Slurm_Outputs/ardan-analysis.out
#SBATCH --partition=gpuq ## the partitions to run in (comma separated)
#SBATCH --ntasks=1 ## number of tasks to run (analyses) to run
#SBATCH --gpus-per-task=4 ##number of gpus per task
#SBATCH --mail-user=daniel.jakab@ul.ie
#SBATCH --mail-type=ALL ##Get email about all updates

##Load the matlab module
module load matlab/R2024a

##Run the script
./execute-analysis-func.sh './nssfr-results/combination-2/'
