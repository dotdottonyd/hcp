# hcp
This is a readme file for human connectome connectivity analysis.
HCP working directory: /work/04635/adutcher/lonestar/prestonlab/hcp/

GOAL OF PROJECT
The goal of this project is to analyze patterns of connectivity across a large population of high-volume resting-state data.

WHAT DATA IS BEING USED?
The analysis scripts are created for analyzing fully processed data i.e. fully extended preprocessed rsfmri data from 
HCP website: https://db.humanconnectome.org. Where stated, analysis pipelines will attempt to make explicit is any 
registration or normalization is done on individual images. This isnt necessarily the case because individual functional 
data is in MNI space, therefore we can use masks (derived from MNI space) as a reasonable estimate of being in the same 
place across subjects. A second set of scripts is being developed to perform preprocessing and analysis within each subject
to account for individual differences before bringing into standard space. 

WHAT WE ARE LOOKING FOR?
We have specific hypotheses about connectivity between anterior portions of the hippocampus and posterior portions of medial
prefrontal regions, i.e. increased connectivity for these specific regions compared to posterior hippocampus connectivity to
the same regions. However, we also have an interest in exploring connectivity to other regions of the brain i.e. parietal 
regionas and lateral prefrontal regions (citations). 

SCRIPTS THAT DO THE WORK
Below are the series of analyses that were performed on this data.
HCP script directory: /work/04635/adutcher/lonestar/prestonlab/hcp/scripts

1) TEMPORAL SIGNAL TO NOISE : snr in resting-state data can be tricky to pin down (what is the 'signal'?, usually it 
refers some manipulation or contrast of interest. In this scenario, we divide the signal related to the manipulation of 
interest by the variability in that signal. The HCP consortium described it in their 2013 paper on the resting-state data 
as the mean signal divided by the "unstructured variance". Other publications for resting-state data describe it as mean 
'signal' divided by the standard deviation of that 'signal'. Still this can be a little weird to think about. Dividing the 
mean by the standard deviation gives as a measure of the dispersion of the data a smaller standard deviation giving less
variation in the mean signal - a more 'consistent signal'. This conception however, is not without its flaws. 

        1a) snr_time-series.sh takes subject information, an image and a mask and calculates t-SNR by taking the mean 
        divided by the std of the time-series.


2) PREP FOR SEED-BASED CONNECTIVITY ANALYSIS: for seed-based connectivity analysis we are interested in differential 
connectivity across the anterior-posterior axis of the hippocampus. Thus, we have defined seeds along the anterior posterior
axis in a few ways: 1) large divides i.e. anterior, body, and tail; and 2) small divides i.e. 4mm slices along the anterior-
posterior axes (derived from MNI space). Using these seed regions we will look for connectivity throughout the entire brain.
We will need to control for factors that can influence connnectivity patterns.

        2a) run subj_tissue-type_segment_and_time-series.sh on individual subjects to get the tissue time-series i.e. CSF and
        white matter as covariates into the model.
        2b) run meant_time-series_ROIs.sh on individual subjects and a directory of mask images in the same space as the
        functional images. 
        2c) run 'RUN_hcp_movement_FD_DVARS.sh' to get subject specific confounds to be used in the 1st level model.


3) SEED-BASED CONNECTIVITY ANALYSIS, 1ST LEVEL: run 'run_1st-level_seed_conn_from_templateFSF.sh', which requires 2a and 2b to be run AND a template
design.fsf file to be used for different subjects and different masks. 


4) SEED-BASED CONNECTIVITY ANALYSIS, '3RD LEVEL':
to be determined..
