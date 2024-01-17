This is the analysis to check the diversity of the SPLINTR barcode libraries. 
I first analysed the sequenced BFP library. 

Following original paper's github: https://github.com/DaneVass/SPLINTR_preprocessing/tree/main

Important: the sequencing was PE150 so we have both R1 and R2 here. So we could either merge the reads (but not sure if possible because fragments are ~320bp - bigger than twice the size of the reads, which is 150bp (??)). So can run the analyis on the forward reads, but could also reverse complement and run on the reverse reads??

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

Samples didn't pass some QC:

Failed Adapter content: "Many sequencing platforms require the addition of specific adapter sequences to the end of the fragments to be sequenced. For an individual fragment, if the length of the sequencing read is longer than the fragment to be sequenced then the read will continue into the adapter sequence on the end. Unless it is removed this adapter sequence will cause problems for downstream mapping, assembly or other analysis."

Failed duplicate sequences: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/8%20Duplicate%20Sequences.html

Failed per base sequence content: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/8%20Duplicate%20Sequences.html

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

    qsub a3_filter_barcodes.sh

Check output (job_output) to see how many reads passed filtering and inspect new fq files with barcode sequences only

# Run Starcode

To cluster barcodes according to Edit distance. More info: https://github.com/gui11aume/starcode

I had to install starcode on the cluster. # TO-D0 get starcode running as a module file

    qsub a4_starcode.sh

# Run further analysis on R