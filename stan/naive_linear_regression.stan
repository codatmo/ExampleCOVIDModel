data {
  int<lower = 0> DAYS_DATA_N;           // number of data elements
  vector[DAYS_DATA_N] calls_111_x;      // predictor vector
  vector[DAYS_DATA_N] cvd_hosp_20_d_y;      // outcomes vector
}

parameters {
  real base_infection_count_per_day_intercept; // intercept
  real coefficient_111_call_count_beta; // slope, predictor coefficient
  real<lower = 0> std_dev_sigma; // error scale
}

model {
  base_infection_count_per_day_intercept ~ normal(0, 1); // priors
  coefficient_111_call_count_beta ~ normal(0, 1);
  std_dev_sigma ~ normal(0, 1);
  for (n in 1:DAYS_DATA_N) {
    cvd_hosp_20_d_y[n] ~ normal(base_infection_count_per_day_intercept
                                + coefficient_111_call_count_beta * calls_111_x[n], 
                                std_dev_sigma); // likelihood
  }
}
