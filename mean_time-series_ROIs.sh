#!/bin/bash

# extract the mean time-series across the different ROIs for each subject

SUBJECT=$1
echo "working on subject: $SUBJECT"

MASKDIR=$2
echo "mask directory: $MASKDIR"

PHASE_ENC=$3
echo "image type: $PHASE_ENC"

if [[ $# -lt 3 ]]; then
    echo "Not enough input arguments"
    exit
fi

IMAGE=${SUBJECT}/rsfmri/${PHASE_ENC}/rfMRI_REST2_${PHASE_ENC}.nii.gz

MASKS=(`ls ${MASKDIR}`)
echo ${MASKS[@]}

#SUBNAME="$(echo ${SUBJECT} | cut -c 55- )"
SUBNAME=$(basename $SUBJECT)
echo $SUBNAME

for MASK in ${MASKS[@]}
do
echo "${MASKDIR}/${MASK}"

MASKNAME1=$(basename $MASK)
MASKSUBDIR=mni_rois
MASKNAME2=${MASKNAME1%_2mm.nii*}
echo $MASKNAME2

mkdir -p ${SUBJECT}/func_time-series/mni_rois
mkdir -p ${SUBJECT}/masks

EX_FUNC=${SUBJECT}/rsfmri/${PHASE_ENC}/rfMRI_REST2_${PHASE_ENC}_SBRef.nii.gz
BRAINMASK=${SUBJECT}/rsfmri/${PHASE_ENC}/brainmask_fs.2.nii.gz

#PHASE_ENC=LR
#MASK=/work/04635/adutcher/lonestar/prestonlab/hcp/masks/mni_mpfc/mpfc_small_divide/b_11m_2mm.nii.gz
#SUBDIR=${HCPDIR}/subjects/120111
#EX_FUNC=${SUBDIR}/rsfmri/LR/rfMRI_REST2_LR.nii.gz
#
## register mni mask to functional
#echo "flirt -in ${MASK}"
#echo "      -ref ${EX_FUNC}"
#echo "      -out ${SUBJECT}/masks/${MASKNAME2}_r"
#echo "      -applyxfm "
#echo "      -init ${SUBDIR}/anatomy/highres2func_${PHASE_ENC}.mat"
#echo "      -interp nearestneighbour"
#
#flirt -in ${MASK} -ref ${EX_FUNC} -out ${MASK%2mm.nii*}_r -applyxfm -init ${SUBDIR}/anatomy/highres2func_${PHASE_ENC}.mat -interp nearestneighbour

# creating new mask in mni space by transecting the mni mask with functional brainmask.
NEWMASK=${SUBJECT}/masks/${MASKNAME2}_${PHASE_ENC}_2mm_trans
fslmaths ${MASKDIR}/${MASK} -mul ${BRAINMASK} ${NEWMASK}

# extracting mean time-course
echo "running fslmeants --eig -i $IMAGE -m $NEWMASK -o ${SUBJECT}/func_time-series/${MASKSUBDIR}/${MASKNAME2}_${PHASE_ENC}_eig_func.txt"
fslmeants --eig -i $IMAGE -m ${NEWMASK} -o ${SUBJECT}/func_time-series/${MASKSUBDIR}/${MASKNAME2}_${PHASE_ENC}_eig_func.txt

done
