library(dplyr)
library(tidyr)
library(flextable)
library(officer)

# Load your datasets
load("../data/processed/df_aebodsys.RData")
load("../data/processed/aeterm_list.RData")

# Start Word document
doc <- read_docx()

# Part 1: Add summary table
ft_summary <- flextable(df_wide) %>%
  width(j = "aebodsys", width = 5)

doc <- doc %>%
  body_add_par("Summary by Body System") %>%
  body_add_flextable(ft_summary) %>%
  body_add_par("")

# Part 2: Prepare and add AE tables
desired_order <- c("aeterm", "Xanomeline High Dose", "Placebo")

aeterm_list_clean <- lapply(aeterm_list, function(df) {
  # Drop 'aebodsys' if present
  df <- df[, !(names(df) %in% "aebodsys")]
  
  # Pivot wider by treatment
  if ("trta" %in% names(df)) {
    df <- df %>%
      pivot_wider(names_from = trta, values_from = n, values_fill = 0)
  }
  
  # Add missing treatment columns filled with zeros
  missing_cols <- setdiff(desired_order, names(df))
  for (col in missing_cols) {
    if (col != "aeterm") {
      df[[col]] <- 0
    }
  }
  
  # Reorder columns: aeterm, Xanomeline High Dose, Placebo (if present)
  existing_cols <- intersect(desired_order, names(df))
  other_cols <- setdiff(names(df), existing_cols)
  df <- df[, c(existing_cols, other_cols), drop = FALSE]
  
  return(df)
})

# Add each AE table to Word doc
for (name in names(aeterm_list_clean)) {
  ft <- flextable(aeterm_list_clean[[name]]) %>% width(width = 5)
  doc <- doc %>%
    body_add_par("Summary by Body System")
    body_add_par(name) %>%
    body_add_flextable(ft) %>%
    body_add_par("")  # blank line for spacing
}

# Save Word document
print(doc, target = "../Results/combined_safety_report.docx")
