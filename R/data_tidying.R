library(tidyverse)
library(openxlsx)

 # install.packages("openxlsx")

# Open the desired file and load it into a data frame: "df") 

df <- read.xlsx("analysis_Test.xlsx", fillMergedCells = TRUE, colNames = FALSE )
  ## fillMergedCells -> fill the merged cell in the original file with the same 
  ## name
  ## colNames -> Prevents the creation of header for the first row of the df


# Create a object (vector) from the column names (first row) 

first_row <- df[1,] %>% unlist(use.names = FALSE)
  ## df[1,] -> selects the first row of the df
# Replace spaces with underscore

first_row <- str_replace_all(first_row, pattern = " ", replacement = ".")

# Create a object (vector) from the column names (second row) 

second_row <- df[2,] %>% unlist(use.names = FALSE)
  ## df[1,] -> selects the second row of the df
# Replace spaces with underscore

second_row <- str_replace_all(second_row, pattern = " ", replacement = ".")


# Delete the first rows of the df

df_no_header <- df[-c(1:2),]
  ## [(1:2,)] -> Selects the two first rows
  ## -c -> delete selected rows/columns

# Combine the two firsts rows in a single one.

combined_labels <- paste(first_row, second_row, sep = "_")

# Add the labels to the dataframe

colnames(df_no_header) <- combined_labels

# Tidy the data

df_tidy <- pivot_longer(df_no_header, cols = everything(), names_to = "combined_labels", values_to = "Intensity")

# Split the combined labels

df_tidy_final <- df_tidy %>% separate(combined_labels, c('Strand', 'Target'), sep = "_")

# Save as csv file

write.csv(df_tidy_final, "analysis_test_tidy.csv", row.names = FALSE)
