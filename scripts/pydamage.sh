#!/bin/bash

#SBATCH -p #server
#SBATCH -A #user
#SBATCH -J filtred

#SBATCH -n 20
#SBATCH --nodes=1
#SBATCH --time=48:00:00

#SBATCH -o logs/mapped-%j.stdout
#SBATCH -e logs/mapped-%j.err


#SBATCH --mail-type=ALL
#SBATCH --mail-user=#mail

source activate mapping

ID=$1

pydamage analyze -w 500 -o results/mapping/${ID}/ --outdir filtred.bam results/mapping/${ID}/mapped.sorted.bam
