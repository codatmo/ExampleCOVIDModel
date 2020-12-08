library("cmdstanr")

# Run from command line: Rscript run.R
# If running from RStudio remember to set the working directory
# >Session>Set Working Directory>To Source File Location

# Simulate data with parameters we are trying to recover with one predictor


generate_data <- function() {
  true_coefficient_111_call_count_beta <- .5 
  true_std_dev_sigma <- 20
  days_data_n <- 100
  calls_111_x <- runif(days_data_n, 0, 1000)
  cvd_hosp_20_d_y <- rnorm(days_data_n, 
                     + true_coefficient_111_call_count_beta * calls_111_x, 
                     true_std_dev_sigma)

  stan_data <- list(DAYS_DATA_N = days_data_n, 
                    calls_111_x = calls_111_x, 
                    cvd_hosp_20_d_y = cvd_hosp_20_d_y)
  cat(sprintf(paste("simulation parameters are:",
                       "\ntrue_coefficient_111_call_count_beta=%.1f",
                       "\ntrue_std_dev_sigma=%.1f",
                       "\ndays_data_n=%d\n"),
                 true_coefficient_111_call_count_beta,
                 true_std_dev_sigma, 
                 days_data_n))
  
  return(stan_data)
}

compile_run <- function(data) {
  model <- cmdstan_model("stan/naive_linear_regression.stan")
  fit <- model$sample(data = data, output_dir = "output")
  return(fit)
}

stan_data <- generate_data()
fit <- compile_run(data = stan_data)
print(fit)

