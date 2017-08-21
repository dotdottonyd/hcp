#!/bin/bash

####################################################################
## files/directories
####################################################################

# get subject
SUBJECT=$1
SUB=$(basename $SUBJECT)
echo "subject: $SUB"

# phase encoding direction of image
PHASE_ENC=$2
echo "phase encoding direction: $PHASE_ENC"

# time-series data
IMAGE=${SUBJECT}/rsfmri/${PHASE_ENC}/rfMRI_REST2_${PHASE_ENC}.nii.gz
echo "image extracting time-series from: $IMAGE"

# segmented portions of brain used as input to registration steps
CSF=${SUBJECT}/rois/CSFReg.2.nii.gz
WM=${SUBJECT}/rois/WMReg.2.nii.gz

####################################################################
## get eigen time-series of the data
####################################################################

# text files to hold mean-times series in ROIs
CSF_TXT=${SUBJECT}/func_time-series/wholebrain/CSF_${PHASE_ENC}.txt
WM_TXT=${SUBJECT}/func_time-series/wholebrain/DeepWM_${PHASE_ENC}.txt

# get mean time series and write to text file
echo "writing eigen time-series to CSF, and deep WM"
fslmeants --eig -i ${IMAGE} -m ${WM} > ${WM_TXT}
fslmeants --eig -i ${IMAGE} -m ${CSF} > ${CSF_TXT}
