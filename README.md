This is the analysis to check the diversity of the SPLINTR barcode libraries. Analysis will tell us:
How many barcodes are present
What the frequency distribution
whether PCR technical replicates are good
will give us a fasta file to use as a reference for barcoding experiments using this library

Following original paper's github: https://github.com/DaneVass/SPLINTR_preprocessing/tree/main


NOTE: in all scripts check file/lists inputs/outputs, these may need to be changed or created, and also change number of parallel tasks according to number of samples being processed


# Get and inspect data

Download data

    wget data_files_link_from novogene

Unzip file

    tar -xvf X204SC23124766-Z01-F001.tar

Check integrity of files

    md5sum -c MD5.txt

Inspect fq files

    zcat path/to/file.fq.gz | head -n 20

Check how many reads

    zcat path/to/file.fq.gz | wc -l

and divide by 4 (each read has 4 lines: sequencing info; sequence of read; + sign; quality of each base). See if this corresponds to the amount of reads in the sequencing report.

Make text file with path of fq files, and one with names for filtered_fq files

    find -type f | grep -Ei "*fq.gz" | cut -c 3- > assets/lists/raw_data_path.txt

# FastQC

Run fastqc as usual

    qsub a1_fastqc.sh

    qsub a2_summary_fastqc.sh

Samples might not pass some QC:

Failed Adapter content: "Many sequencing platforms require the addition of specific adapter sequences to the end of the fragments to be sequenced. For an individual fragment, if the length of the sequencing read is longer than the fragment to be sequenced then the read will continue into the adapter sequence on the end. Unless it is removed this adapter sequence will cause problems for downstream mapping, assembly or other analysis."

Failed duplicate sequences: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/8%20Duplicate%20Sequences.html

Failed per base sequence content: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/8%20Duplicate%20Sequences.html

# Merge pair-end reads

Since the sequencing was pair-end, then we can merge R1 + R2 to get a more accurate output of sequencing. I used the NGmerge tool: https://github.com/harvardinformatics/NGmerge ; then I ran fastqc again to check quality wasn't lost and number of sequences is similar to unpaired reads.

    qsub a3_ngmerge.sh
    qsub a4_fastqc_postmerge.sh


# Filter and extract barcodes

This is to filter reads: 

"From a fastq input, filter out reads that meet the following criteria:
- Exact match to the specified 5' and 3' constant regions
- [OPTIONAL] A correct sample index
- Average phred quality >= 30 across barcode length. Can be changed with --minqual
- No ambiguous N residues
- Barcode length at least 30. Can be changed with --minlength option"

And trim reads keeping only barcode sequence (60bp)

This will be run using a python script (extractBarcodeReads.py) written by authors of original paper

To use packages in python need to create a virtual environment and install required these (only need to do once), and then to run python script need to activate this environment:

        # virtualenv is installed as part of the python module
        $ module load python
        # Set up an environment called <splintr>
        $ virtualenv splintr
        # Activate the environment
        $ source splintr/bin/activate
        # Use Python / pip etc. in the environment to install packages
        (splintr)$ pip install biopython

Run bash script that with python script inside

    qsub a5_filter_barcodes.sh

Check output (summary text file in results) to see how many reads passed filtering and inspect new fq files with barcode sequences only

# Run Starcode

To cluster barcodes according to Edit distance. More info: https://github.com/gui11aume/starcode

I had to install starcode on the cluster. # TO-D0 get starcode running as a module file

    qsub a6_starcode.sh

# Run further analysis on R

This analysis will do some further filtering, calculate barcode frequencies, check overlap of PCR replicates A/B and generate a fasta file to use as a plasmid reference library (to be used as a reference for experiments); Change inputed files as appropriate.
