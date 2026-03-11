# Gull pesticide exposure

R scripts used in the study:

"Agricultural fields as a double-edged foraging resource: greater use results in elevated pesticide exposure in omnivorous gulls"

## Description

This repository contains R scripts used to calculate the pesticide exposure index (PEI) and perform statistical analyses linking pesticide exposure to foraging behaviour in ring-billed gulls.

## Pesticide Exposure Index (PEI)

Pesticide exposure was quantified using an integrated pesticide exposure index (PEI). For each ring-billed gull and biological matrix (plasma, guano, stomach content, and liver), total pesticide burden was calculated as the sum of all quantified pesticide concentrations. Concentrations below the limit of quantification (LOQ) were set to zero and therefore did not contribute to the total.

Summed concentrations were log10-transformed to stabilize variance. Because pesticide concentrations differed in magnitude and units across matrices, log-transformed values were standardized within each matrix using z-scores.

The integrated pesticide exposure index (PEI) was calculated for each individual by summing the standardized z-scores across matrices.

The PEI therefore represents a relative index of pesticide exposure integrating multiple biological matrices rather than a direct estimate of whole-body pesticide burden.

## Repository structure

├── PEI_calculation.R       # Calculates the integrated pesticide exposure index
├── statistical_analyses.R  # Statistical models linking PEI to foraging behaviour
└── README.md
