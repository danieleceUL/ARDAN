# ARDÁN: Automated Reference-free Defocus Characterization for Automotive Near-field Cameras
Measuring optical quality in camera lenses is a crucial step in evaluating cameras, especially for safety-critical visual perception tasks in automotive driving. While ground-truth labels and annotations are provided in publicly available automotive datasets for computer vision tasks, there is a lack of information on the image quality of camera lenses used for data collection. To compensate for this, we propose an Automated Reference-free Defocus characterization for Automotive Near-field cameras (ARDÁN) to evaluate Slanted Edges for ISO12233 in five publicly available automotive datasets using a valid and invalid region of interest (ROI) selection system in natural scenes. We use the mean of 50% of the Modulation Transfer Function (MTF50) in three Camera Radii (CaRa) segments and the Overall Spread in Heatmaps(O’SHea) for an 8×5 distribution to evaluate the quality of edges in natural scenes. From the experiments performed, lenses with uniform spatial domains (i.e. little distortion) showed that MTF50 was constant between (0.18 0.25cy/px). With image rectification on the same scenes, MTF50 results artificially increased, no longer representing the camera lens. In contrast, for strong radial distortion, MTF50 varied extensively across the spatial domain between (0.12-0.4cy/px) where in particular Woodscape gave the highest average of MTF50 per region for natural scenes.
## Paper
It would be appreciated if a reference to the official paper is included whenever this code is used for a publication:
```rb
    @article{jakab2024ardan,
        title={ARD{\'A}N: Automated Reference-free Defocus Characterization for Automotive Near-field Cameras},
        author={Jakab, Daniel and Grua, Eoin Martino and Mohandas, Reenu and Deegan, Brian Michael and Scanlan, Anthony and Molloy, Dara and Ward, Enda and Eising, Ciar{\'a}n},
        journal={IEEE Access},
        year={2024},
        publisher={IEEE}
    }
```
Please also refer to previous work from Zwanenberg et al. with regards to the NS-SFR component of the ARDÁN platform in the link below: 
- [NS-SFR GUI](https://github.com/OlivervZ11/NSSFR-GUI)

Please also refer to sfrmat5 the 5th version of the Slanted Edge Method originally created by Burns et al.: 
- [sfrmat5](http://burnsdigitalimaging.com/software/sfrmat/iso12233-sfrmat5/)

# Sample Region of Interest (ROI) Selection on KITTI
## Original KITTI Qualitative Results
![unr roi select kitti](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/unr-ROI-select.png)
## Rectified KITTI Qualitative Results
![rect roi select kitti](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/rect-ROI-select.png)

Note: You may wish to disable the red bounding boxes as they represent potential slanted edge measurements which have been discarded from overall analysis.
in the 'multi_exp_run.m' change the parameter `valInval=1` to `valInval=0` and proceed as per instructions. The commit files already provide the default position of `valInval=0`.

## MTF50 Measurements for Unrectified KITTI vs Rectified KITTI
<p float="kitti MTF50">
<img src="https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/0000000005_NS_SFR_Horizontal_SFR_ROI_MTF50.png" width=40% height=40%>
<img src="https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/0000000000_NS_SFR_Horizontal_SFR_ROI_MTF50.png" width=40% height=40%>
</p>

# Methodology
Below is an illustration of the constraints applied for valid and invalid ROI selection:
<p>
<img src="https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/MTF_constraints.png" width=50% height=50%>
</p>

**MTF Convexity**: Checking for convexity is a method for ensuring a consistently smooth slope in MTF curves. Slope change or the rate of change in MTF is of interest. Depending on the position of the first local maximum and minimum measurements, the most significant drop in MTF across the sampling points between 0 and 1 is recorded.<br/>
**Energy Limitation above Nyquist frequency**: The area under the curve after 0.5 cy/px should not
exceed 0.2 (0.5cy/px × 0.4SFR) which is at the limit of the local minima constraint.<br/>
**Regional Mask Lens Alignment(RMLA)**: A strategy for aligning the regional mask with the geometry of the
camera. This ensures the complete removal of any camera vignetting which contains the dark corners where light falls off the lens.<br/>
# MTF Convexity
## Qualitative Results for Front View Woodscape
### Before Convexity
![roi select](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/00000_FV_H.png)
![bf mtf convexity](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/00000_FV_NS_SFR_Horizontal_SFR.jpg)
### After Convexity
![roi select](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/00000_FV_H_data_convex.png)
MTF convexity detects and filters out drastic slope changes in measurements.
Eliminates measurements with behaviour such as line No. 11 from above. <br/>
After Data Convexity is applied to measurements:
![af mtf convexity](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/00000_FV_NS_SFR_Horizontal_SFR_data_convex.jpg)

# Regional Mask Lens Alignment(RMLA)
![rmla](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/masks/sample-rmla.png)


# GPU Acceleration

Current algorithm has GPU hardware acceleration support for 4 workers using parallel pooling.
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

### Multi Run (for datasets in excess of 2500+ images)
You may also wish to run **Part 1** as a sequence known as a *multi run* where the original dataset size is in excess of 2500+ images. Any dataset larger than this size should be split into sub-directories and use *multi run* for a complete analysis. For example, the entire left side of KITTI 360 contains 11,518 images in total which can be divided into 13 subdirectories containing 886 images each as shown below:

![multi-run](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/multi_run.PNG)

Note: if multi run is used, each of the 13 sub-directories will contain a *.csv* for both horizontal and vertical slanted edge measurements for the 886 images in the sub-directory. All 13 separate results should be transferred to a combination folder as shown above and the csv files should be appended for a complete set of results on the entire dataset. Once this is complete you may proceed to **Part 2** where analysis should continue from the *combination* folder.
A strategy of file transfer would be recursively iterating through the subdirectories finding *horizontal.csv* and *vertical.csv* and copying over to the empty combination folder with appended numbering format such as *horizontal-N.csv* where *N = 1...N* folders. This is performed by the Bash script located in the *pre-processing* folder. Please see the following linux commands:

Markup :
```rb
    foo@bar:~/{path-to-ARDAN-folder}/pre-processing$ chmod +x multi-run-analysis-preproc.sh
    foo@bar:~/{path-to-ARDAN-folder}/pre-processing$ ./multi-run-analysis-preproc.sh {path-to-results-folder-with-multi-run-subdirectories} 
```

## Part 2
On executing code 'SFR_roi_analysis.m' in Matlab, the following GUI box appears for user. Please choose the target directory in which results are saved for Radial Distance and Heatmap analysis:


## Sample Results
![target folder](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/select-results-folder.png)

FV Woodscape Horizontal Spatial Distribution with Radial Distances:

![spa dist](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/sample_results/spatial_dist_horizontal_ROIs.png)

FV Woodscape Horizontal Heatmap results for MTF50 per 5x8 region of spatial domain:

![spa dist](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/sample_results/surface_plot_horizontal_MTF50_mean.png)

FV Woodscape Horizontal Results (Note: MTF on y-axis):

![mtf measure](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/sample_results/mean_horizontal_MTFs_per_Annuli_mtf50.png)

FV Woodscape Vertical Spatial Distribution with Radial Distances:

![spa dist](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/sample_results/spatial_dist_vertical_ROIs.png)

FV Woodscape Vertical Heatmap results for MTF50 per 5x8 region of spatial domain:

![spa dist](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/sample_results/surface_plot_vertical_MTF50_mean.png)

FV Woodscape Vertical Results (Note: MTF on y-axis):

![mtf measure](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/sample_results/mean_vertical_MTFs_per_Annuli_mtf50.png)
