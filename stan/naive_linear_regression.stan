functions {
  void print_stats(vector values) {
    print("sd:",sd(values), " mean:",mean(values));
  }
}

data {
  int<lower = 0> DAYS_DATA_N;           // number of data elements
  vector[DAYS_DATA_N] calls_111_x;      // predictor vector
  vector[DAYS_DATA_N] cvd_hosp_20_d_y;      // outcomes vector
  int<lower=0,upper=1> run_sbc;
}

transformed data {
  vector[DAYS_DATA_N] calls_111_x_sim;
  vector[DAYS_DATA_N] cvd_hosp_20_d_y_sim;
  real coefficient_111_call_count_beta_sim = .5;
  real std_dev_sigma_sim = 20;
     //print("generating data for SBC, ignoring any supplied data");
     for (n in 1:DAYS_DATA_N) {
       calls_111_x_sim[n] = uniform_rng(0,1000);
       cvd_hosp_20_d_y_sim[n] = normal_rng(calls_111_x_sim[n] * coefficient_111_call_count_beta_sim,
                                     std_dev_sigma_sim);
     }
  }
  //calls_111_x_sim = calls_111_x;
  //cvd_hosp_20_d_y_sim = cvd_hosp_20_d_y;
  print("hosp",cvd_hosp_20_d_y);
  print_stats(cvd_hosp_20_d_y);
  print("hosp sim",cvd_hosp_20_d_y_sim);
  print_stats(cvd_hosp_20_d_y_sim);
  print("calls",calls_111_x);
  print_stats(calls_111_x);
  print("calls sim",calls_111_x_sim);
  print_stats(calls_111_x_sim);
  // print("outside_data");
  // print("calls",calls_111_x);
  // print("hosp",cvd_hosp_20_d_y);
}

parameters {
  real coefficient_111_call_count_beta; // slope, predictor coefficient
  real<lower = 0> std_dev_sigma; // error scale
  real coefficient_111_call_count_beta_2; // slope, predictor coefficient
  real<lower = 0> std_dev_sigma_2; // error scale
}

model {
  coefficient_111_call_count_beta ~ normal(0, 1);
  std_dev_sigma ~ normal(0, 1);
  for (n in 1:DAYS_DATA_N) {
    if (run_sbc > 0) {
      cvd_hosp_20_d_y_sim[n] ~ normal(coefficient_111_call_count_beta_2 * calls_111_x_sim[n], 
                                std_dev_sigma_2); // likelihood
    }
    
    cvd_hosp_20_d_y[n] ~ normal(coefficient_111_call_count_beta * calls_111_x[n], 
                                std_dev_sigma);
    
  }
}

generated quantities {
  int<lower=0,upper=1> lt_coefficient_111_call_count_beta = 1;
  int<lower=0,upper=1> lt_std_dev_sigma =1;
  if (run_sbc < 0) {
   lt_coefficient_111_call_count_beta = 
                        coefficient_111_call_count_beta < 
                        coefficient_111_call_count_beta_sim;
   lt_std_dev_sigma =  std_dev_sigma <  std_dev_sigma_sim;  
  }
}
