rm(list=ls())

# make abundance matrix

df1 <-read.csv("../data_paper/data_for_publication/06_trait_data/individual_traits.csv", header = TRUE, sep = ",")
# Basic columns
hour_labels <- c(
  "09:00–10:00", "10:00–11:00", "11:00–12:00",
  "12:00–13:00", "13:00–14:00", "14:00–15:00",
  "15:00–16:00", "16:00–17:00", "17:00–18:00",
  "18:00–19:00"
)
df_expanded <- df1 %>%
  mutate(
    capture_date = capture_date,
    hour_label = factor(capture_window, levels = 1:10, labels = hour_labels)
  ) %>%
  count(Id, taxon, phytometer_plant, capture_date, capture_window, hour_label, name = "abundance") %>%
  complete(
    Id, 
    taxon,
    phytometer_plant,
    capture_date,
    capture_window = 1:10,
    fill = list(abundance = 0)
  ) %>%
  mutate(hour_label = factor(capture_window, levels = 1:10, labels = hour_labels)) %>%
  arrange(Id, taxon, phytometer_plant, capture_date, capture_window)


library(tidyr)

df_wide <- df_expanded %>%
  select(Id, phytometer_plant, capture_date, capture_window, taxon, abundance) %>%
  pivot_wider(
    names_from = taxon,
    values_from = abundance,
    values_fill = 0  # fill in zeroes where species were absent
  )

# After pivot_wider
names(df_wide) <- gsub(" ", "_", names(df_wide))

data.table::fwrite(df_wide, "../data_paper/data_for_publication/06_trait_data/abundance_matrix.csv")

# make table 2 for paper

library(dplyr)
taxa <- read.csv("../data_paper/data_for_publication/04_taxonomic_data/taxa_checklist.csv")

df1 <- merge(df1, taxa, by = "taxon")

table2 <- df1 %>%
  group_by(taxon) %>%
  summarise(
    n_observations = n(),
    n_gardens = n_distinct(Id),
    robber_interactions = sum(nectar_robber == 1, na.rm = TRUE)
  ) %>%
  left_join(
    taxa %>% select(taxon, family, pollinator_group), by = "taxon"
  ) %>%
  select(taxon, family, pollinator_group, n_observations, n_gardens, robber_interactions) %>%
  arrange(pollinator_group, family, taxon, desc(n_observations))

data.table::fwrite(table2, "../data_paper/for_submission/table2.csv")
