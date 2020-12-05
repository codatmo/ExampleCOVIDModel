library("cmdstanr")

# Run from command line: Rscript run.R
# If running from RStudio remember to set the working directory
# >Session>Set Working Directory>To Source File Location

# Simulate data with parameters we are trying to recover with one predictor

# Basline rate of COVID admissions to hospital 20 days out
true_base_infection_count_per_day_intercept <- 100

# Odd logic, if you call 111 50% chance of covid hospital admittance in 20 days
true_coefficient_111_call_count_beta <- .5 
true_std_dev_sigma <- 20

days_data_n <- 100
calls_111_x <- runif(days_data_n, 0, 1000)
cvd_hosp_20_d_y <- rnorm(days_data_n, 
                   true_base_infection_count_per_day_intercept
                   + true_coefficient_111_call_count_beta * calls_111_x, 
                   true_std_dev_sigma)

stan_data <- list(DAYS_DATA_N = days_data_n, 
                  calls_111_x = calls_111_x, 
                  cvd_hosp_20_d_y = cvd_hosp_20_d_y)

cat(sprintf(paste("simulation parameters are:",
                  "\ntrue_base_infection_count_per_day_intercept=%.1f",
                  "\ntrue_coefficient_111_call_count_beta=%.1f",
                  "\ntrue_std_dev_sigma=%.1f",
                  "\ndays_data_n=%d"),
            true_base_infection_count_per_day_intercept,
            true_coefficient_111_call_count_beta,
            true_std_dev_sigma, 
            days_data_n))

model <- cmdstan_model("stan/naive_linear_regression.stan")
fit <- model$sample(data = stan_data, output_dir = "output")
print(paste("ran stan executable: ", model$exe_file()))
print(fit$summary())

cat(sprintf(paste("simulation parameters are:",
                  "\ntrue_base_infection_count_per_day_intercept=%.1f",
                  "\ntrue_coefficient_111_call_count_beta=%.1f",
                  "\ntrue_std_dev_sigma=%.1f",
                  "\ndays_data_n=%d"),
            true_base_infection_count_per_day_intercept,
            true_coefficient_111_call_count_beta,
            true_std_dev_sigma, 
            days_data_n))

