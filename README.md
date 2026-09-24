# 🐝 Operation Pollination

### Beyond Abundance: Pollinator Functional Traits, Temporal Visitation Patterns, and Pollination Success in Urban Home Gardens

Hi, I'm **Lucas Cheng**, a Grade 12 student interested in ecology, mathematics, and quantitative approaches to biological questions.

**Operation Pollination** is my high-school research project exploring a question that became more complicated the longer I worked on it:

> **Beyond raw flower-visit counts, do the functional traits and temporal visitation patterns of pollinator communities help explain garden-level reproductive success, and do these relationships differ across flower types?**

Using an open ecological dataset collected across **24 home gardens in Zurich, Switzerland**, I examined pollinator abundance, community composition, morphology, and activity timing across four phytometer plant species: wild carrot, radish, sainfoin, and comfrey.

The project builds on previously published research showing that different pollinator groups predict reproductive success for different plants. My analysis asks what we can learn **beyond abundance** — particularly from the physical traits of visiting pollinators and from when those visits occur.

---

## 👋 Where should I start?

If you are visiting this repository for the first time, I recommend exploring it in this order:

### 1. For a 2-minute overview

📊 **[Read the Quad Chart](NAS_Beyond%20Abundance%20Pollinator%20Functional%20Trait%20Composition%20and%20Temporal%20Visitation%20Patterns%20as%20Predictors%20of%20Pollination%20Success%20in%20Urban%20Home%20Gardens_QuadChart.pdf)**

This gives the fastest overview of the research question, methodology, major analyses, and conclusions.

### 2. For the full scientific project

📄 **[Read the Research Paper](NAS_Beyond%20Abundance%20Pollinator%20Functional%20Trait%20Composition%20and%20Temporal%20Visitation%20Patterns%20as%20Predictors%20of%20Pollination%20Success%20in%20Urban%20Home%20Gardens_Paper.pdf)**

The paper contains the complete research rationale, statistical analysis, figures, discussion, limitations, and references.

### 3. For the data-processing logic

💻 **[`pollinator_master_table_v2.ipynb`](code/pollinator_master_table_v2.ipynb)**

This notebook converts the source datasets into the garden × plant master table used in the analysis.

It covers decisions including:

* constructing plant-specific pollination-success outcomes;
* aggregating observations to a common analytical level;
* grouping pollinator taxa;
* separating bee sociality categories;
* cleaning individual trait measurements;
* constructing community-level functional traits;
* deriving temporal visitation variables;
* running data-quality checks.

### 4. For the analysis and figures

📈 **[`pollinator_figures_v2.ipynb`](code/pollinator_figures_v2.ipynb)**

This notebook produces the descriptive, benchmark, trait, and temporal analyses used in the final project.

### 5. For the original ecological data

🌱 **[`rejichacko_etal_2025_envidat/`](rejichacko_etal_2025_envidat/)**

This directory contains the original open dataset and supporting materials from Reji Chacko, Moretti & Frey (2025), preserved in its original organization.

---

## 🌻 Study system

The source experiment placed four insect-pollinated phytometer species in each of 24 urban home gardens:

| Plant    | Scientific name         | General floral structure |
| -------- | ----------------------- | ------------------------ |
| Carrot   | *Daucus carota*         | Exposed floral resources |
| Radish   | *Raphanus sativus*      | Partly concealed         |
| Sainfoin | *Onobrychis viciifolia* | Concealed                |
| Comfrey  | *Symphytum officinale*  | Deeply concealed         |

This gradient makes the system particularly useful for testing **trait matching**.

For example, a long proboscis may provide little advantage on an open carrot flower but could become much more relevant when nectar is concealed deeper inside a flower.

This led me away from asking whether one kind of pollinator was universally "best" and toward asking whether **the importance of a pollinator trait depends on the flower it interacts with**.

---

## 🔬 What I analyzed

The project brings together four dimensions of the pollination system:

**Pollination success**
Plant reproductive outcomes, measured using plant-appropriate seed- or fruit-set metrics.

**Pollinator abundance and composition**
Total visitation and visits from bees, hoverflies, wasps, and beetles, with an additional breakdown of bee sociality.

**Functional traits**
Community-level summaries of traits such as bee proboscis length and body size.

**Temporal visitation patterns**
Morning, midday, and afternoon activity, peak visitation periods, active time windows, and temporal evenness.

The common analytical unit is:

> **one garden × one plant species**

With 24 gardens and four plant species, the final master table contains **96 garden–plant observations**.

---

## 📐 One methodological challenge: what does "pollination success" mean?

One of the first things I learned was that there was no universal pollination-success variable across the four plants.

Carrot reproductive success is represented using **mean seeds per umbel**, while the other plant systems primarily use **fruit-set proportions**.

I initially considered standardizing these outcomes onto a common numerical scale. I eventually decided against treating standardization as a solution to a biological difference.

A major lesson from the project was:

> **Mathematical comparability does not automatically imply biological comparability.**

For this reason, the analysis preserves plant-specific reproductive outcomes rather than pretending that all four represent exactly the same biological measurement.

---

## 🧹 From raw data to an analysis-ready table

The source data were collected at several different levels: individual insects, hourly visitation periods, branches, plants, umbels, and gardens.

To combine these datasets, I aggregated them to a common garden × plant level.

The simplified workflow is:

```text
Original EnviDat data
        │
        ├── pollination-success records
        ├── temporal visitation matrix
        ├── individual insect traits
        └── taxonomic metadata
        │
        ▼
Cleaning + biological interpretation
        │
        ▼
Aggregation to garden × plant
        │
        ├── reproductive outcome
        ├── abundance & composition
        ├── functional traits
        └── temporal variables
        │
        ▼
96-row master table
        │
        ▼
Statistical analysis + figures
```

Several seemingly small cleaning decisions also required biological interpretation.

For example, `0` in some trait columns indicated that a measurement was **not taken**, rather than a true trait value of zero. Nectar robbers were also excluded from pollinator trait summaries because their floral behavior may allow them to obtain nectar without normal contact with reproductive structures.

These decisions made me realize that data cleaning in ecology is not always just about formatting data. Sometimes it requires deciding what an observation actually means biologically.

---

## 📊 Analysis strategy

Rather than generating every possible pairwise correlation, I organized the analysis as a sequence of questions:

1. **What reproductive variation am I trying to explain?**
   Compare pollination success across gardens.

2. **Who visits each type of flower?**
   Describe pollinator community composition.

3. **Are those visitor communities functionally different?**
   Compare community-level body size and tongue length.

4. **Do functional traits relate to reproductive success?**
   Test trait-matching predictions across flower types.

5. **Does timing contain information beyond total visit counts?**
   Examine temporal visitation patterns.

6. **Can my processing recover previously published abundance relationships?**
   Use known pollinator-abundance relationships as a benchmark before interpreting novel associations.

This last step became especially important to me. Before trusting a new ecological signal, I wanted evidence that my pipeline could recover something that had already been observed.

My science mentor, **Lisa**, described this principle as:

> **Validation before novelty.**

---

## ⏰ Why examine timing?

Total visitation removes information about when pollinators arrive.

Two gardens could both receive 100 visits but have completely different activity patterns: one may receive visits steadily throughout the day, while the other receives almost all of them during a short morning period.

I therefore constructed variables describing morning, midday, and afternoon visitation, peak activity, and temporal evenness.

This allowed the project to treat **when pollinators visit** as another ecological dimension rather than simply as sampling metadata.

---

## ⚠️ Interpretation and limitations

This project is exploratory rather than causal.

There are only **24 gardens per plant species**, and I aggregate repeated observations into garden-level summaries. This simplifies the original repeated-measures structure.

The analysis also does not include every environmental covariate used in the published research, including factors such as surrounding urban densification and local floral richness.

For these reasons, I interpret statistical relationships as **associations**.

For example, a positive association between longer-tongued bee communities and reproductive success may be consistent with trait-matching theory, but it does not establish that tongue length alone caused the reproductive outcome.

One of the main lessons I took from the project was learning to separate:

> **What does the pattern show?**

from

> **Why do I think the pattern exists?**

---

## 📁 Repository structure

```text
operation-pollination/
│
├── README.md
├── .gitignore
│
├── NAS_Beyond Abundance ... _Paper.pdf
├── NAS_Beyond Abundance ... _QuadChart.pdf
│
├── code/
│   ├── pollinator_master_table_v2.ipynb
│   └── pollinator_figures_v2.ipynb
│
└── rejichacko_etal_2025_envidat/
    ├── 01_metadata/
    ├── 02_sampling_protocol/
    ├── 03_site_data/
    ├── 04_taxonomic_data/
    ├── 05_field_data/
    ├── 06_trait_data/
    ├── 07_pollination_success/
    ├── 08_scripts/
    └── README.txt
```

The two notebooks under `code/` contain my analysis workflow.

The `rejichacko_etal_2025_envidat/` directory contains the original dataset and materials supplied by the source authors and should be distinguished from my own analysis.

---

## 🌱 Original data

This project uses the open dataset:

**Reji Chacko, M., Moretti, M., & Frey, D. (2025).**
*A comprehensive dataset on pollinator diversity, visitation rates, individual-based traits, and pollination success across four plant species in an urban garden experiment.*

**EnviDat DOI:** `10.16904/envidat.676`

The dataset is distributed under **CC BY 4.0**.

Please cite the original dataset and associated publications when reusing these data.

The preserved source-data directory includes:

* metadata and dataset descriptions;
* English and German sampling protocols;
* garden-site information;
* taxonomic records;
* raw field observations;
* individual trait and temporal visitation data;
* pollination-success data;
* the original authors' R scripts.

---

## 👤 About me

I'm **Lucas Cheng**, a Grade 12 student interested in ecology, mathematics, statistics, and the way biological questions change when they are translated into quantitative variables.

This project began with a fairly simple question about which pollinators were most effective. Working through the data made me much more interested in a different question: **under what biological conditions does a particular visitor, trait, or visitation pattern actually matter?**

---

## 🤝 Science mentorship

This project was conducted with mentorship from **Lisa**, who supported the development of the research question and discussed methodology, interpretation, alternative analytical approaches, and limitations with me throughout the project.

A major goal of this repository is to preserve not only the final outputs but also the analytical reasoning behind them.

---

## 🤖 AI disclosure

AI tools were used as supporting tools during parts of this project.

Some **data-analysis code may have been developed or debugged with AI assistance**, with the resulting code reviewed and used as part of my own analysis workflow. AI was also used to **polish language and help organize written materials**, including research documentation and explanatory writing.

The research question, methodological decisions, scientific interpretations, selection and rejection of analytical approaches, and documented trials and errors are my own work.

---

## 🔗 Related materials

* 📄 [Full Research Paper](NAS_Beyond%20Abundance%20Pollinator%20Functional%20Trait%20Composition%20and%20Temporal%20Visitation%20Patterns%20as%20Predictors%20of%20Pollination%20Success%20in%20Urban%20Home%20Gardens_Paper.pdf)
* 📊 [Quad Chart](NAS_Beyond%20Abundance%20Pollinator%20Functional%20Trait%20Composition%20and%20Temporal%20Visitation%20Patterns%20as%20Predictors%20of%20Pollination%20Success%20in%20Urban%20Home%20Gardens_QuadChart.pdf)
* 💻 [Master Table Construction Notebook](code/pollinator_master_table_v2.ipynb)
* 📈 [Analysis & Figures Notebook](code/pollinator_figures_v2.ipynb)
* 🌱 [Original EnviDat Dataset](rejichacko_etal_2025_envidat/)
* 📰 [Medium research-process article](https://medium.com/@15652926286/beyond-pollinator-counts-how-i-built-a-trait-and-time-based-analysis-of-urban-pollination-59e52cac58b8)

---

*Operation Pollination — Lucas Cheng, 2026*
