#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=32G
#$ -l h_rt=8:0:0
#$ -cwd
#$ -t 1-2
#$ -o results/filter_barcodes_merged/summary_filter.txt
#$ -e job_errors/


# place full path to desired output directory here
OUTDIR="results/filter_barcodes" 

# setup output directory if it does not already exist
if [ ! -d $OUTDIR ]; then
    mkdir $OUTDIR
fi

# load modules and activate environment with python packages for splintr analyses
module purge
module load python
source splintr/bin/activate
 
#### RUN Parameters: ####

SCRIPT=extractBarcodeReads.py
FQ_LIST=assets/lists/merged_fq_names.txt
INFILE=results/ngmerge/$(sed -n "${SGE_TASK_ID}p" $FQ_LIST)
OUTPUT=$OUTDIR/$(sed -n "${SGE_TASK_ID}p" $FQ_LIST)
#PATTERN='([ATCG][ATCG][GC][AT][GC][ATGC][ATCG][AT][GC][AT]){6}' #NNSWS NNWSW - SPLINTR GFP pattern
PATTERN='([ATCG][ATCG][AT][GC][AT][ATGC][ATCG][GC][AT][GC]){6}' #NNWSW NNSWS - SPLINTR BFP pattern
#PATTERN='([ATCG][AT][ATGC][GC][ATGC][AT][ATCG][GC][ATGC][AT][ATCG][GC]){5}' #NWNSNW NSNWNS - SPLINTR mCHERRY pattern


# run script
python $SCRIPT --input $INFILE --output $OUTPUT --regex $PATTERN --upconstant 'TACGATTGACTA' --downconstant 'TGCTAATGCGTACTG' -q 30 -l 60

# deactivate environment
deactivate