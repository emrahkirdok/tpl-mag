#!/bin/bash

#SBATCH -p #server
#SBATCH -A #user
#SBATCH -J mapped

#SBATCH -n 20
#SBATCH --nodes=1
#SBATCH --time=48:00:00

#SBATCH -o logs/mapped-%j.stdout
#SBATCH -e logs/mapped-%j.err


#SBATCH --mail-type=ALL
#SBATCH --mail-user=#mail

source activate mapping

ID=$1

mkdir -p results/mapping/${ID}

FILES=$(find data -name "${ID}*" | xargs | sed 's/ /,/g')

bowtie2 --large-index --very-sensitive -x results/assembly/${ID}/contigs.fa -U ${FILES} -S results/mapping/${ID}/mapped.sam --threads 20

samtools view -bh -F4 results/mapping/${ID}/mapped.sam | samtools sort - -o results/mapping/${ID}/mapped.sorted.bam

samtools index results/mapping/${ID}/mapped.sorted.bam

