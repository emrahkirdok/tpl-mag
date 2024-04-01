library(dplyr)
library(tidyr)
library(readr)

# Specify file paths
file_path <- "C:/Users/kursa/OneDrive/Desktop/table/data/"

# Sample names
sample_names <- c("tpl002", "tpl003", "tpl004", "tpl192", "tpl193", "tpl522", "tpl523", "tpl524", "tpl525")

# Create an empty dataframe
result_table <- data.frame()

# Combine all references collectively
all_ref_ids <- unique(unlist(sapply(sample_names, function(sample) {
  data <- read_csv(file.path(file_path, sample, "pydamage_filtered_results.csv"))
  data$reference
})))

# Create a loop for each sample
for (sample in sample_names) {
  # Specify file name
  file_name <- file.path(file_path, sample, "pydamage_filtered_results.csv")
  
  # Read the file
  data <- read_csv(file_name)
  
  # Calculate the antiquity value (taken from the predicted_accuracy column)
  data$Antiquity <- data$predicted_accuracy >= 0.95
  
  # Read the Contig coverage file
  contig_file <- file.path(file_path, sample, "contig_coverage.txt")
  contig_data <- read_table(contig_file, col_names = FALSE)
  
  # Get data from appropriate columns
  matching_indices <- match(data$reference, contig_data$X1)
  Length <- contig_data$X3[na.omit(matching_indices)]
  Breadth_of_Coverage <- contig_data$X6[na.omit(matching_indices)]
  Depth_of_Coverage <- contig_data$X7[na.omit(matching_indices)]
  
  # Add to the dataframe
  data <- cbind(data, Length, Breadth_of_Coverage, Depth_of_Coverage)
  
  # Read the Sample sequences file
  sample_file <- file.path(file_path, sample, "sample.sequences")
  sample_data <- read_table(sample_file, col_names = FALSE)
  
  # Filter the reference IDs
  matching_sample <- sample_data[sample_data$X2 %in% all_ref_ids, ]
  
  # Get Taxid and Classification information
  taxid <- matching_sample$X3[match(data$reference, matching_sample$X2)]
  classification <- matching_sample$X1[match(data$reference, matching_sample$X2)]
  
  # Add to the dataframe
  data <- cbind(data, Taxid = taxid, Classification = classification)
  
  # Reorder columns
  data <- data %>% select(reference, Antiquity, predicted_accuracy, Length, Breadth_of_Coverage, Depth_of_Coverage, Classification, Taxid, starts_with("CtoT"))
  
  # Add taxName column from sample.report file
  report_file <- file.path(file_path, sample, "sample.report")
  report_data <- read_table(report_file, skip = 2, col_names = TRUE)
  
  # Get taxName corresponding to taxID
  taxName <- report_data$taxName[match(taxid, report_data$taxID)]
  
  # Add taxName column to the dataframe
  data$taxName <- taxName
  
  # Add to the result table
  result_table <- bind_rows(result_table, data)
}

# Print the result table
print(result_table)

# Write the result table to a file
result_file_path <- "C:/Users/kursa/OneDrive/Desktop/sonuc/tpl_table.txt"
write.table(result_table, file = result_file_path, sep = "\t", col.names = TRUE, row.names = FALSE, quote = TRUE)
