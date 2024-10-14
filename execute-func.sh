#!/bin/bash
selpath=$1
resultdir=$2
selmsk=$3

if [ -d "$selpath" ] && [ -d "$resultdir" ]; then
    echo "$selpath and $resultdir does exist."
else
    echo "$selpath and $resultdir does not exist."
    exit 1
    
fi

if [ ! "$selmsk" -eq 0 ]; then
    if [ -f "$selmsk" ] && [ "${file: -4}" == ".mat" ]; then
        echo "$selmsk is a valid .mat file"
    else
        echo "$selmsk is not a valid .mat file"
        exit 1
    fi
fi
func="multi_exp_run_func('$selpath','$resultdir',$selmsk)"

matlab -nodisplay -nosplash -r $func
