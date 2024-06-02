#!/bin/bash

#SBATCH -p #server
#SBATCH -A  #user
#SBATCH -J krakenuniq

#SBATCH -n 40
#SBATCH --nodes=1
#SBATCH --time=48:00:00

#SBATCH -o logs/krakenuniq-%j.stdout
#SBATCH -e logs/krakenuniq-%j.err

#SBATCH --mail-type=ALL
#SBATCH --mail-user= #mail

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


source activate kraken

ID=$1

krakenuniq --db ../Krakenuniq --threads 40 --preload-size 300G --report results/classification/${ID}.report results/assembly/${ID}/contigs.fa results/classification/${ID}.sequences
