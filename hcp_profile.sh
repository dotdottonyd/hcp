#!/bin/bash

hcpdir=$HOME/analysis/hcp
fatdir=$HOME/analysis/fat
patdir=$HOME/analysis/pat
fmriaqdir=$HOME/analysis/fmriqa

export STUDY=hcp
if [ -z $(echo $HOSTNAME | grep stampede) ]; then
    export STUDYDIR=$WORK/prestonlab/hcp
else
    export STUDYDIR=$WORK/lonestar/prestonlab/hcp
fi

# add fat and hcp directories to path
export PATH=$PATH:$hcpdir
export PATH=$PATH:$fatdir/preproc:$fatdir/utils:$fatdir/model:$fatdir
export SRCDIR=$srcdir

# python path
export PYTHONPATH=$PYTHONPATH:$fatdir/utils:$fatdir/preproc:$fatdir/rsa:$fatdir/mvpa
export PYTHONPATH=$PYTHONPATH:$patdir/core
export PYTHONPATH=$PYTHONPATH:$hcpdir
export PYTHONPATH=$PYTHONPATH:$fmriqadir

# hcp environment variables
export HCPDIR=$WORK/prestonlab/hcp
export SUBJECTSDIR=${HCPDIR}/subjects
export SUBJECTS=(100307 103414 110411 115320 120111 125525 129028 133928 140925 149337 153025 162733 190031 211417 245333 499566 856766 100408 103818 111312 116524 122317 126325 130013 135225 144832 149539 154734 163129 192540 211720 280739 654754 857263 101107 105014 111716 117122 122620 127630 130316 135932 146432 149741 156637 176542 196750 212318 298051 672756 899885 101309 105115 113619 118528 123117 127933 131217 136833 147737 151223 159340 178950 198451 214423 366446 751348 101915 106016 113922 118730 123925 128127 131722 138534 148335 151526 160123 188347 201111 221319 397760 756055 103111 108828 114419 118932 124422 128632 133019 139637 148840 151627 161731 189450 208226 239944 414229 792564)

# directories
export MASKDIR=${HCPDIR}/masks
export MTL_SMALL=${MASKDIR}/mni_mtl/mtl_small_divide
export MTL_LARGE=${MASKDIR}/mni_mtl/mtl_large_divide
export MPFC_SMALL=${MASKDIR}/mni_mpfc/mpfc_small_divide
export BATCHDIR=${HCPDIR}/batch
export LAUNCHDIR=${HCPDIR}/batch/launchscripts
export SCRIPTDIR=${HCPDIR}/scripts

echo "hcp profile sourced"
