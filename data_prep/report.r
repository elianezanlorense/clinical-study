library(dplyr)
library(tidyr)
library(flextable)
library(officer)

# Load both datasets
load("../data/processed/df_aebodsys.RData")
load("../data/processed/aeterm_list.RData")

# Build Word document
doc <- read_docx()

### --- PART 1: Add the summary df_aebodsys table ---
ft_summary <- flextable(df_wide) %>%
  width(j = "aebodsys", width = 5)

doc <- doc %>%
  body_add_par("Summary by Body System", style = "heading 1") %>%
  body_add_flextable(ft_summary) %>%
  body_add_par("")

### --- PART 2: Prepare and add each table from aeterm_list ---

# Clean and reshape each AE table
aeterm_list_clean <- lapply(aeterm_list, function(df) {
  df <- df[, !(names(df) %in% "aebodsys")]

  if ("trta" %in% names(df)) {
    df <- df %>%
      pivot_wider(names_from = trta, values_from = n, values_fill = 0)
    
    # Desired column order
    desired_order <- c("aeterm", "Xanomeline High Dose", "Placebo")
    existing_cols <- intersect(desired_order, names(df))
    other_cols <- setdiff(names(df), existing_cols)
    df <- df[, c(existing_cols, other_cols), drop = FALSE]
  }

  return(df)
})

# Add each table to the Word doc
for (name in names(aeterm_list_clean)) {
  ft <- flextable(aeterm_list_clean[[name]]) %>% width(width = 5)
  doc <- doc %>%
    body_add_par(name) %>%
    body_add_flextable(ft) %>%
    body_add_par("")
}

# Save final document
print(doc, target = "../Results/combined_safety_report.docx")
