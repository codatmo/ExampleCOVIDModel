data {
  int<lower = 0> N;           // number of data elements
  vector[N] x_calls_111;      // predictor vector
  vector[N] y_cvd_hosp;      // outcomes vector
  int<lower=0, upper=1> compute_likelihood; //controls whether likilihood is run
  int<lower=0, upper=1> compute_prediction;
}

transformed data {
  int P = compute_prediction ? N : 0; 
}

parameters {
  real beta_coef_111_call;
  real alpha_intercept;
  real<lower = 0> sigma_sd; 
}

model {
  alpha_intercept ~ normal(0,1000);
  beta_coef_111_call ~ normal(0, 2);
  sigma_sd ~ normal(500, 300);
  for (n in 1:N) {
    if (compute_likelihood == 1) {
      y_cvd_hosp[n] ~ normal(alpha_intercept + beta_coef_111_call * x_calls_111[n], 
                                sigma_sd); // likelihood
    }
  }
}

generated quantities {
  vector[P] y_cvd_hosp_pred;
    if (compute_prediction == 1) {
      for (p in 1:P) {
        y_cvd_hosp_pred[p] = normal_rng(alpha_intercept + beta_coef_111_call*x_calls_111[p],
                                        sigma_sd);
      }
    }
}


//    real alpha_intercept_uc = alpha_intercept * x_sd + x_mean;
//    real beta_coef_111_call_uc_us = beta_coef_111_call * x_sd + x_mean;
//    real[N] y_cvd_hosp_z_pred = normal_rng(alpha_intercept + beta_coef_111_call * x_111_calls_z, sigma_sd);
//    real y_cvd_hosp_pred = y_cvd_hosp_z_pred*y_sd + y_mean;
// }
