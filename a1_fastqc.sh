#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=8G
#$ -l h_rt=1:0:0
#$ -cwd
#$ -t 1-4
#$ -o job_output/
#$ -e job_errors/

module load fastqc

LIST=assets/lists/raw_data_path.txt
SAMPLE=$(sed -n "${SGE_TASK_ID}p" $LIST)
OUTDIR="results/fastqc/raw_data" 

# setup output directory if it does not already exist
if [ ! -d $OUTDIR ]; then
    mkdir $OUTDIR
fi

fastqc -o $OUTDIR $SAMPLE