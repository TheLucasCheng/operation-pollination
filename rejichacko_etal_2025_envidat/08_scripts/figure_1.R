#####################################################################
#####################################################################
#####################################################################
###
### Plot figure 1: The abundance and richness of pollinator groups 
### per phytometer species. 
### Code by:  Merin Reji Chacko
### Last edited: 15.07.2025
### 
#####################################################################
#####################################################################
#####################################################################

rm(list=ls())

# Load libraries
library(dplyr)
library(ggplot2)
library(readr)

# Read the files
traits <- read_csv("../data_paper/data_for_publication/06_trait_data/individual_traits.csv")
taxa <- read_csv("../data_paper/data_for_publication/04_taxonomic_data/taxa_checklist.csv")

# Merge both files on species/taxon
data <- traits %>%
  left_join(taxa, by = "taxon")  

# Set desired order -> by increasing floral specificity
data <- data %>%
  mutate(phytometer_plant = factor(phytometer_plant, levels = c("Carrot", "Radish", "Sainfoin", "Comfrey")))

data <- data %>%
  mutate(pollinator_group = factor(pollinator_group, 
                                   levels = c("Anthophila", "Hoverflies", "Beetles", "Wasps")))

# Abundance per garden, pollinator group, and phytometer plant
abundance <- data %>%
  group_by(Id, phytometer_plant, pollinator_group) %>%
  summarise(n_individuals = n(), .groups = "drop")

# Richness per garden, pollinator group, and phytometer plant
richness <- data %>%
  group_by(Id, phytometer_plant, pollinator_group) %>%
  summarise(n_species = n_distinct(taxon), .groups = "drop")

# Define color palette
pollinator_colors <- c(
  "Anthophila" = "#e59500", 
  "Hoverflies" = "#197278", 
  "Beetles" = "#002642", 
  "Wasps" = "#840032"
)

# Abundance plot
a <- ggplot(abundance, aes(x = pollinator_group, y = n_individuals, fill = pollinator_group, color = pollinator_group)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.4) +  # semi-transparent boxes
  geom_jitter(width = 0.2, size = 2, alpha = 0.7) + # points colored by pollinator group
  facet_wrap(~ phytometer_plant, ncol = 1, scales = "free_y") +
  scale_fill_manual(values = pollinator_colors) +
  scale_color_manual(values = pollinator_colors)+
  theme_bw(base_size = 14) +
  theme(
    strip.text = element_text(face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none"
  )+
  labs(x = "Pollinator group", y = "Total abundance")

a
# Richness plot
b <- ggplot(richness, aes(x = pollinator_group, y = n_species, fill = pollinator_group, color = pollinator_group)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.4) +
  geom_jitter(width = 0.2, size = 2, alpha = 0.7) +
  facet_wrap(~ phytometer_plant, ncol = 1, scales = "free_y") +
  scale_fill_manual(values = pollinator_colors) +
  scale_color_manual(values = pollinator_colors)+
  theme_bw(base_size = 14) +
  theme(
    strip.text = element_text(face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none"
  )+
  labs(x = "Pollinator Group", y = "Total richness")

library(patchwork)

a + b 
