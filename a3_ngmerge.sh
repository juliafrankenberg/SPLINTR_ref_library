#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=32G
#$ -l h_rt=12:0:0
#$ -cwd
#$ -t 1-2
#$ -o job_output/
#$ -e job_errors/

#https://github.com/harvardinformatics/NGmerge

module load anaconda3
conda activate ngmerge  #if not done yet, need to create conda env and download package there


# place full path to desired output directory here
OUTDIR="results/ngmerge" 

# setup output directory if it does not already exist
if [ ! -d $OUTDIR ]; then
    mkdir $OUTDIR
fi

FWD_LIST=assets/lists/raw_data_path_R1.txt
FWD=$(sed -n "${SGE_TASK_ID}p" $FWD_LIST)
REV_LIST=assets/lists/raw_data_path_R2.txt
REV=$(sed -n "${SGE_TASK_ID}p" $REV_LIST)
FQ_LIST=assets/lists/merged_fq_names.txt
SAMPLE_NAME=$(sed -n "${SGE_TASK_ID}p" $FQ_LIST)
OUTPUT="$OUTDIR/$SAMPLE_NAME"

# Run NGmerge
NGmerge -1 $FWD -2 $REV -o $OUTPUT -d -l "$OUTDIR/log_$SAMPLE_NAME.txt" -c "$OUTDIR/dovetail_$SAMPLE_NAME.txt" -j "$OUTDIR/formattedalign_$SAMPLE_NAME.txt"


conda deactivate