#!/bin/bash
#$ -pe smp 4
#$ -l h_vmem=5G
#$ -l h_rt=1:0:0
#$ -cwd
#$ -o job_output/
#$ -e job_errors/

# Change to the results/fastqc/ directory
cd results/fastqc/

# Loop through each ZIP file and extract contents
for filename in *.zip
do
    unzip "$filename"
done

# Concatenate summary.txt files
cat */summary.txt > fastqc_summary.txt

# Look at parameters that failed only
cat fastqc_summary.txt | grep "FAIL" > summary_failed_parameters.txt