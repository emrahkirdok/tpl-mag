#!/bin/bash

#SBATCH -p #server
#SBATCH -A #user
#SBATCH -J rename-contigs

#SBATCH -n 4
#SBATCH --nodes=1
#SBATCH --time=12:00:00

#SBATCH --output=logs/rename-contigs-%j.stdout
#SBATCH --error=logs/rename-contigs-%j.err

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=#mail

source activate stats

ID=$1

Rscript scripts/rename-contigs.R --input results/assembly/${ID}/final.contigs.fa --prefix ${ID} > results/assembly/${ID}/contigs.fa

