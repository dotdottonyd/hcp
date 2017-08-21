#!/usr/bin/env python

import os
import sys
import subprocess as sub
from glob import glob

#from subjutil import *
#
#parser = SubjParser()
#parser.add_argument('model', help="name of model")
#parser.add_argument('--feat-pattern', '-f',
#                    help="regular expression for feat directories (default: ^\D+_\d+\.feat$)",
#                    metavar='regexp',
#                    default='^\D+_\d+\.feat$')
#parser.add_argument('--anat', '-a',
#                    default="anatomy/bbreg/data/orig_brain",
#                    help="path to anatomical image in functional space, relative to subject directory (default: anatomy/bbreg/data/orig_brain)")
#args = parser.parse_args()
#
#print args
#
#sp = SubjPath(args.subject, args.study_dir)
#
#print sp
#
#log = sp.init_log('%s_level1_ident' % args.model, 'model', args)
#
#feat_dirs = sp.feat_dirs(args.model)
#
#print feat_dirs
#
#highres = impath(sp.subj_dir, args.anat)

subdir = str(sys.argv[1])
# subdir = '/work/04635/adutcher/lonestar/prestonlab/hcp/subjects/100408'
seed_region = str(sys.argv[2]) # feat dir
# e.g. l_hip_ant
phase_enc = str(sys.argv[3])
# phase_enc= 'LR'

featdir=os.path.join( subdir, 'model_%s'%phase_enc, 'no_pre-reg', '%s.feat'%seed_region )
identitydir = '/home1/04635/adutcher/analysis/fat/resources'

highres = os.path.join(subdir, 'rsfmri', phase_enc, 'SBRef_dc.nii.gz')
identity = os.path.join(identitydir, 'identity.mat')

reg_dir = os.path.join( featdir, 'reg')

p=sub.Popen('mkdir -p %s' % reg_dir, stdout=sub.PIPE, stderr=sub.PIPE, shell=True)
stdout,stderr=p.communicate()
p=sub.Popen('ln -sf %s %s' % (highres, os.path.join(reg_dir, 'highres.nii.gz')), stdout=sub.PIPE, stderr=sub.PIPE, shell=True)
stdout,stderr=p.communicate()
p=sub.Popen('ln -sf %s %s' % (highres, os.path.join(reg_dir, 'standard.nii.gz')), stdout=sub.PIPE, stderr=sub.PIPE, shell=True)
stdout,stderr=p.communicate()
p=sub.Popen('cp %s %s' % (identity, os.path.join(reg_dir, 'standard2example_func.mat')), stdout=sub.PIPE, stderr=sub.PIPE, shell=True)
stdout,stderr=p.communicate()
p=sub.Popen('cp %s %s' % (identity, os.path.join(reg_dir, 'example_func2standard.mat')), stdout=sub.PIPE, stderr=sub.PIPE, shell=True)
stdout,stderr=p.communicate()
p=sub.Popen('updatefeatreg %s -pngs' % featdir, stdout=sub.PIPE, stderr=sub.PIPE, shell=True)
stdout,stderr=p.communicate()
