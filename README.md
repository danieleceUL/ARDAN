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
Eliminates measurements with behaviour such as the green line of No.11:
![data convexity](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/00000_FV_NS_SFR_Horizontal_SFR.jpg)

After Data Convexity is applied to measurements:
![data convexity](https://github.com/danieleceUL/adaptive_nssfr_sfrmat5/blob/main/images/00000_FV_NS_SFR_Horizontal_SFR_data_convex.jpg)

For more information see:
- [NS-SFR GUI](https://github.com/OlivervZ11/NSSFR-GUI)
- [sfrmat5](http://burnsdigitalimaging.com/software/sfrmat/iso12233-sfrmat5/)

## Major changes include
Capacity to read in masked areas of a natural scene. Tested under conditions of a test chart as shown above.
