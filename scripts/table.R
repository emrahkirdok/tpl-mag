library(dplyr)
library(tidyr)

# Specify file paths
file_path <- "C:/Users/kursat/Desktop/table/data/"

# Sample names
sample_names <- c("tpl002", "tpl003", "tpl004", "tpl192", "tpl193", "tpl522", "tpl523", "tpl524", "tpl525")

# Create an empty dataframe
result_table <- data.frame()

# Combine all references collectively
all_ref_ids <- unique(unlist(sapply(sample_names, function(sample) {
  data <- read.csv(file.path(file_path, sample, "pydamage_filtered_results.csv"), stringsAsFactors = FALSE)
  data$reference
})))

# Create a loop for each sample
for (sample in sample_names) {
  # Specify file name
  file_name <- file.path(file_path, sample, "pydamage_filtered_results.csv")
  
  # Read the file
  data <- read.csv(file_name, stringsAsFactors = FALSE)
  
  # Calculate the antiquity value (taken from the predicted_accuracy column)
  data$Antiquity <- data$predicted_accuracy >= 0.95
  
  # Read the Contig coverage file
  contig_file <- file.path(file_path, sample, "contig_coverage.txt")
  contig_data <- read.table(contig_file, header = FALSE, stringsAsFactors = FALSE)
  
  # Get data from appropriate columns
  matching_indices <- match(data$reference, contig_data$V1)
  Length <- contig_data$V3[na.omit(matching_indices)]
  Breadth_of_Coverage <- contig_data$V6[na.omit(matching_indices)]
  Depth_of_Coverage <- contig_data$V7[na.omit(matching_indices)]
  
  # Add to the dataframe
  data <- cbind(data, Length, Breadth_of_Coverage, Depth_of_Coverage)
  
  # Read the Sample sequences file
  sample_file <- file.path(file_path, sample, "sample.sequences")
  sample_data <- read.table(sample_file, header = FALSE, stringsAsFactors = FALSE, sep = "\t")
  
  # Filter the reference IDs
  matching_sample <- sample_data[sample_data$V2 %in% all_ref_ids, ]
  
  # Get Taxid and Classification information
  taxid <- matching_sample$V3[match(data$reference, matching_sample$V2)]
  classification <- matching_sample$V1[match(data$reference, matching_sample$V2)]
  
  # Add to the dataframe
  data <- cbind(data, Taxid = taxid, Classification = classification)
  
  # Reorder columns
  data <- data %>% select(reference, Antiquity, predicted_accuracy, Length, Breadth_of_Coverage, Depth_of_Coverage, Classification, Taxid, starts_with("CtoT"))
  
  # Add to the result table
  result_table <- bind_rows(result_table, data)
}

# Print the result table
print(result_table)

# Write the result table to a file
result_file_path <- "C:/Users/kursat/Desktop/sonuc/tpl_table.txt"
write.table(result_table, file = result_file_path, sep = "\t", row.names = FALSE)
