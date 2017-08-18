

packageStartupMessage('Compiling models (this will take a minute...)')

dest <- file.path(R_PACKAGE_DIR, paste0('libs', R_ARCH))
dir.create(dest, recursive = TRUE, showWarnings = FALSE)

packageStartupMessage(paste('Writing models to:', dest))
packageStartupMessage(paste('Compiling using binary:', R.home('bin')))

logistic.growth.src <- file.path(R_PACKAGE_SOURCE, 'inst', 'stan', 'prophet_logistic_growth.stan')
logistic.growth.binary <- file.path(dest, 'prophet_logistic_growth.RData')
logistic.growth.stanc <- rstan::stanc(logistic.growth.src)
logistic.growth.stanm <- rstan::stan_model(stanc_ret = logistic.growth.stanc,
                                           model_name = 'logistic_growth')
save('logistic.growth.stanm', file = logistic.growth.binary)

linear.growth.src <- file.path(R_PACKAGE_SOURCE, 'inst', 'stan', 'prophet_linear_growth.stan')
linear.growth.binary <- file.path(dest, 'prophet_linear_growth.RData')
linear.growth.stanc <- rstan::stanc(linear.growth.src)
linear.growth.stanm <- rstan::stan_model(stanc_ret = linear.growth.stanc,
                                         model_name = 'linear_growth')
save('linear.growth.stanm', file = linear.growth.binary)

ht.linear.growth.src <- file.path(R_PACKAGE_SOURCE, 'inst', 'stan', 'prophet_ht_linear_growth.stan')
ht.linear.growth.binary <- file.path(dest, 'prophet_ht_linear_growth.RData')
ht.linear.growth.stanc <- rstan::stanc(ht.linear.growth.src)
ht.linear.growth.stanm <- rstan::stan_model(stanc_ret = ht.linear.growth.stanc,
                                         model_name = 'ht_linear_growth')
save(ht.linear.growth.stanm, file = 'ht.linear.growth.binary')


ht.linear.cov.growth.src <- file.path(R_PACKAGE_SOURCE, 'inst', 'stan', 'prophet_ht_linear_cov_growth.stan')
ht.linear.cov.growth.binary <- file.path(dest, 'prophet_ht_linear_cov_growth.RData')
ht.linear.cov.growth.stanc <- rstan::stanc(ht.linear.cov.growth.src)
ht.linear.cov.growth.stanm <- rstan::stan_model(stanc_ret = ht.linear.cov.growth.stanc,
                                         model_name = 'ht_linear_cov_growth')
save(ht.linear.cov.growth.stanm, file = 'ht.linear.growth.cov.binary')

ht.logistic.growth.src <- file.path(R_PACKAGE_SOURCE, 'inst', 'stan', 'prophet_ht_logistic_growth.stan')
ht.logistic.growth.binary <- file.path(dest, 'prophet_ht_logistic_growth.RData')
ht.logistic.growth.stanc <- rstan::stanc(ht.logistic.growth.src)
ht.logistic.growth.stanm <- rstan::stan_model(stanc_ret = ht.logistic.growth.stanc,
                                         model_name = 'ht_logistic_growth')
save(ht.logistic.growth.stanm, file = 'ht.logistic.growth.binary')

ht.logistic.cov.growth.src <- file.path(R_PACKAGE_SOURCE, 'inst', 'stan', 'prophet_ht_logistic_cov_growth.stan')
ht.logistic.cov.growth.binary <- file.path(dest, 'prophet_ht_logistic_cov_growth.RData')
ht.logistic.cov.growth.stanc <- rstan::stanc(ht.logistic.cov.growth.src)
ht.logistic.cov.growth.stanm <- rstan::stan_model(stanc_ret = ht.logistic.cov.growth.stanc,
                                         model_name = 'ht_logistic_cov_growth')
save(ht.logistic.cov.growth.stanm, file = 'ht.logistic.cov.growth.binary')

ht.logistic.cap.growth.src <- file.path(R_PACKAGE_SOURCE, 'inst', 'stan', 'prophet_ht_logistic_cap_growth.stan')
ht.logistic.cap.growth.binary <- file.path(dest, 'prophet_ht_logistic_cap_growth.RData')
ht.logistic.cap.growth.stanc <- rstan::stanc(ht.logistic.cap.growth.src)
ht.logistic.cap.growth.stanm <- rstan::stan_model(stanc_ret = ht.logistic.cap.growth.stanc,
                                         model_name = 'ht_logistic_cap_growth')
save(ht.logistic.cap.growth.stanm, file = 'ht.logistic.cap.growth.binary')

ht.logistic.cap.cov.growth.src <- file.path(R_PACKAGE_SOURCE, 
                                            'inst', 'stan', 
                                            'prophet_ht_logistic_cap_cov_growth.stan')
ht.logistic.cap.cov.growth.binary <- file.path(dest, 'prophet_ht_logistic_cap_cov_growth.RData')
ht.logistic.cap.cov.growth.stanc <- rstan::stanc(ht.logistic.cap.cov.growth.src)
ht.logistic.cap.cov.growth.stanm <- rstan::stan_model(stanc_ret = ht.logistic.cap.cov.growth.stanc,
                                         model_name = 'ht_logistic_cap_cov_growth')
save(ht.logistic.cap.cov.growth.stanm, file = 'ht.logistic.cap.cov.growth.binary')

packageStartupMessage('------ Models successfully compiled!')
packageStartupMessage('You can ignore any compiler warnings above.')
