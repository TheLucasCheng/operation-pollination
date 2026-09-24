This repository includes all data presented in the paper:

Reji Chacko, M., Moretti, M., and Frey, D. (2025). A comprehensive dataset on pollinator diversity, visitation rates, individual-based traits, and pollination success across four plant species in an urban garden experiment. [DOI]

The repository contains eight directories, organised as follows:

data/
├── 01_metadata/  # Detailed descriptions of each dataset in this repository
│   └── data_description.xlsx
├── 02_sampling_protocol/  # Field sampling protocols in German (original) and English (translation)
│   ├── protocol_english.pdf
│   └── protocol_german.pdf
├── 03_site_data/  # Garden site coordinates
│   └── garden_site_coordinates.csv
├── 04_taxonomic_data/  # Taxonomic checklist of observed species
│   └── taxa_checklist.csv
├── 05_field_data/  # Raw field sampling data
│   └── raw_sampling_data.xlsx
├── 06_trait_data/  # Individual-level traits and flower visitation matrix
│   ├── individual_traits.csv
│   └── species_temporal_flower_visitation_matrix.csv
├── 07_pollination_success/  # Seed and fruit set per phytometer species
│   ├── daucus_carota_seed_set.csv
│   ├── onobrychis_viciifolia_fruit_set.csv
│   ├── raphanus_sativus_fruit_set.csv
│   ├── raphanus_sativus_seed_set.csv
│   ├── symphytum_officinale_fruit_set.csv
│   └── symphytum_officinale_seed_set.csv
├── 08_scripts/  # R scripts to reproduce figures and Table 2 from the paper
│   ├── figure_1.R
│   ├── figure_2.R
│   ├── figure_3.R
│   ├── figure_4.R
│   └── table_2.R
└── README.txt  # This file

Note: The metadata Excel file contains a separate sheet describing each dataset, so individual file descriptions are not repeated here.
