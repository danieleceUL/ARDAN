#!/bin/bash

##Resource Request

#SBATCH --output ./Slurm_Logs/ardan-vkitti-defocus.out
#SBATCH --partition=gpuq ## the partitions to run in (comma separated)
#SBATCH --ntasks=1 ## number of tasks to run (analyses) to run
#SBATCH --gpus-per-task=2 ##number of gpus per task
#SBATCH --mail-user=daniel.jakab@ul.ie
#SBATCH --mail-type=ALL ##Get email about all updates

##Load the matlab module
module load matlab/R2024a

##Run the script
./execute-func.sh './VKITTI-defocus/' './nssfr-results/VKITTI/' 0
./pre-processing/multi-run-analysis-preproc.sh './nssfr-results/VKITTI'
