#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=32G
#$ -l h_rt=8:0:0
#$ -cwd
#$ -t 1-2
#$ -o job_output/
#$ -e job_errors/


#### Load default modules ####
module purge
module load starcode

#### RUN Parameters: ####
FQ_LIST="assets/lists/merged_fq_names.txt"
INFILE=results/filter_barcodes/$(sed -n "${SGE_TASK_ID}p" "$FQ_LIST")
OUTDIR="results/starcode" 

# setup output directory if it does not already exist
if [ ! -d $OUTDIR ]; then
    mkdir $OUTDIR
fi

name=$(basename $INFILE)
name=${name%%.*}


STARCODE="/data/home/hfy179/local/starcode/starcode"
$STARCODE -v

# distance auto
$STARCODE -t ${NSLOTS} $INFILE > ${OUTDIR}/${name}_starcode_auto.txt