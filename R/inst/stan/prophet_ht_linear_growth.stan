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
}

parameters {
  vector[N] k;                           // Base growth rate
  vector[N] m;                            // offset
  matrix[S, N] delta;                       // Rate adjustments
  real<lower=0> sigma_obs;               // Observation noise (incl. seasonal variation)
  matrix[K, N] beta;                    // seasonal vector
}

transformed parameters {
  matrix[S, N] gamma;                  // adjusted offsets, for piecewise continuity
  vector[N] ones;                   // vector consist of 1, for adding delta together

  for (i in 1:S) {
    gamma[i, ] = -t_change[i] * delta[i, ];
  }
  
  for (i in 1:N) {
    ones[i] = 1;
  }
}

model {
  //priors
  to_vector(k) ~ normal(0, 5);
  m ~ normal(0, 5);
  to_vector(delta) ~ double_exponential(0, tau);
  sigma_obs ~ normal(0, 0.5);
  to_vector(beta) ~ normal(0, sigma);

  // Likelihood
  {
    matrix[T, N] mu_y;                  // mean value for y
    mu_y[, 1] = (sum(k) + A * delta * ones) .* t + (sum(m) + A * gamma * ones) + X * beta * ones;
    for (n in 1:(N-1)) {
      mu_y[, (n+1)] = (k[n] + A * delta[,n]) .* t + (m[n] + A * gamma[,n]) + X * beta[,n];
    }
    y[, 1] ~ normal(mu_y[, 1], N * sigma_obs);
    to_vector(y[, 2:(N-1)]) ~ normal(to_vector(mu_y[, 2:(N-1)]), sigma_obs);
  }
}

