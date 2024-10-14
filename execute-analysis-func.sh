#!/bin/bash
selpath=$1
selmsk_flag=$2
hfile="${selpath}horizontal.csv"
vfile="${selpath}vertical.csv"
roi="${selpath}roi.mat"
tt_img="${selpath}tt_img.png"

if [ -d "$selpath" ]; then
    echo "$selpath does exist."
    if [ ! -f "$hfile" ] || [ ! -f "$vfile" ] || [ ! -f "$roi" ] || [ ! -f "$tt_img" ]; then
        echo "Required results files do not exist."
        exit 1
    fi
else
    echo "$selpath does not exist."
    exit 1
    
fi

func="multi_exp_analysis_func('$selpath')"

matlab -nodisplay -nosplash -r $func
