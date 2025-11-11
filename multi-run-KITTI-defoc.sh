#!/bin/bash

##Resource Request

#SBATCH --output ./Slurm_Logs/ardan-kitti-defocus.out
#SBATCH --partition=gpuq ## the partitions to run in (comma separated)
#SBATCH --ntasks=1 ## number of tasks to run (analyses) to run
#SBATCH --gpus-per-task=1 ##number of gpus per task
#SBATCH --mail-user=daniel.jakab@ul.ie

##Load the matlab module
module load matlab/R2024a

##Run the script
./execute-func.sh "./KITTI-defocus" "./nssfr-results/KITTI/" 0
./pre-processing/multi-run-analysis-preproc.sh "./nssfr-results/KITTI"
