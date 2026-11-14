# One row per synthetic index hospitalization for myocardial infarction.
# Outcome = 1 for any ED visit or rehospitalization within 30 days of discharge.
# Run with Rscript generate_mi_encounters.R to write the CSV beside this file.
# When sourced interactively, the CSV is written to the working directory.

set.seed(20261113)
n <- 1000L

# Select the highest scores so the specified marginal counts are exact.
top_cases <- function(score, count) {
  as.integer(rank(-score, ties.method = "first") <= count)
}

# Sex: 0 = female, 1 = male. Age is in completed years.
sex <- sample(rep(0:1, times = c(400L, 600L)))
mean_age <- 68 + 3 * (0.6 - sex)
lower <- pnorm(17.5, mean_age, 14)
upper <- pnorm(105.5, mean_age, 14)
age <- as.integer(round(qnorm(runif(n, lower, upper), mean_age, 14)))
age_decades <- (age - 68) / 10

# Income quintile is categorical: 1 = lowest, 5 = highest.
incomeQuintile <- factor(sample(rep(1:5, each = n / 5)), levels = 1:5)
lower_income <- 3 - as.integer(incomeQuintile)

# A shared risk factor induces clustering, while disease-specific noise
# allows each history to occur on its own. For all histories, 1 = present.
shared_risk <- rnorm(n)
dm <- top_cases(0.25 * age_decades + 0.70 * shared_risk +
                  0.12 * lower_income + rnorm(n), 300L)
ckd <- top_cases(0.40 * age_decades + 0.55 * shared_risk +
                   0.65 * dm + rnorm(n), 100L)
htn <- top_cases(0.45 * age_decades + 0.65 * shared_risk +
                   0.45 * dm + rnorm(n), 800L)

# Illustrative risk weights, with independent logistic noise to retain
# overlap between groups. Select exactly 200 encounters.
encounter_risk <- 0.28 * age_decades + 0.55 * dm + 0.85 * ckd +
                  0.40 * htn + 0.18 * lower_income
Outcome <- top_cases(encounter_risk + rlogis(n), 200L)

encounters <- data.frame(Outcome, age, sex, dm, ckd, htn, incomeQuintile)
stopifnot(nrow(encounters) == 1000L, !anyNA(encounters),
          all(age >= 18L & age <= 105L), sum(sex) == 600L,
          sum(dm) == 300L, sum(ckd) == 100L, sum(htn) == 800L,
          sum(Outcome) == 200L, all(table(incomeQuintile) == 200L))

script_arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
output_dir <- if (length(script_arg)) {
  dirname(normalizePath(sub("^--file=", "", script_arg[1])))
} else {
  getwd()
}
write.csv(encounters, file.path(output_dir, "mi_encounters.csv"), row.names = FALSE)
