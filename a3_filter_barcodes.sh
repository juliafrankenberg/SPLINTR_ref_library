#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=32G
#$ -l h_rt=8:0:0
#$ -cwd
#$ -t 1-2
#$ -o results/filter_barcodes_2/summary_filter.txt
#$ -e job_errors/


# place full path to desired output directory here
OUTDIR="results/filter_barcodes_2" 

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
RAW_DATA=assets/lists/raw_data_path_R1.txt
NEW_FQ=assets/lists/fq_files_filtered_names_R1.txt
INFILE=$(sed -n "${SGE_TASK_ID}p" $RAW_DATA)
OUTPUT=results/filter_barcodes_2/$(sed -n "${SGE_TASK_ID}p" $NEW_FQ)
#PATTERN='([ATCG][ATCG][GC][AT][GC][ATGC][ATCG][AT][GC][AT]){6}' #NNSWS NNWSW - SPLINTR GFP pattern
PATTERN='([ATCG][ATCG][AT][GC][AT][ATGC][ATCG][GC][AT][GC]){6}' #NNWSW NNSWS - SPLINTR BFP pattern
#PATTERN='([ATCG][AT][ATGC][GC][ATGC][AT][ATCG][GC][ATGC][AT][ATCG][GC]){5}' #NWNSNW NSNWNS - SPLINTR mCHERRY pattern


# run script
python $SCRIPT --input $INFILE --output $OUTPUT --regex $PATTERN --upconstant 'TACGATTGACTA' --downconstant 'TGCTAATGCGTACTG' -q 30 -l 60

# deactivate environment
deactivate