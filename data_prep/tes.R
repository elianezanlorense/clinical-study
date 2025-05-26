library(dplyr)
library(table1)
library(flextable)
library(officer)

# Load data
if(!file.exists("../data/adsl.rda")) {
  stop("ADSL file not found at specified path!")
}
load("../data/adsl.rda")

# Prepare data
df_adsl <- adsl %>%
  mutate(
    SEX = factor(sex, 
                levels = c("M", "F"),
                labels = c("Male", "Female")),
    TRT01P = factor(trt01p)
  )%>%filter((trt01p!='Xanomeline Low Dose')& (ittfl=='Y'))

#Population data
keep_columns<-c('usubjid','trt01p')
df_pub <- df_adsl %>% 
            select(all_of(keep_columns))

save(df_pub, file = "../data/pub_adsl.RData")

tbl <- table1(~ SEX + age | TRT01P, 
             data = df_adsl)




# 4. Create a clean data frame
tbl_df <- data.frame(tbl, stringsAsFactors = FALSE)

# 5. Create and format flextable
ft <- flextable(tbl_df) %>%
  autofit()

# 6. Save with verification
output_path <- "baseline_characteristics.docx"
save_as_docx(ft, path = output_path)
