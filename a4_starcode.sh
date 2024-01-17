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
#module load starcode

#### RUN Parameters: ####
NEW_FQ="assets/lists/fq_files_filtered_names_R1_path.txt"
INFILE=$(sed -n "${SGE_TASK_ID}p" "$NEW_FQ")
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