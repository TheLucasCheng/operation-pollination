#####################################################################
#####################################################################
#####################################################################
###
### Plot figure 3: Visualisation of the distribution of selected trait
### values of pollinator individuals.
###
### Code by: David Frey and Merin Reji Chacko
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
df1 <- merge(df1, taxa[,c("taxon", "pollinator_group_sociality", "pollinator_group")])
names(df1)

head(df1)
dim(df1)

str(df1)

#Exclude lost samples and flies that are no hover flies and nectar robbers and get rid of empty factor levels
df2<- droplevels(subset(df1, Id != 39 & comment != "not a hoverfly" & comment != "sample lost" & nectar_robber != 1)) 
dim(df2)

head(df2)
names(df2)
summary(df2)
dim(df2)

##################################
# Prepare the summary statistics #
##################################

#Calculate the weighted tongue length
df2 <- within(df2, {
  garden.fac <- as.factor(Id);
  Prementum_length.wgt <- prementum_length/intertegular_distance;
  Labellum_lenght.wgt <- labellum_lenght/intertegular_distance;
  Proboscis_length.wgt <- proboscis_length/intertegular_distance;
  phytometer_plant <- factor(df2$phytometer_plant, levels = c("Carrot","Radish","Sainfoin","Comfrey"));
})

# Custom colors
custom_colors <- c(
  "Carrot" = "#FCAA67",
  "Radish" = "#D33665",
  "Sainfoin" = "#E08DAC",
  "Comfrey" = "#8D80AD",
  "solitary_Bees" = "#582f0e",
  "social_Bees" = "#a68a64",
  "Honeybees" = "#ffb703",
  "Hoverflies" = "#4DAF4A",  
  "Beetles" = "#984EA3",    
  "Wasps" = "#E41A1C"       
)


df2.Anthophila <- df2 %>% filter(pollinator_group=="Anthophila" & pollinator_group_sociality != "no")

dim(df2.Anthophila[!is.na(df2.Anthophila$intertegular_distance),]) #Number of measured individuals

p1 <- ggplot(df2.Anthophila[!is.na(df2.Anthophila$intertegular_distance),],
             aes(x = phytometer_plant, y = intertegular_distance, fill = phytometer_plant)) +
  
  # Density-based scatter (replaces violin + jitter)
  geom_sina(aes(color = phytometer_plant), alpha = 0.2, size = 4, maxwidth = 0.5, shape = 16) +
  
  # Classic boxplot (summarizes)
  geom_boxplot(width = 0.25, outlier.shape = NA, alpha = 0, color = "black") +
  
  # Custom colors
  scale_fill_manual(values = custom_colors) +
  scale_color_manual(values = custom_colors) +
  
  # Layout
  #scale_x_discrete(limits = c("Carrot", "Radish", "Sainfoin", "Comfrey")) +
  labs(y = "Body size (intertegular span) [mm]", x = "", title = "(a)") +
  theme_classic(base_size = 14) +
  scale_x_discrete(
    labels = c(
      "Carrot" = "<i>Daucus</i><br><i>carota</i>",
      "Radish" = "<i>Raphanus</i><br><i>sativus</i>",
      "Sainfoin" = "<i>Onobrychis</i><br><i>viciifolia</i>",
      "Comfrey" = "<i>Symphytum</i><br><i>officinale</i>"
    )
  ) +
  theme(
    axis.text.y = element_text(size = 10, color = "black"),
    #axis.text.x = element_blank(),
    axis.text.x = ggtext::element_markdown(size = 10, color = "black", vjust = 0.9),
    axis.title = element_text(size = 12, color = "black"),
    legend.position = "none"
  )
p1


yplot_p1 <- ggplot(
  df2.Anthophila[!is.na(df2.Anthophila$intertegular_distance),],
  aes(x = intertegular_distance, color = pollinator_group_sociality)
) +
  coord_flip()+
  geom_density(fill = NA, linewidth = 1) +
  scale_color_manual(
    values = custom_colors,
    labels = c("Honeybees", "Wild social bees", "Solitary bees")
  )+
  labs(
    x = "Body size",
    y = "",
    title = "(b)"
  ) +
  theme_classic(base_size = 14) +
  theme(
    axis.text = element_text(size = 10, color = "black"),
    axis.title = element_text(size = 12, color = "black"),
    #axis.text.y = element_blank(),
    #axis.ticks.y = element_blank(),
    legend.position = "top",
    legend.title = element_blank()
  )


yplot_p1

################################################################################################
#Violin PRL.wgt

dim(df2.Anthophila[!is.na(df2.Anthophila$PRL.wgt),])

p2 <- ggplot(
  df2.Anthophila[!is.na(df2.Anthophila$Proboscis_length.wgt),],
  aes(x = phytometer_plant, y = Proboscis_length.wgt, fill = phytometer_plant)
) +
  
  # Density-based scatter plot
  geom_sina(aes(color = phytometer_plant),
            alpha = 0.2,
            size = 4,
            maxwidth = 0.5,
            shape = 16) +
  
  # Boxplot
  geom_boxplot(
    width = 0.25,
    outlier.shape = NA,
    alpha = 0,
    color = "black"
  ) +
  
  # Custom color scale
  scale_fill_manual(values = custom_colors) +
  scale_color_manual(values = custom_colors) +
  
  # Axis layout
  scale_x_discrete(
    labels = c(
      "Carrot" = "<i>Daucus</i><br><i>carota</i>",
      "Radish" = "<i>Raphanus</i><br><i>sativus</i>",
      "Sainfoin" = "<i>Onobrychis</i><br><i>viciifolia</i>",
      "Comfrey" = "<i>Symphytum</i><br><i>officinale</i>"
    )
  ) +
  labs(y = "Relative tongue length", x = "", title = "(c)") +
  
  # Classic theme
  theme_classic(base_size = 14) +
  theme(
    axis.text.y = element_text(size = 10, color = "black"),
    axis.text.x = ggtext::element_markdown(size = 10, color = "black", vjust = 0.9),
    axis.title = element_text(size = 12, color = "black"),
    legend.position = "none"
  )
p2

yplot_p2 <- ggplot(
  df2.Anthophila[!is.na(df2.Anthophila$Proboscis_length.wgt),],
  aes(x = Proboscis_length.wgt, color = pollinator_group_sociality)
) +
  geom_density(
    fill = NA,
    linewidth = 1
  ) +
  scale_color_manual(values = custom_colors) +
  xlim(0, 4.5) +
  labs(x = "Relative tongue length", y = "", title = "(d)") +
  theme_classic(base_size = 14) +
  theme(
    axis.text = element_text(size = 10, color = "black"),
    #axis.text.y = element_blank(),
    #axis.ticks.y = element_blank(),
    #axis.title.y = element_blank(),
    axis.title = element_text(size = 12, color = "black"),
    #axis.title.x = element_text(size = 14, color = "black"),
    legend.position = "none"
  ) +
  coord_flip()

df3 <- subset(df2, df2$pollinator_group != "Anthophila")
library(ggtext)

p3 <- ggplot(
  df3[!is.na(df3$forewing_length),],
  aes(x = phytometer_plant, y = forewing_length, fill = phytometer_plant)
) +
  geom_sina(
    aes(color = phytometer_plant),
    alpha = 0.2,
    size = 4,
    maxwidth = 0.5,
    shape = 16
  ) +
  geom_boxplot(
    width = 0.25,
    outlier.shape = NA,
    alpha = 0.2,
    color = "black"
  ) +
  facet_wrap(~ pollinator_group, nrow = 1) +
  scale_fill_manual(values = custom_colors) +
  scale_color_manual(values = custom_colors) +
  scale_x_discrete(
    labels = c(
      "Carrot" = "<i>Daucus</i><br><i>carota</i>",
      "Radish" = "<i>Raphanus</i><br><i>sativus</i>",
      "Sainfoin" = "<i>Onobrychis</i><br><i>viciifolia</i>",
      "Comfrey" = "<i>Symphytum</i><br><i>officinale</i>"
    )
  ) +
  labs(
    y = "Body size (wing span) [mm]",
    x = NULL,
    title = "(e)"
  ) +
  theme_classic(base_size = 14) +
  theme(
    axis.text.x = ggtext::element_markdown(size = 10, color = "black", vjust = 0.9),
    axis.text.y = element_text(size = 10, color = "black"),
    axis.title = element_text(size = 12, color = "black"),
    strip.text = element_text(size = 12, face = "bold"),
    legend.position = "none"
  )

p3
p4 <- ggplot(
  df3[!is.na(df3$labellum_prementum_ratio),],
  aes(x = phytometer_plant, y = labellum_prementum_ratio, fill = phytometer_plant)
) +
  geom_sina(
    aes(color = phytometer_plant),
    alpha = 0.2,
    size = 4,
    maxwidth = 0.5,
    shape = 16
  ) +
  geom_boxplot(
    width = 0.25,
    outlier.shape = NA,
    alpha = 0.2,
    color = "black"
  ) +
  facet_wrap(~ pollinator_group, nrow = 1) +
  scale_fill_manual(values = custom_colors) +
  scale_color_manual(values = custom_colors) +
  scale_y_continuous(breaks = c(1, 2)) +
  scale_x_discrete(
    labels = c(
      "Carrot" = "<i>Daucus</i><br><i>carota</i>",
      "Radish" = "<i>Raphanus</i><br><i>sativus</i>",
      "Sainfoin" = "<i>Onobrychis</i><br><i>viciifolia</i>",
      "Comfrey" = "<i>Symphytum</i><br><i>officinale</i>"
    )
  ) +
  labs(
    y = "Labellum/prementum ratio",
    x = NULL,
    title = "(f)"
  ) +
  theme_classic(base_size = 14) +
  theme(
    axis.text.x = ggtext::element_markdown(size = 10, color = "black", vjust = 0.9),
    axis.text.y = element_text(size = 10, color = "black"),
    axis.title = element_text(size = 12, color = "black"),
    strip.text = element_text(size = 12, face = "bold"),
    legend.position = "none"
  )
p4

library(patchwork)
(p1 + yplot_p1)/(p2 + yplot_p2)/(p3 + p4)

(p1 + yplot_p1 + plot_layout(widths = c(2, 1))) /
  (p2 + yplot_p2 + plot_layout(widths = c(2, 1))) /
  (p3 + p4 + plot_layout(widths = c(2, 1)))

#note that the legend and the pictures were added in inkscape manually