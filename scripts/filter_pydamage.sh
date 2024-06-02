#!/bin/bash

#SBATCH -p #server
#SBATCH -A  #user
#SBATCH -J filter_pydamage

#SBATCH -n 4
#SBATCH --nodes=1
#SBATCH --time=01:00:00

#SBATCH -o logs/filter_pydamage-%j.stdout
#SBATCH -e logs/filter_pydamage-%j.err

#SBATCH --mail-type=ALL
#SBATCH --mail-user= #mail

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

source activate pydamage

ID=$1

pydamage filter -t 0 results/mapping/${ID}/pydamage/pydamage_results.csv
