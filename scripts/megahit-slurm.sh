#!/bin/bash

#SBATCH -p #server
#SBATCH -A #user
#SBATCH -J megahit-try-1

#SBATCH -n 20
#SBATCH --nodes=1
#SBATCH --time=48:00:00

#SBATCH --output=megahit-%j.stdout
#SBATCH --error=megahit-%j.err

#SBATCH --mail-type=FAIL
#SBATCH --mail-user= mail
eval "$(/truba/home/$USER/miniconda3/bin/conda shell.bash hook)"

# conda activate megahit

FASTQ=$1
BASE=$(basename ${FASTQ} .fastq.gz)

# megahit -r ${FASTQ} --k-list 21 -o megahit-${BASE}
megahit -r ${FASTQ} --k-list 21,29,39,59,79,99,119 -o megahit-${BASE}

sstat -j $SLURM_JOB_ID

