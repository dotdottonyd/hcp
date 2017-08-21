#!/bin/bash
#
# this needs to be made into a more sophisticated professional processing program for hcp data

SUBJECT=$1
SUB=$(basename $SUBJECT)
echo "subject: $SUB"

PHASE_ENC=$2
echo "phase direction image: $PHASE_ENC"

IMAGE=${SUBJECT}/rsfmri/${PHASE_ENC}/rfMRI_REST2_${PHASE_ENC}.nii.gz
echo "image: $IMAGE"

# first, segment from T1w image
#	create masks from tissues
#	extract time-series from these masks

echo "running: $SCRIPTDIR/subj_tissue-type_segment_and_time-series.sh $SUBJECT $PHASE_ENC"
$SCRIPTDIR/subj_tissue-type_segment_and_time-series.sh $SUBJECT $PHASE_ENC

# second, run fmriqa script to give confound variable
#	create temporal derivatives of movement text file
#	create FD and DVARS - from Power et al.

FUNCDIR=${SUBJECT}/rsfmri/${PHASE_ENC}

infile=${FUNCDIR}/rfMRI_REST2_${PHASE_ENC}.nii.gz
maskfile=${FUNCDIR}/brainmask_fs.2.nii.gz
motfile=${FUNCDIR}/Movement_Regressors.txt

echo "running: python $HOME/analysis/fmriqa/hcp_movement_cons.py $infile $maskfile $motfile"
python $HOME/analysis/fmriqa/hcp_movement_cons.py $infile $maskfile $motfile

# third, get subject specific function time-series for each roi
#	get time-series for mpfc directories
#	get time-series for mtl directories
#	get time-series for lateral frontal directories
#	get time-sereis for parietal directories

MPFC_MASKS=${HCPDIR}/masks/mni_mpfc/mpfc_small_divide
#LFC_MASKS=${HCPDIR}/masks/mni_lfc
HIP_MASKS=${HCPDIR}/masks/mni_mtl/mtl_large_divide

#for MASK in ${MPFC_MASKS[@]} ${HIP_MASKS[@]}; do

echo "running: $SCRIPTDIR/mean_time-series_ROIs.sh $SUBJECT $MPFC_MASKS $PHASE_ENC"
$SCRIPTDIR/mean_time-series_ROIs.sh $SUBJECT $MPFC_MASKS $PHASE_ENC

echo "running: $SCRIPTDIR/mean_time-series_ROIs.sh $SUBJECT $MTL_MASKS $PHASE_ENC"
$SCRIPTDIR/mean_time-series_ROIs.sh $SUBJECT $HIP_MASKS $PHASE_ENC

#done

# # fourth, run 1st level based upon a template
# echo "running: $SCRIPTDIR/run_1st-level_seed_conn_from_templateFSF.sh"
# $SCRIPTDIR/run_1st-level_seed_conn_from_templateFSF.sh
