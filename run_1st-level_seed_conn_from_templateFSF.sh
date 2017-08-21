#!/bin/bash

##############################################################
# file/directory variables
##############################################################

if [ $# -lt 3 ]; then
    echo "Usage:   run_1st-level_seed_conn_from_templateFSF.sh < subject > < mask > < image encoding direction >"
    echo "Example: run_1st-level_seed_conn_from_templateFSF.sh ${SUBJECT_PATH}/100307 ${FULL_MASK_PATH}/b_10m.nii.gz LR or RL"
    echo
    exit 1
fi

# subject directory
SUBDIR=$1

# get the subject name
SUB=$(basename $SUBDIR)
echo "subject: $SUB}"

# mask to be used
MASKNAME=$2
echo "${MASKNAME}"

# analyze images in the left to right (LR) or right to left (RL) phase encoding direction?
PHASE_ENC=$3
echo "phase encoding direction: ${PHASE_ENC}"

# set the subject's model directory and feat directory variables
SUBMODELDIR=${SUBDIR}/model_${PHASE_ENC}/no_pre-reg
FEATDIR=${SUBDIR}/model_${PHASE_ENC}/no_pre-reg/${MASKNAME}.feat

# template design file - changed for each roi and each subjects
TMPDESFILE0=/work/04635/adutcher/lonestar/prestonlab/hcp/subjects/100307/model_LR/no_pre-reg/b_10m.fsf
TMPDESFILE1=${SUBMODELDIR}/template_design_${MASKNAME}.fsf

###############################################################
## create design.fsf file for seed region of interest
###############################################################

# check to see if the template design file exists, if not exit and send error message
if [ -e TMPDESFILE0 ]; then

echo "need a template design file for mask: ${MASKNAME}"; exit
fi

# copy the template seed region design file to the subject specific directory (this file must exist!)
cp ${TMPDESFILE0} ${SUBMODELDIR}/template_design_${MASKNAME}.fsf

# navigate to subject model directory
cd $SUBMODELDIR

# change the mask name
echo " running: sed -e 's|b_10m|${MASKNAME}|g' template_design.fsf > ${MASKNAME}.fsf"
sed -e "s|b_10m|${MASKNAME}|g" template_design_${MASKNAME}.fsf > ${MASKNAME}.fsf

# change the subject number
echo " running: sed -i -e 's|100307|${SUB}|g' ${MASKNAME}.fsf "
sed -i -e "s|100307|${SUB}|g" ${MASKNAME}.fsf

# change the phase encoding direction
echo " running: sed -i -e 's|LR|${PHASE_ENC}|g' ${MASKNAME}.fsf"
sed -i -e "s|LR|${PHASE_ENC}|g" ${MASKNAME}.fsf

# remove template file
rm $TMPDESFILE1

###############################################################
## run the feat model
## get rid of unnecessary images
## add registration identity transforms for 2nd level
###############################################################

# run feat model to create design matrices and an output directory
echo "running feat!: feat ${MASKNAME}.fsf "
feat ${MASKNAME}.fsf

# navigate to output directory
echo "feat directory: ${FEATDIR}"
cd ${FEATDIR}

# set the new featdir and clean any unnecessary files to save size
echo "  running clean-up: $HOME/analysis/fat/model/clean_level1.sh ${FEATDIR} "
$HOME/analysis/fat/model/clean_level1.sh ${FEATDIR}

# set identity transforms because we don't register functional to structural in 1st level. 
# This is necessary for "3rd" level analysis.
echo "  running identity transforms for 1st level: python $SCRIPTDIR/identity_level1_hcp.py ${SUBDIR} ${FEATDIR} "
python $SCRIPTDIR/identity_level1_hcp.py ${SUBDIR} ${MASKNAME} ${PHASE_ENC}
