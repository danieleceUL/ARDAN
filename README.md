# ARDÁN: Automotive Radial Distortion Analysis for Camera Quality
Measuring optical quality in camera lenses is a crucial step in evaluating cameras, especially for safety-critical visual perception tasks in automotive driving. While ground-truth labels and annotations are provided in publicly available automotive datasets for computer vision tasks, there is a lack of information on the image quality of camera lenses used for data collection. To compensate for this, we propose an Automotive Radial Distortion Analysis (ARDÁN) to evaluate Slanted Edges for ISO12233 in five publicly available automotive datasets using a valid and invalid region of interest (ROI) selection system in natural scenes. We use the mean of 50\% of the Modulation Transfer Function (MTF50) in three Camera Radial Distance (CRD) segments and $5 \times 8$ Heatmap Dataset Distributions (HDD) to evaluate the quality of edges in natural scenes. It was found that for lenses with uniform spatial domains (no distortion), MTF50 was constant between (0.18-0.22) whereas for strong radial distortion, MTF50 varied extensively across the spatial domain between (0.15-0.377) where in particular Woodscape gives the highest average of MTF50 for natural scenes. For more information on results please see our research paper for more details. 

# Sample Region of Interest (ROI) Selection on KITTI
## Original KITTI Qualitative Results
![unr roi select kitti](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/unr-ROI-select.png)
## Rectified KITTI Qualitative Results
![rect roi select kitti](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/rect-ROI-select.png)

## MTF50 Measurements
<p float="kitti MTF50">
<img src="https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/0000000005_NS_SFR_Horizontal_SFR_ROI_MTF50.png" width=40% height=40%>
<img src="https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/0000000000_NS_SFR_Horizontal_SFR_ROI_MTF50.png" width=40% height=40%>
</p>
<p>
  <em>Unrectified KITTI</em>
  \vspace{10cm}
  <em>Rectified KITTI</em>
</p>

# ROI Selection on Front View Woodscape
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
On executing code 'SFR_roi_analysis.m' in Matlab, the following GUI box appears for user. Please choose the target directory in which results are saved for Radial Distance and Heatmap analysis:


## Sample Results
![target folder](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/select-results-folder.png)

Sample Spatial Distribution with Radial Distances:

![spa dist](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/sample_results/spatial_dist_horizontal_ROIs.png)

Sample Heatmap results for MTF50 per 5x8 region of spatial domain:

![spa dist](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/sample_results/surface_plot_horizontal_MTF50_mean.png)

Sample Results (Note: MTF on y-axis):

![mtf measure](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/sample_results/mean_horizontal_MTFs_per_Annuli.png)

