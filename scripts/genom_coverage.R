library(ggplot2)

ID <- commandArgs(trailingOnly = TRUE)[1]

script_dir <- dirname(sys.frame(1)$ofile)

file_path <- file.path(script_dir, sprintf("results/mapping/%s/contig_coverage.txt", ID))

results <- read.table(file = file_path, header = TRUE)

p1 <- ggplot(data = results, aes(x=V3)) + 
  geom_histogram() + 
  geom_vline(xintercept = 500, col="red") + 
  scale_x_log10() + 
  labs(title = sprintf("Contig length histogram of the sample %s", ID),
       subtitle = "Line represents 500 nucleotides") + xlab("Length (Log10)") + ylab("Frequency")

p2 <- ggplot(data = results, aes(x=V6)) +
  geom_histogram() +
  geom_vline(xintercept = 90, col="red") + 
  scale_x_log10() + 
  labs(title = sprintf("Contig breadth of coverage histogram of the sample %s", ID), 
       subtitle = "Line represents 90 % boc") + 
  xlab("Length (Log10)") + ylab("Frequency")

p3 <- ggplot(data = results, aes(x=V7)) + 
  geom_histogram() + 
  geom_vline(xintercept = 1, col="red") + 
  scale_x_log10() + 
  labs(title = sprintf("Contig mean read depth histogram of the sample %s", ID),
       subtitle = "Line represents 1x mean read depth") + xlab("Length (Log10)") + ylab("Frequency")

ggsave(file.path(script_dir, sprintf("contig_length_plot_%s.png", ID)), plot = p1)
ggsave(file.path(script_dir, sprintf("contig_breadth_plot_%s.png", ID)), plot = p2)
ggsave(file.path(script_dir, sprintf("contig_depth_plot_%s.png", ID)), plot = p3)