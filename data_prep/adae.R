library(dplyr)
library(tidyr)
library(flextable)
library(officer)

# Load data
if(!file.exists("../data/adae.rda")) {
  stop("ADAE file not found at specified path!")
}
load("../data/adae.rda")
load("../data/pub_adsl.RData")

drop_columns <- c("studyid","siteid","age","agegr1","agegr1n","race","racen",'sex')
adae_f <- adae %>% 
            select(-all_of(drop_columns))%>%
            filter((trta!='Xanomeline Low Dose')
            & (saffl =='Y')
            & (astdt>=trtsdt)
             & (trtedt>=astdt)
           # &(aebodsys=='GASTROINTESTINAL DISORDERS')
keep_columns=c('usubjid','trtsdt','trtedt','astdt','astdy')           
adae_f2 <- adae_f  %>% 
            select(all_of(keep_columns))%>% mutate(new_column1 = astdt>=trtsdt,
            new_column12 = trtedt>=astdt)%>%
            filter(new_column12!=TRUE)
#print(unique(adae_f$aeterm))

#tab <- table(adae_f$aedecod, adae_f$aeterm)
#print(tab)


df_aebodsys <- adae_f %>%
  group_by(trta, aebodsys) %>%
  summarise(distinct_values = n_distinct(usubjid), .groups = "drop")


#ft <- flextable(df_aebodsys)

df_aebodsys <- df_aebodsys %>%
  pivot_wider(names_from = trta, values_from = distinct_values, values_fill = 0)

save(df_aebodsys, file = "../data/processed/df_aebodsys.RData")


aeterm_counts <- adae_f %>%
  group_by(aebodsys, aeterm,trta) %>%
  summarise(n = n(), .groups = "drop")

# Step 2: Create a named list by aebodsys
aeterm_list <- split(aeterm_counts, aeterm_counts$aebodsys)

save(df_aebodsys, file = "../data/processed/aeterm_list.RData")
