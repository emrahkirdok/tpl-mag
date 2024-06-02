# tpl-mag

## Preliminary analysis of TPL samples

## Working Server: Truba

This study is conducted utilizing the technological infrastructure of TRUBA (Turkish National Academic Network and Information Center High-Performance Computing Center), which belongs to TÜBITAK ULAKBIM. TRUBA is a national e-Infrastructure providing services such as high-performance computing, data-intensive computing, scientific data repositories, and cloud computing. We express our gratitude to TRUBA for enabling the data analyses and computations conducted within the scope of this study.
Important note!: Please add your own server name, username, email to the required sections while your users are running the scripts. Depending on the size of your data and taking into account the number of cores provided to you by your presentation, it is necessary to optimize the number of cores you request and the processing time according to yourself.

## Materials and Methods

#### Samples and fastq files

With this command, you can view how many reads there are in each fastq file.

```bash
for file in sample*.fastq.gz
do
    zcat "$file" | wc -l | awk -v var="$file" '{print var " " $1/4}'
done
```

### Pipeline Implementation

#### Installing Anaconda in the Home Directory

Download miniconda:

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

You can delete the script after it is finished:

```bash
rm Miniconda3-latest-Linux-x86_64.sh
```

Update Conda.

```bash
eval "$(/truba/home/$USER/miniconda3/bin/conda shell.bash hook)"
conda update conda
```

After this step, you can install the library you will use in the conda virtual environment:

```bash
conda env create -f mapping.yml
conda env create -f stats.yml
conda env create -f pydamage.yml
conda env create -f kraken.yml
```

#### An overview of the tool and file hierarchy

Figure 1: The order of use of the tools and data is visualized in the pipeline shown in the figure.

![pipeline](image.png)

Create the `results` directory and its subreddits to which the results will be transferred.

```bash
mkdir data
mkdir logs
mkdir -p results/assembly 
mkdir -p results/classification
```
#### Megahit for Metagenomic Assembly

This command analyzes metagenomic data using the Megahit tool and performs assembly using different k-mer lengths. And this command should be applied to all sample fastq files.

```bash
ID=your_sample
sbatch megahit-slurm.sh data/${ID}.fastq.gz
```

After this process, a`final.contigs.fa` file should be generated within each sample directory located at `results/assembly/${ID}`.

#### Preparing `contigs.fa` for analysis

The general purpose of this process is to read the header lines in the specified contig file, modify the information within the headers, and create a new contig file. This way, we prepare the dataset for subsequent analysis

```bash
ID=your_sample
sbatch scripts/rename-contigs.sh ${ID}
```

After this process, a `contigs.fa` file should be created for each sample in each sample directory located at `results/assembly/${ID}`.

#### Quality control statistics analysis

This command uses the `bowtie2-build` tool to create a large index for a specific metagenomic assembly file (`contigs.fa`) located in the specified directory. The generated index allows Bowtie2 to perform alignments on this assembly file more efficiently and quickly.

```bash
ID=your_sample
sbatch scripts/bowtie2-index-slurm.sh ${ID}
```

The overall purpose of this command is to align unassembled metagenomic data to the assembled state and subsequently process the obtained alignment results.

```bash
ID=your_sample
sbatch scripts/mapped-slurm.sh ${ID}
```

As output, the `results/mapping/${ID}/` directory for each sample is obtained in the `mapped.sorted.bam` file.

#### Calculating coverage information for the BAM file

This command navigates to the `bamcov` folder, copies the `bamcov` program file to the `~/bin` directory, compiles the program using `make`, and runs its tests with `make test`. These steps aim to prepare the bamcov program for use.

```bash
conda activate mapping
git clone --recurse-submodules https://github.com/fbreitwieser/bamcov
cd bamcov
cp /truba/home/$USER/Programs/bamcov/bamcov /truba/home/fozer/bin/bamcov
make
make test
```

Now, we will create a folder for the programs we will install ourselves. Let's go to the home folder.

```bash
cd ~
mkdir bin
```

"Then, let's add the following line to the .bash_profile file:```PATH=${PATH}:/truba/home/$USER/bin```
This way, we can copy our own installed programs to the `~/bin folder.`

Now, you will be able to run it simply by typing "bamcov." (However, you may need to log out and log back in once; the .bash_profile file needs to run once for this.) This file runs every time you enter the bash shell.

Calculates coverage information for the BAM file and saves this information to a text file.

```bash
ID=your_sample
sbatch scripts/bamcov-slurm.sh ${ID}
```
,
Saves this information to a text file named `contig_coverage.txt` in the directory results/mapping/${ID}/ for each sample.

#### Genome coverage histogram plots

With this command, we obtained these histograms for each sample:

- Breadth of coverage histogram
- Mean read depth histogram
- Contig length histogram

```bash
ID=your_sample
sbatch scripts/genom_coverage.sh ${ID}
```

The graphic outputs will be saved to the `results/mapping/${ID}/` directories for each sample.

#### PyDamage Analysis

```bash
ID=your_sample
sbatch scripts/pydamage.sh ${ID}
```

#### Classification with KrakenUniq

```bash
ID=your_sample
sbatch scripts/krakenuniq.sh ${ID}
```
