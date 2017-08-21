#!/bin/bash

# Calculate signal to noise ratios across a time-series for the human connectome project data


# TSNR calculated in Smith et al. 2013, Neuroimage, as:
# MEAN = mean(BO.cdata,tpDim); # along the time dimension
# STD=std(BO.cdata,[],tpDim); # along the time dimension
# TSNR = MEAN ./ sqrt(UnstructNoiseVar); # this is the noise not associated with other known sources of noise

SUBJECT=$1
echo "working on subject: $SUBJECT"

MASKDIR=$2
echo "mask directory: $MASKDIR"

IMAGE=$3
echo "image doing the work on: $IMAGE"

IMAGENAME=$4
echo "image name: $IMAGENAME"

if [[ $# -lt 3 ]]; then
    echo "Not enough input arguments"
    exit
fi

# go to the directory with the resting-state data images.
cd $SUBJECT
mkdir snr_stats

MASKS=(`ls ${MASKDIR}/*_2mm.nii.gz`)
echo ${MASKS[@]}

SUBNAME="$(echo ${SUBJECT} | cut -c 70- )"
echo $SUBNAME

for MASK in ${MASKS[@]}
do

# ## USED IF THE MASK IS MPFC
# # name of the mask - to use for text file naming...
# MASKNAME="$(echo ${MASK%_2mm.nii*} | cut -c 79- )"
# echo $MASKNAME

## USED IF THE MASK IS HIPPOCAMPUS
# name of the mask - to use for text file naming...
MASKNAME="$(echo ${MASK%_2mm.nii*} | cut -c 86- )"
echo $MASKNAME

# get the mean of resting state image
fslmaths $IMAGE -mas ${MASK} -Tmean tmpMU

# get the std of resting state image
fslmaths $IMAGE -mas ${MASK} -Tstd tmpSIGMA

# calculate SNR from mean and std of resting state image
fslmaths tmpMU -div tmpSIGMA tmpSNR

# summary of SNR for this time-series data
echo -e "${SUBNAME}, $(fslstats tmpSNR -k $MASK -M)" >> snr_stats/${MASKNAME}_${IMAGENAME}.txt
done