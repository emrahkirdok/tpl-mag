#!/bin/bash

#SBATCH -p #server
#SBATCH -A #user
#SBATCH -J genome-coverage

#SBATCH -n 4
#SBATCH --nodes=1
#SBATCH --time=12:00:00

#SBATCH --output=logs/rename-contigs-%j.stdout
#SBATCH --error=logs/rename-contigs-%j.err

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=#mail


source activate stats

ID=$1

Rscript scripts/genom_coverage.R --input results/mapping/${ID}/contig_coverage.txt --ID=${ID}

mv contig_length_plot.png results/mapping/${ID}/
mv contig_breadth_plot.png results/mapping/${ID}/
mv contig_depth_plot.png results/mapping/${ID}/