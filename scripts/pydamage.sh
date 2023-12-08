#!/bin/bash

#SBATCH -p #server
#SBATCH -A  #user
#SBATCH -J pydamage-try-1

#SBATCH -n 20
#SBATCH --nodes=1
#SBATCH --time=96:00:00

#SBATCH -o logs/pydamge-%j.stdout
#SBATCH -e logs/pydamge-%j.err


#SBATCH --mail-type=ALL
#SBATCH --mail-user= #mail

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

source activate pydamage

ID=$1

pydamage --outdir results/mapping/${ID}/pydamage analyze results/mapping/${ID}/mapped.sorted.bam