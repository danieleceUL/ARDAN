#!/bin/bash

##Resource Request

#SBATCH --output /home/daniel.jakab/ARDAN/Slurm_Outputs/ardan.out
#SBATCH --partition=gpuq ## the partitions to run in (comma separated)
#SBATCH --ntasks=1 ## number of tasks to run (analyses) to run
#SBATCH --gpus-per-task=2 ##number of gpus per task
#SBATCH --mail-user=daniel.jakab@ul.ie
#SBATCH --mail-type=ALL ##Get email about all updates

##Load the matlab module
module load matlab/R2024a

##Run the script
./execute-func.sh './bdd100k/100k_images_merge/' './nssfr-results/' 0
./pre-processing/multi-run-analysis-preproc.sh './nssfr-results/'
