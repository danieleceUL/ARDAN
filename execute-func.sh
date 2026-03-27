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

#if [ ! "$selmsk" -eq 0 ]; then
if [ -f "$selmsk" ]; then
    echo "$selmsk is a valid .mat file"
    func="multi_exp_run_func('$selpath','$resultdir','$selmsk')"
else
    selmsk=0
    echo "No mask file provided, proceeding without mask."
    func="multi_exp_run_func('$selpath','$resultdir',$selmsk)"
fi
#fi

matlab -nodisplay -nosplash -r $func
