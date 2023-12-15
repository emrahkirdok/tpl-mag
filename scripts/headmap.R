results <- read.table(file = "")

library(dplyr)


filtered_results <- results %>%
  filter(V3 >= 200 & V3 <= 1000)


calculate_remaining_contigs <- function(length, coverage_threshold) {
  filtered_data <- filtered_results %>%
    filter(V3 == length, V6 >= coverage_threshold)
  return(nrow(filtered_data))
}

lengths <- seq(200, 1000, by = 100)
coverages <- seq(95, 100, by = 1)

result_table <- expand.grid(Length = lengths, Coverage = coverages) %>%
  arrange(Length, Coverage) %>%
  mutate(Remaining_Contigs = mapply(calculate_remaining_contigs, Length, Coverage))

print(result_table)


library(ggplot2)

calculate_remaining_contigs <- function(length, coverage_threshold) {
  filtered_data <- results %>%
    filter(V3 >= length, V6 >= coverage_threshold)
  return(nrow(filtered_data))
}

lengths <- seq(300, 1000, by = 100)
coverages <- seq(95, 100, by = 1)

result_table <- expand.grid(Length = lengths, Coverage = coverages) %>%
  arrange(Length, Coverage) %>%
  mutate(Remaining_Contigs = mapply(calculate_remaining_contigs, Length, Coverage))


heat_map <- ggplot(result_table, aes(x = Length, y = Coverage, fill = Remaining_Contigs)) +
  geom_tile() +
  scale_fill_gradient(low = "blue", high = "red", labels = scales::comma_format(scale = 1/1000)) +
  labs(
    title = "tpl525 Remaining Contigs Heatmap",
    x = "Length",
    y = "Breadth of Coverage",
    fill = "Remainig Contigs (thousand)" 
  )

print(heat_map)
