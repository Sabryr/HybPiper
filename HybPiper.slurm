#!/bin/bash

#SBATCH --account=<Project_code> 
#SBATCH --time=6:00:00
#SBATCH --job-name=Hypiper_Array
## Book 8 cores on the same node
#SBATCH --nodes=1 --ntasks=8

## Memory requirment established
## through sample runs
#SBATCH --mem-per-cpu=4G

## Clean up the environment as the
## users had
## permanently activate conda
conda deactivate &>/dev/null
conda deactivate &>/dev/null
unset PYTHONPATH
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

## Load the module
module --quiet purge
module load HybPiper/14


## The sample list is provided via a file name namelist.txt
## the sample to be used is picked from the list using the 
## array index as the line number
CURRENT_NAME=$(awk NR==$SLURM_ARRAY_TASK_ID namelist.txt)
CURRENT_FASTA=$CURRENT_NAME"_READ*.fastq"

## Print information needed for debuging
echo "(Task" $SLURM_ARRAY_TASK_ID") Current name="$CURRENT_NAME"  Fastaq file="$CURRENT_FASTA


echo "Fabricate command and run"
reads_first.py --cpu=${SLURM_NTASKS} -b mega353.fasta -r $CURRENT_FASTA --prefix $CURRENT_NAME --bwa


