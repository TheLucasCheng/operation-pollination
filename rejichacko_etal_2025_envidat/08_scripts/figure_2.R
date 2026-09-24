#####################################################################
#####################################################################
#####################################################################
###
### Plot figure 2: Hourly flower visitation patterns of two example
### pollinator species across four phytometer plant species
###
### Code by:  Merin Reji Chacko
### Last edited: 15.07.2025
### 
#####################################################################
#####################################################################
#####################################################################

rm(list=ls())

library(ggplot2)
library(ggpubr)#for the density function & ggarrange
library(ggforce)
library(dplyr)

#Load the pollinator data: 
df1 <-read.csv("../data_paper/data_for_publication/06_trait_data/individual_traits.csv", header = TRUE, sep = ",")
taxa <- read.csv("../data_paper/data_for_publication/04_taxonomic_data/taxa_checklist.csv")

df1 <- subset(df1, capture_window != 10)

# Basic columns
hour_labels <- c(
  "09:00–10:00", "10:00–11:00", "11:00–12:00",
  "12:00–13:00", "13:00–14:00", "14:00–15:00",
  "15:00–16:00", "16:00–17:00", "17:00–18:00",
  "18:00–19:00"
)

# Combine data for two species
df_combined <- df1 %>%
  filter(taxon %in% c("Bombus pascuorum", "Episyrphus balteatus")) %>%
  mutate(
    hour = factor(
      capture_window,
      levels = 10:1,
      labels = rev(hour_labels)
    ),
    capture_date = as.Date(capture_date, format = "%d.%m.%Y"),
    taxon = factor(taxon, levels = c("Bombus pascuorum", "Episyrphus balteatus")),  # control order
    phytometer_plant = factor(phytometer_plant, levels = c("Carrot", "Radish", "Sainfoin", "Comfrey"))  # enforce facet order
  ) %>%
  group_by(taxon, phytometer_plant, capture_date, hour) %>%
  summarise(Abundance = n(), .groups = "drop") %>%
  arrange(capture_date) %>%
  mutate(sampling_day = dense_rank(capture_date))%>%
  mutate(phytometer_plant = recode(
    phytometer_plant,
    "Carrot" = "Daucus\u00A0carota",
    "Radish" = "Raphanus\u00A0sativus",
    "Sainfoin" = "Onobrychis\u00A0viciifolia",
    "Comfrey" = "Symphytum\u00A0officinale"
  ))

custom_palette <- c(
  "#264653", 
  "#287271", 
  "#2a9d8f", 
  "#8ab17d", 
  "#e9c46a",
  "#efb366", 
  "#f4a261", 
  "#ee8959", 
  "#e76f51"  
)

ggplot(df_combined, aes(x = sampling_day, y = hour, fill = Abundance)) +
  geom_tile(color = "white") +
  facet_grid(phytometer_plant~taxon) +  
  scale_fill_gradientn(
    colors = custom_palette,
    name = "Flower visitation frequency"
  )+
  labs(x = "Sampling day", y = "Hour of day", fill = "Abundance") +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    panel.grid = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
    strip.text = element_text(size = 12, face = "italic")
  )
