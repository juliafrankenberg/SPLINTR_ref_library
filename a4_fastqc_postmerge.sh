#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=8G
#$ -l h_rt=1:0:0
#$ -cwd
#$ -t 1-2
#$ -o job_output/
#$ -e job_errors/

module load fastqc

FQ_LIST=assets/lists/merged_fq_names.txt
SAMPLE=results/ngmerge/$(sed -n "${SGE_TASK_ID}p" $FQ_LIST)
OUTDIR="results/fastqc/merged_reads" 

# setup output directory if it does not already exist
if [ ! -d $OUTDIR ]; then
    mkdir $OUTDIR
fi

fastqc -o $OUTDIR $SAMPLE