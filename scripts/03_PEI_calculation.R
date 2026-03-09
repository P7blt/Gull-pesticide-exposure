# ------------------------------------------------------------------------------
# Pesticide Exposure Index (PEI) calculation
# ------------------------------------------------------------------------------

# This script calculates the integrated pesticide exposure index (PEI)
# used in the study. The PEI integrates pesticide concentrations measured
# across multiple biological matrices.

library(dplyr)

# ------------------------------------------------------------------------------
# 1) Sum pesticide concentrations by sample
# ------------------------------------------------------------------------------
# Total pesticide exposure was calculated for each sample as the sum of all
# quantified pesticide concentrations. Concentrations below the limit of
# quantification (LOQ) were previously set to 0 and therefore do not contribute
# to the total.

Fusion <- Fusion %>%
  mutate(
    SumPest_row = rowSums(across(all_of(pest_cols_strict)), na.rm = TRUE)
  )

# ------------------------------------------------------------------------------
# 2) Aggregate pesticide burden by individual and biological matrix
# ------------------------------------------------------------------------------

sum_by_id_mat <- Fusion %>%
  group_by(ID, Matrice) %>%
  summarise(
    SumPest = sum(SumPest_row, na.rm = TRUE),
    .groups = "drop"
  )

# ------------------------------------------------------------------------------
# 3) Log-transform and standardize pesticide burden within each matrix
# ------------------------------------------------------------------------------
# Because pesticide concentrations differ in magnitude and units across
# biological matrices, summed concentrations were log10-transformed and
# standardized within each matrix using z-scores.

sum_by_id_mat <- sum_by_id_mat %>%
  mutate(
    SumPest_log = log10(SumPest + 1)
  ) %>%
  group_by(Matrice) %>%
  mutate(
    z = as.numeric(
      (SumPest_log - mean(SumPest_log, na.rm = TRUE)) /
        sd(SumPest_log, na.rm = TRUE)
    )
  ) %>%
  ungroup()

# ------------------------------------------------------------------------------
# 4) Integrated pesticide exposure index (PEI)
# ------------------------------------------------------------------------------
# The PEI was calculated for each individual by summing matrix-specific
# standardized values (z-scores).

exposure_index <- sum_by_id_mat %>%
  group_by(ID) %>%
  summarise(
    PEI = sum(z, na.rm = TRUE),
    PEI_mean = mean(z, na.rm = TRUE),
    n_matrices = dplyr::n(),
    .groups = "drop"
  )

# All individuals were expected to contribute the same set of matrices.
# Verify the number of matrices contributing to the index.

table(exposure_index$n_matrices)
