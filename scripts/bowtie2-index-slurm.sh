#!/bin/bash

#SBATCH -p barbun
qSBATCH -A fozer
#SBATCH -J bowtie2-index

#SBATCH -n 20
#SBATCH --nodes=1
#SBATCH --time=48:00:00

#SBATCH -o logs/bowtie2-index-%j.stdout
#SBATCH -e logs/bowtie2-index-%j.err

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=f.kursatozer@gmail.com

conda activate mapping

ID=$1

bowtie2-build --large-index results/assembly/${ID}/contigs.fa results/assembly/${ID}/contigs.fa
