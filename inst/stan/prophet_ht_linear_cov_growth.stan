data {
  int T;                                // Sample size
  int N;                                // Number of Time-series
  int<lower=1> K;                       // Number of seasonal vectors
  vector[T] t;                            // Day
  matrix[T, N] y;                            // Time-series
  int S;                                // Number of changepoints
  matrix[T, S] A;                   // Split indicators
  real t_change[S];                 // Index of changepoints
  matrix[T,K] X;                     // season vectors
  real<lower=0> sigma;              // scale on seasonality prior
  real<lower=0> tau;                  // scale on changepoints prior
  real<lower=0> cauchy_scale;          //scale on Cauchy prior of Tau
  real<lower=0> lkj_scale;            // scale on lkj
}

parameters {
  vector[N] m;                            // offset
  matrix[S, N] delta;                       // Rate adjustments
  real<lower=0> sigma_obs;               // Observation noise (incl. seasonal variation)
  matrix[K, N] beta;                    // seasonal vector
  vector[N] z;                          // standard normal random variable
  vector<lower=0,upper=pi()/2>[N] tau_unif;
  cholesky_factor_corr[N] L_Omega;      // Cholesky factor for k covariance matrix
}

transformed parameters {
  matrix[S, N] gamma;                  // adjusted offsets, for piecewise continuity
  vector<lower=0>[N] Tau;                        // prior scale for k
  vector[N] k;                           // Base growth rate
  
  for (n in 1:N) Tau[n] = cauchy_scale * tan(tau_unif[n]);

  for (i in 1:S) {
    gamma[i, ] = -t_change[i] * delta[i, ];
  }
  
  k = diag_pre_multiply(Tau, L_Omega) * z;
}

model {
  //priors
  z ~ normal(0, 1);
  m ~ normal(0, 5);
  to_vector(delta) ~ double_exponential(0, tau);
  sigma_obs ~ normal(0, 0.5);
  to_vector(beta) ~ normal(0, sigma);
  L_Omega ~ lkj_corr_cholesky(lkj_scale);

  // Likelihood
  {
    matrix[T, N] mu_y;                  // mean value for y
    for (n in 1:N) {
      mu_y[, n] = (k[n] + A * delta[,n]) .* t + (m[n] + A * gamma[,n]) + X * beta[,n];
    }
    to_vector(y) ~ normal(to_vector(mu_y), sigma_obs);
  }
}

