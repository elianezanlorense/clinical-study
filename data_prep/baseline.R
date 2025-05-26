library(dplyr)
library(table1)
library(flextable)
library(officer)
library(stringr) 

if(file.exists("../data/adsl.rda")) {
  load("../data/adsl.rda")
} else {
  warning("File not found!")
}

# Get unique values in ITTFL column
#print(unique(adsl$ittfl))
# Get unique values in ITTFL column
#print(unique(adsl$subjid))
#otal_rows <- nrow(adsl)
#print(paste("Total rows:", total_rows))


#print(colnames((adsl)))



df_adsl <- adsl %>%
  mutate(
    SEX = factor(sex),
    RACE = factor(race),
    TRT01P = factor(trt01p)
  )
vars <- c("SEX"#, "RACE", "age","ethnic#"
)
#formula_text <- paste0("~ ", paste(vars, collapse = " + "), " | TRT01P")
tbl <- table1(~ SEX | TRT01P, data = df_adsl)

ft <- tbl %>%
  # Convert to flextable (table1 has a built-in method)
  as_flextable() %>%
  # Formatting
  fontsize(size = 10, part = "all") %>%
  padding(padding = 3, part = "all") %>%
  align(align = "center", part = "header") %>%
  bold(part = "header") %>%
  set_caption("Table 1. Demographic and Baseline Characteristics") %>%
  autofit()

# Save to Word file
save_as_docx(ft, path = "baseline_caracteristics.docx")