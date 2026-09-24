#####################################################################
#####################################################################
#####################################################################
###
### Plot figure 4: Pollination success data for the four 
### phytometer species. 
###
### Code by: Merin Reji Chacko
### Last edited: 15.07.2025
### 
#####################################################################
#####################################################################
#####################################################################

rm(list = ls())

# Load libraries
library(dplyr)
library(ggplot2)
library(ggridges)
library(readr)

# Load pollination datasets
carrot <- read.csv("../data_paper/data_for_publication/07_pollination_success/daucus_carota_seed_set.csv")
radish1 <- read.csv("../data_paper/data_for_publication/07_pollination_success/raphanus_sativus_seed_set.csv")
radish2 <- read.csv("../data_paper/data_for_publication/07_pollination_success/raphanus_sativus_fruit_set.csv")
sainfoin <- read.csv("../data_paper/data_for_publication/07_pollination_success/onobrychis_viciifolia_fruit_set.csv")
comfrey1 <- read.csv("../data_paper/data_for_publication/07_pollination_success/symphytum_officinale_seed_set.csv")
comfrey2 <- read.csv("../data_paper/data_for_publication/07_pollination_success/symphytum_officinale_fruit_set.csv")

# Prepare seed set data
dc_seed <- carrot %>%
  select(Id, n_seeds) %>%
  mutate(
    species = "Daucus carota",
    metric = "seed_set",
    value = n_seeds
  )

rs_seed <- radish1 %>%
  select(Id, n_seeds) %>%
  mutate(
    species = "Raphanus sativus",
    metric = "seed_set",
    value = n_seeds
  )

so_seed <- comfrey1 %>%
  select(Id, n_seeds) %>%
  mutate(
    species = "Symphytum officinale",
    metric = "seed_set",
    value = n_seeds
  )

# Prepare fruit set data
rs_fruit <- radish2 %>%
  mutate(fruit_set = n_flowers_with_fruits / (n_flowers_with_fruits + n_flowers_without_fruits)) %>%
  select(Id, fruit_set) %>%
  mutate(
    species = "Raphanus sativus",
    metric = "fruit_set",
    value = fruit_set
  )

ov_fruit <- sainfoin %>%
  mutate(fruit_set = n_flowers_with_fruits / (n_flowers_with_fruits + n_flowers_without_fruits)) %>%
  select(Id, fruit_set) %>%
  mutate(
    species = "Onobrychis viciifolia",
    metric = "fruit_set",
    value = fruit_set
  )

so_fruit <- comfrey2 %>%
  mutate(fruit_set = n_flowers_with_seeds / (n_flowers_with_seeds + n_flowers_without_seeds)) %>%
  select(Id, fruit_set) %>%
  mutate(
    species = "Symphytum officinale",
    metric = "fruit_set",
    value = fruit_set
  )

# Combine all data
pollination_df <- bind_rows(
  dc_seed, rs_seed, so_seed,
  rs_fruit, ov_fruit, so_fruit
)

# plotting function
plot_pollination_hist <- function(data, species_name, metric_name, color, letter_label = NULL, binwidth = NULL) {
  df <- data %>%
    filter(species == species_name, metric == metric_name)
  
  # Default binwidth for fruit set
  if (metric_name == "fruit_set" && is.null(binwidth)) {
    binwidth <- 0.05
  }
  
  if (metric_name == "seed_set") {
    if (species_name == "Daucus carota") {
      # Pre-bin into 10-seed groups
      df <- df %>%
        mutate(binned = cut(value, breaks = seq(0, max(value) + 50, by = 50), include.lowest = TRUE)) %>%
        count(binned)
      
      p <- ggplot(df, aes(x = binned, y = n)) +
        geom_col(fill = color, color = "black", linewidth = 0.3) +
        labs(x = "Seed set", y = "Frequency") 
    } else {
      # Other seed sets: treat as factor
      p <- ggplot(df, aes(x = factor(value))) +
        geom_bar(fill = color, color = "black", linewidth = 0.3) +
        labs(x = "Seed set", y = "Frequency")
    }
  } else {
    # Fruit set: histogram
    p <- ggplot(df, aes(x = value)) +
      geom_histogram(
        fill = "white",
        color = color,
        binwidth = binwidth,
        boundary = 0,
        linewidth = 0.9
      ) +
      scale_x_continuous(breaks = seq(0, 1, by = 0.25), limits = c(0, 1)) +
      labs(x = "Fruit set", y = "Frequency")
  }
  
  # Add title and theme
  p <- p +
    labs(title = paste0("(", letter_label, ") ", species_name)) +
    theme_classic(base_size = 13) +
    theme(
      plot.title = element_text(face = "italic"),
      axis.text.y = element_text(angle = 90, hjust = 0.5, vjust = 0.5),
      axis.text = element_text(color = "black", size = 12),
      axis.title = element_text(color = "black", size = 13)
    )
  
  theme(plot.title = element_text(face = "italic"))
  
  return(p)
}


a <- plot_pollination_hist(pollination_df, "Daucus carota", "seed_set", "#FCAA67", "a")
b <- plot_pollination_hist(pollination_df, "Onobrychis viciifolia", "fruit_set", "#E08DAC", "b")
c <- plot_pollination_hist(pollination_df, "Raphanus sativus", "seed_set", "#D33665", "c")
d <- plot_pollination_hist(pollination_df, "Raphanus sativus", "fruit_set", "#D33665", "d")
e <- plot_pollination_hist(pollination_df, "Symphytum officinale", "seed_set", "#8D80AD", "e")
f <- plot_pollination_hist(pollination_df, "Symphytum officinale", "fruit_set", "#8D80AD", "f")

# Combine with patchwork
(a + b) / (c + d) / (e + f)
