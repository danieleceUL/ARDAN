# Adapative NSSFR with sfrmat5
NS-SFR with sfrmat5 and custom data convexity between first maximum and first minimum of SFR measurements.
Regional masks created for KITTI, Woodscape, KITTI-360 and LMS.

# Region of Interest (ROI) Selection on Front View Woodscape
Before Data Convexity:
![roi select](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/00000_FV_H.png)

After Data Convexity:
![roi select](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/00000_FV_H_data_convex.png)

# Data Convexity
Data convexity detects and filters out drastic slope changes in measurements.
Eliminates measurements with behaviour such as line No. 11 :
![data convexity](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/00000_FV_NS_SFR_Horizontal_SFR.jpg)

After Data Convexity is applied to measurements:
![data convexity](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/00000_FV_NS_SFR_Horizontal_SFR_data_convex.jpg)

For more information see:
- [NS-SFR GUI](https://github.com/OlivervZ11/NSSFR-GUI)
- [sfrmat5](http://burnsdigitalimaging.com/software/sfrmat/iso12233-sfrmat5/)

# GPU Acceleration

Current algorithm has GPU hardware accelereation support for 4 workers using parallel pooling.
Code automatically detects whether there is GPU/CPU only on system and executes code according to step.
GPU support recommended for large datasets with 10+ images.

Sample code showing GPU detection:

![gpu acc](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/gpu-acc.png)

![gpu acc](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/gpu-acc-2.png)

# Sample Run

## Part 1

1. On executing code  'SFR_roi_proposal.m' in Matlab, the following GUI box appears for user, please navigate and open appropriate directory with images:

![data](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/folder-with-data.png)

2. Choose appropriate regional mask for KITTI, Woodscape, SynWoodscape or LMS datasets

![masks](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/regional-masks.png)

3. Choose destination directory in which results should be saved:

![target folder](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/folder-with-results.png)

Results and CSV files will be saved automatically in the target directory and execution time depends on the number of test images present in the data folder.

## Part 2
. On executing code 'SFR_roi_analysis.m' in Matlab, the following GUI box appears for user. Please choose the target directory in which results are saved for Radial Distance and Heatmap analysis:

![target folder](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/select-results-folder.png)

Sample Spatial Distribution with Radial Distances:

![spa dist](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/sample_results/spatial_dist_horizontal_ROIs.png)

Sample Heatmap results for MTF50 per 5x8 region of spatial domain:

![spa dist](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/sample_results/surface_plot_horizontal_MTF50_mean.png)

Sample Results:

![MTF measure](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/mean_horizontal_MTFs_per_Annuli.png)

