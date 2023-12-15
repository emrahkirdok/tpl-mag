
# you'll need to speicify the contig coverage file that was produced from the bamcov software

results <- read.table(file = "data/contig_coverage.txt", head=F)

library(dplyr)

calculate_remaining_contigs <- function(data=results, length, coverage_threshold) {
  filtered_data <- data %>%
    filter(V3 >= length, V6 >= coverage_threshold)
  return(nrow(filtered_data))
}

lengths <- seq(200, 1000, by = 100)
coverages <- seq(95, 100, by = 1)

remaining_contigs <- NULL

for (i in lengths){
  for (j in coverages){
    remain <- calculate_remaining_contigs(data = results, length = i, coverage_threshold = j)
    remaining_contigs <- rbind(remaining_contigs, c(i,j,remain))
  }
}

remaining_contigs<-data.frame(remaining_contigs)
colnames(remaining_contigs) <- c("Length", "Coverage", "Remaining Contigs")

library(ggplot2)

heat_map <- ggplot(remaining_contigs, aes(x = Length, y = Coverage, fill = `Remaining Contigs`)) +
  geom_tile() +
  scale_fill_gradient(low = "blue", high = "red", labels = scales::comma_format(scale = 1/1000)) +
  labs(
    title = "tpl525 Remaining Contigs Heatmap",
    x = "Length",
    y = "Breadth of Coverage",
    fill = "Remainig Contigs (thousand)" 
  )

print(heat_map)
