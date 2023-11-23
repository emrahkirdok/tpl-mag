# tpl-mag

## Analyzing Ancient DNA through DNA Concatenation Methods

This study aims to analyze ancient DNA samples using DNA assembly methods without the use of a reference genome. The objective of this research is to enhance the accuracy of ancient DNA analyses, enabling the retrieval of precise results from genetic material of the past. Furthermore, through a comprehensive comparison with reference-based methods using the same samples, we intend to evaluate the outcomes of these two distinct approaches. These comparisons will contribute to a deeper understanding of the reliability and sensitivity of ancient DNA analyses, thereby advancing our capacity to access genetic information from ancient eras.

## Preliminary analysis of TPL samples

### Introduction

Our research in ancient metagenomic analysis employs de novo assembly and rigorous statistical examination to uncover the genetic composition of microbial communities within environmental samples. We synthesize contigs, elongated DNA sequences, by amalgamating short, ancient DNA fragments, utilizing the MEGAHIT tool designed for our TPL metagenomic data, which includes both ancient and short reads. Post-initial assembly, we conduct a comprehensive evaluation of contig sequence quality through metagenomic statistical analyses, aligning sequences to FASTA files using tools like Bowtie2 and SAMtools. Then, the readings that do not meet their sufficient length, sufficient reading depth, sufficient reading coverage percentage are filtered and discarded.This stringent filtering ensures precision in contig sequences and accuracy in identifying genetic variations.

In essence, our method orchestrates a systematic exploration into the complexities of ancient metagenomic data. By strategically combining de novo assembly techniques for contig synthesis and utilizing bioinformatics tools such as MEGAHIT, Bowtie2, and SAMtools for metagenomic statistical analyses, our research aims to ensure the reliability and accuracy of the genetic information obtained, providing a comprehensive understanding of microbial ecosystems and genetic landscapes.


## Working Server: Truba

This study is conducted utilizing the technological infrastructure of TRUBA (Turkish National Academic Network and Information Center High-Performance Computing Center), which belongs to TÜBITAK ULAKBIM. TRUBA is a national e-Infrastructure providing services such as high-performance computing, data-intensive computing, scientific data repositories, and cloud computing. We express our gratitude to TRUBA for enabling the data analyses and computations conducted within the scope of this study.

## Materials and Methods

### Sampling

In the scope of this research, dentin, cement, and skeletal samples from three individuals obtained from Poland and Sweden were utilized (Table 1). These samples were processed by Dr. Maja Krzewinska at Stockholm University's Paleogenetics Center and subsequently sent for DNA sequencing. Within the context of our study, we employed the DNA libraries derived from these samples.

Table 1: Samples to be used in the study. Adequate DNA could not be obtained from the Tpl194 sample. Stradomska is an archaeological site located in Krakow, Poland.
|Individual| sample |    Location       | Skeletal specimen  |The amount of skeletal powder used|
|----------|--------|-------------------|--------------------|----------------------------------|
|     1    |TPL002  |	Sweden          |	  Dental cement  |             79 mg                |
|     1    |TPL003  |	Sweden          |	  Dentin  	     |             100 mg               |
|     1    |TPL004  |	Sweden          |	  Skull (lesion) |             152 mg               |
|     2    |TPL192  |	Poland 19       |	  Dental cement  |             75 mg                |
|     2    |TPL193  |	Poland 190      |	  Dentin         |             74 mg                |
|     2    |TPL194  |   Poland 190      |     Skull (lesion) |             80 mg                |
|     3    |TPL522  |	Poland 52       |	  Dental cement  |             87 mg                |
|     3    |TPL523  |	Poland 52       |	  Dentin       	 |             85 mg                |
|     3    |TPL524  |	Poland 52       |	  Skull (lesion) |             139 mg               |
|     3    |TPL525  |	Poland 52       |	  Long bone 	 |             84 mg                |
Stradomska is a site name (in Cracow, Poland).

### De novo assembly of fastq files
Given that our TPL metagenomic data consists of ancient and short reads, anticipating a high degree of similarity between DNA fragments from each organism, we conducted the de novo metagenome assembly using the MEGAHIT tool. MEGAHIT is a next-generation sequencing metagenome assembler that facilitates the de novo assembly of large and complex metagenomic datasets (Dinghua et al., 2015).

| sample | min contiglength | max contig length | 
|--------|------------------|-------------------|
|TPL002  |	200.0           |	  504617.0  	|
|TPL003  |	200.0           |	  649656.0  	|
|TPL004  |	200.0           |	  471362.0  	|
|TPL192  |	200.0           |	  211827.0	    |
|TPL193  |	208.0           |	  68680.0   	|
|TPL522  |	206             |	  172439    	|
|TPL523  |	204.0           |	  285722.0  	|
|TPL524  |	200.0           |	  340666.0	    |
|TPL525  |	201.0           |	  114932.0 	    |

```
mkdir results
cd results/
mkdir assembly
mkdir classification
```